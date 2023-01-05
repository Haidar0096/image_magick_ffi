part of 'image_magick_ffi.dart';

/// Signature for a callback to be called when the process's progress changes.
/// - [info] The progress information.
/// - [offset] The offset of the progress.
/// - [size] The total size of the progress.
/// - [clientData] The user-provided data.
typedef MagickProgressMonitor = void Function(String info, int offset, int size, dynamic clientData);

/// The [MagickWand] can do operations on images like reading, resizing, writing,cropping an image, etc...
///
/// Initialize an instance of it with [MagickWand.newMagickWand].
/// When done from it, call [destroyMagickWand] to release the resources.
/// See `https://imagemagick.org/script/magick-wand.php` for more information about the backing C-API.
class MagickWand {
  Pointer<Void> _wandPtr;

  /// ReceivePort to receive progress information from the C side.
  ReceivePort? _progressMonitorReceivePort;

  /// Pointer to the send port of [_progressMonitorReceivePort].
  Pointer<IntPtr>? _progressMonitorReceivePortSendPortPtr;

  /// Stream subscription of the stream of [_progressMonitorReceivePort].
  StreamSubscription? _progressMonitorReceivePortStreamSubscription;

  /// Stream subscription of the stream of [_progressMonitorStreamController].
  StreamSubscription? _progressMonitorStreamControllerStreamSubscription;

  /// Used to convert the stream of [_progressMonitorReceivePort] to a broadcast stream.
  StreamController<dynamic>? _progressMonitorStreamController;

  MagickWand._(this._wandPtr);

  /// Clears resources associated with this wand, leaving the wand blank, and ready to be used for a new
  /// set of images.
  void clearMagickWand() => _bindings.clearMagickWand(_wandPtr);

  /// Makes an exact copy of this wand.
  MagickWand cloneMagickWand() => MagickWand._(_bindings.cloneMagickWand(_wandPtr));

  /// Deallocates memory associated with this wand. You can't use the wand after calling this function.
  Future<void> destroyMagickWand() async {
    _wandPtr = _bindings.destroyMagickWand(_wandPtr);

    // clean up the streams and stream subscriptions of the progress monitor
    _progressMonitorReceivePort?.close();
    if (_progressMonitorReceivePortSendPortPtr != null) {
      malloc.free(_progressMonitorReceivePortSendPortPtr!);
    }
    await _progressMonitorReceivePortStreamSubscription?.cancel();
    await _progressMonitorStreamControllerStreamSubscription?.cancel();
    await _progressMonitorStreamController?.close();
  }

  /// Returns true if this wand is verified as a magick wand. For example, after calling
  /// [destroyMagickWand] on this wand, then this method will return false.
  bool isMagickWand() => _bindings.isMagickWand(_wandPtr);

  /// Clears any exceptions associated with this wand.
  bool magickClearException() => _bindings.magickClearException(_wandPtr);

  /// Returns the severity, reason, and description of any error that occurs when using other methods
  /// with this wand. For example, failure to read an image using [magickReadImage] will cause an exception
  /// to be associated with this wand and which can be retrieved by this method.
  ///
  /// - Note: if no exception has occurred, `UndefinedExceptionType` is returned.
  MagickGetExceptionResult magickGetException() => using((Arena arena) {
        final Pointer<Int> severity = arena();
        final Pointer<Char> description = _bindings.magickGetException(_wandPtr, severity);
        final MagickGetExceptionResult magickGetExceptionResult = MagickGetExceptionResult(
          ExceptionType.fromValue(severity.value),
          description.cast<Utf8>().toDartString(),
        );
        _magickRelinquishMemory(description.cast());
        return magickGetExceptionResult;
      });

  /// Returns the exception type associated with this wand.
  /// If no exception has occurred, `UndefinedException` is returned.
  ExceptionType magickGetExceptionType() => ExceptionType.fromValue(_bindings.magickGetExceptionType(_wandPtr));

  /// Returns the position of the iterator in the image list.
  int magickGetIteratorIndex() => _bindings.magickGetIteratorIndex(_wandPtr);

  /// Returns a 13 element array representing the following font metrics:
  ///
  ///     Element Description
  ///     -------------------------------------------------
  ///     0 character width
  ///     1 character height
  ///     2 ascender
  ///     3 descender
  ///     4 text width
  ///     5 text height
  ///     6 maximum horizontal advance
  ///     7 bounding box: x1
  ///     8 bounding box: y1
  ///     9 bounding box: x2
  ///     10 bounding box: y2
  ///     11 origin: x
  ///     12 origin: y
  /// - Note: null is returned if the font metrics cannot be determined from the given input (for ex: if
  /// the [MagickWand] contains no images).
  Float64List? magickQueryFontMetrics(DrawingWand drawingWand, String text) => using((Arena arena) {
        final Pointer<Char> textPtr = text.toNativeUtf8(allocator: arena).cast();
        final Pointer<Double> metricsPtr = _bindings.magickQueryFontMetrics(_wandPtr, drawingWand._wandPtr, textPtr);
        if (metricsPtr == nullptr) {
          return null;
        }
        final Float64List metrics = metricsPtr.asTypedList(13);
        _MagickRelinquishableResource.registerRelinquishable(metrics, metricsPtr.cast());
        return metrics;
      });

  /// Returns a 13 element array representing the following font metrics:
  ///
  ///     Element Description
  ///     -------------------------------------------------
  ///     0 character width
  ///     1 character height
  ///     2 ascender
  ///     3 descender
  ///     4 text width
  ///     5 text height
  ///     6 maximum horizontal advance
  ///     7 bounding box: x1
  ///     8 bounding box: y1
  ///     9 bounding box: x2
  ///     10 bounding box: y2
  ///     11 origin: x
  ///     12 origin: y
  /// This method is like magickQueryFontMetrics() but it returns the maximum text width and height for
  /// multiple lines of text.
  /// - Note: null is returned if the font metrics cannot be determined from the given input (for ex: if the
  /// [MagickWand] contains no images).
  Float64List? magickQueryMultilineFontMetrics(DrawingWand drawingWand, String text) => using((Arena arena) {
        final Pointer<Char> textPtr = text.toNativeUtf8(allocator: arena).cast();
        final Pointer<Double> metricsPtr =
            _bindings.magickQueryMultilineFontMetrics(_wandPtr, drawingWand._wandPtr, textPtr);
        if (metricsPtr == nullptr) {
          return null;
        }
        final Float64List metrics = metricsPtr.asTypedList(13);
        _MagickRelinquishableResource.registerRelinquishable(metrics, metricsPtr.cast());
        return metrics;
      });

  /// Resets the wand iterator.
  ///
  /// It is typically used either before iterating though images, or before calling specific functions such as
  /// `magickAppendImages()` to append all images together.
  ///
  /// Afterward you can use `magickNextImage()` to iterate over all the images in a wand container, starting
  /// with the first image.
  ///
  /// Using this before `magickAddImages()` or `magickReadImages()` will cause new images to be inserted
  /// between the first and second image.
  void magickResetIterator() => _bindings.magickResetIterator(_wandPtr);

  /// Sets the wand iterator to the first image.
  ///
  /// After using any images added to the wand using `magickAddImage()` or `magickReadImage()` will be
  /// prepended before any image in the wand.
  ///
  /// Also the current image has been set to the first image (if any) in the Magick Wand. Using
  /// `magickNextImage()` will then set the current image to the second image in the list (if present).
  ///
  /// This operation is similar to `magickResetIterator()` but differs in how `magickAddImage()`,
  /// `magickReadImage()`, and magickNextImage()` behaves afterward.
  void magickSetFirstIterator() => _bindings.magickSetFirstIterator(_wandPtr);

  /// Sets the iterator to the given position in the image list specified with the index parameter.
  /// A zero index will set the first image as current, and so on. Negative indexes can be used to
  /// specify an image relative to the end of the images in the wand, with -1 being the last image
  /// in the wand.
  ///
  /// If the index is invalid (range too large for number of images in wand) the function will return
  /// false, but no 'exception' will be raised, as it is not actually an error. In that case the current
  /// image will not change.
  ///
  /// After using any images added to the wand using `magickAddImage()` or `magickReadImage()` will be
  /// added after the image indexed, regardless of if a zero (first image in list) or negative index
  /// (from end) is used.
  ///
  /// Jumping to index 0 is similar to `magickResetIterator()` but differs in how `magickNextImage()`
  /// behaves afterward.
  bool magickSetIteratorIndex(int index) => _bindings.magickSetIteratorIndex(_wandPtr, index);

  /// Sets the wand iterator to the last image.
  ///
  /// The last image is actually the current image, and the next use of `magickPreviousImage()` will not
  /// change this allowing this function to be used to iterate over the images in the reverse direction.
  /// In this sense it is more like `magickResetIterator()` than `magickSetFirstIterator()`.
  ///
  /// Typically this function is used before `magickAddImage()`, `magickReadImage()` functions to ensure'
  /// new images are appended to the very end of wand's image list.
  void magickSetLastIterator() => _bindings.magickSetLastIterator(_wandPtr);

  /// Returns a wand required for all other methods in the API.
  /// A fatal exception is thrown if there is not enough memory to allocate the wand.
  /// Use `destroyMagickWand()` to dispose of the wand when it is no longer needed.
  factory MagickWand.newMagickWand() => MagickWand._(_bindings.newMagickWand());

  /// Returns a wand with an image.
  factory MagickWand.newMagickWandFromImage(Image image) =>
      MagickWand._(_bindings.newMagickWandFromImage(image._imagePtr));

  /// Deletes a wand artifact.
  bool magickDeleteImageArtifact(String artifact) => using(
      (Arena arena) => _bindings.magickDeleteImageArtifact(_wandPtr, artifact.toNativeUtf8(allocator: arena).cast()));

  /// Deletes a wand property.
  bool magickDeleteImageProperty(String property) => using(
      (Arena arena) => _bindings.magickDeleteImageProperty(_wandPtr, property.toNativeUtf8(allocator: arena).cast()));

  /// Deletes a wand option.
  bool magickDeleteOption(String option) =>
      using((Arena arena) => _bindings.magickDeleteOption(_wandPtr, option.toNativeUtf8(allocator: arena).cast()));

  /// Returns the antialias property associated with the wand.
  bool magickGetAntialias() => _bindings.magickGetAntialias(_wandPtr);

  /// Returns the wand background color.
  PixelWand magickGetBackgroundColor() => PixelWand._(_bindings.magickGetBackgroundColor(_wandPtr));

  /// Gets the wand colorspace type.
  ColorspaceType magickGetColorspace() => ColorspaceType.values[_bindings.magickGetColorspace(_wandPtr)];

  /// Gets the wand compression type.
  CompressionType magickGetCompression() => CompressionType.values[_bindings.magickGetCompression(_wandPtr)];

  /// Gets the wand compression quality.
  int magickGetCompressionQuality() => _bindings.magickGetCompressionQuality(_wandPtr);

  /// Returns the filename associated with an image sequence.
  String magickGetFilename() => _bindings.magickGetFilename(_wandPtr).cast<Utf8>().toDartString();

  /// Returns the font associated with the MagickWand.
  String? magickGetFont() {
    final Pointer<Char> fontPtr = _bindings.magickGetFont(_wandPtr);
    if (fontPtr == nullptr) {
      return null;
    }
    final String result = fontPtr.cast<Utf8>().toDartString();
    _bindings.magickRelinquishMemory(fontPtr.cast());
    return result;
  }

  /// Returns the format of the magick wand.
  String magickGetFormat() => _bindings.magickGetFormat(_wandPtr).cast<Utf8>().toDartString();

  /// Gets the wand gravity.
  GravityType magickGetGravity() => GravityType.fromValue(_bindings.magickGetGravity(_wandPtr));

  /// Returns a value associated with the specified artifact.
  String? magickGetImageArtifact(String artifact) => using((Arena arena) {
        final Pointer<Char> artifactPtr = artifact.toNativeUtf8(allocator: arena).cast();
        final Pointer<Char> resultPtr = _bindings.magickGetImageArtifact(_wandPtr, artifactPtr);
        if (resultPtr == nullptr) {
          return null;
        }
        final String result = resultPtr.cast<Utf8>().toDartString();
        _bindings.magickRelinquishMemory(resultPtr.cast());
        return result;
      });

  /// Returns all the artifact names that match the specified pattern associated with a wand.
  /// Use `magickGetImageProperty()` to return the value of a particular artifact.
  List<String>? magickGetImageArtifacts(String pattern) => using((Arena arena) {
        final Pointer<Char> patternPtr = pattern.toNativeUtf8(allocator: arena).cast();
        final Pointer<Size> numArtifactsPtr = arena();
        final Pointer<Pointer<Char>> artifactsPtr =
            _bindings.magickGetImageArtifacts(_wandPtr, patternPtr, numArtifactsPtr);
        final int numArtifacts = numArtifactsPtr.value;
        final List<String>? result = artifactsPtr.toStringList(numArtifacts);
        _bindings.magickRelinquishMemory(artifactsPtr.cast());
        return result;
      });

  /// Returns the named image profile.
  List<int>? magickGetImageProfile(String name) => using((Arena arena) {
        final Pointer<Char> namePtr = name.toNativeUtf8(allocator: arena).cast();
        final Pointer<Size> lengthPtr = arena();
        final Pointer<UnsignedChar> profilePtr = _bindings.magickGetImageProfile(_wandPtr, namePtr, lengthPtr);
        final int length = lengthPtr.value;
        final List<int>? profile = profilePtr.toIntList(length);
        _magickRelinquishMemory(profilePtr.cast());
        return profile;
      });

  /// MagickGetImageProfiles() returns all the profile names that match the specified pattern associated
  /// with a wand. Use `magickGetImageProfile()` to return the value of a particular property.
  /// - Note: An empty list is returned if there are no results.
  List<String>? magickGetImageProfiles(String pattern) => using((Arena arena) {
        final Pointer<Char> patternPtr = pattern.toNativeUtf8(allocator: arena).cast();
        final Pointer<Size> numProfilesPtr = arena();
        final Pointer<Pointer<Char>> profilesPtr =
            _bindings.magickGetImageProfiles(_wandPtr, patternPtr, numProfilesPtr);
        final int numProfiles = numProfilesPtr.value;
        final List<String>? result = profilesPtr.toStringList(numProfiles);
        _bindings.magickRelinquishMemory(profilesPtr.cast());
        return result;
      });

  /// Returns a value associated with the specified property.
  String? magickGetImageProperty(String property) => using((Arena arena) {
        final Pointer<Char> propertyPtr = property.toNativeUtf8(allocator: arena).cast();
        final Pointer<Char> resultPtr = _bindings.magickGetImageProperty(_wandPtr, propertyPtr);
        if (resultPtr == nullptr) {
          return null;
        }
        final String result = resultPtr.cast<Utf8>().toDartString();
        _bindings.magickRelinquishMemory(resultPtr.cast());
        return result;
      });

  /// Returns all the property names that match the specified pattern associated with a wand.
  /// Use `magickGetImageProperty()` to return the value of a particular property.
  List<String>? magickGetImageProperties(String pattern) => using((Arena arena) {
        final Pointer<Char> patternPtr = pattern.toNativeUtf8(allocator: arena).cast();
        final Pointer<Size> numPropertiesPtr = arena();
        final Pointer<Pointer<Char>> propertiesPtr =
            _bindings.magickGetImageProperties(_wandPtr, patternPtr, numPropertiesPtr);
        final int numProperties = numPropertiesPtr.value;
        final List<String>? result = propertiesPtr.toStringList(numProperties);
        _bindings.magickRelinquishMemory(propertiesPtr.cast());
        return result;
      });

  /// Gets the wand interlace scheme.
  InterlaceType magickGetInterlaceScheme() => InterlaceType.values[_bindings.magickGetInterlaceScheme(_wandPtr)];

  /// Gets the wand compression.
  PixelInterpolateMethod magickGetInterpolateMethod() =>
      PixelInterpolateMethod.values[_bindings.magickGetInterpolateMethod(_wandPtr)];

  /// Returns a value associated with a wand and the specified key.
  String? magickGetOption(String key) => using((Arena arena) {
        final Pointer<Char> keyPtr = key.toNativeUtf8(allocator: arena).cast();
        final Pointer<Char> resultPtr = _bindings.magickGetOption(_wandPtr, keyPtr);
        if (resultPtr == nullptr) {
          return null;
        }
        final String result = resultPtr.cast<Utf8>().toDartString();
        _bindings.magickRelinquishMemory(resultPtr.cast());
        return result;
      });

  /// Returns all the option names that match the specified pattern associated with a wand.
  /// Use `magickGetOption()` to return the value of a particular option.
  List<String>? magickGetOptions(String pattern) => using((Arena arena) {
        final Pointer<Char> patternPtr = pattern.toNativeUtf8(allocator: arena).cast();
        final Pointer<Size> numOptionsPtr = arena();
        final Pointer<Pointer<Char>> optionsPtr = _bindings.magickGetOptions(_wandPtr, patternPtr, numOptionsPtr);
        final int numOptions = numOptionsPtr.value;
        final List<String>? result = optionsPtr.toStringList(numOptions);
        _bindings.magickRelinquishMemory(optionsPtr.cast());
        return result;
      });

  /// Gets the wand orientation type.
  OrientationType magickGetOrientation() => OrientationType.values[_bindings.magickGetOrientation(_wandPtr)];

  /// Returns the page geometry associated with the magick wand.
  MagickGetPageResult? magickGetPage() => using((Arena arena) {
        final Pointer<Size> widthPtr = arena();
        final Pointer<Size> heightPtr = arena();
        final Pointer<ssize_t> xPtr = arena();
        final Pointer<ssize_t> yPtr = arena();
        final bool result = _bindings.magickGetPage(_wandPtr, widthPtr, heightPtr, xPtr, yPtr);
        if (!result) {
          return null;
        }
        return MagickGetPageResult(widthPtr.value, heightPtr.value, xPtr.value, yPtr.value);
      });

  /// Returns the font pointsize associated with the MagickWand.
  double magickGetPointsize() => _bindings.magickGetPointsize(_wandPtr);

  /// Gets the image X and Y resolution.
  MagickGetResolutionResult? magickGetResolution() => using((Arena arena) {
        final Pointer<Double> xResolutionPtr = arena();
        final Pointer<Double> yResolutionPtr = arena();
        final bool result = _bindings.magickGetResolution(_wandPtr, xResolutionPtr, yResolutionPtr);
        if (!result) {
          return null;
        }
        return MagickGetResolutionResult(xResolutionPtr.value, yResolutionPtr.value);
      });

  /// Gets the horizontal and vertical sampling factor.
  Float64List? magickGetSamplingFactors() => using((Arena arena) {
        final Pointer<Size> numFactorsPtr = arena();
        final Pointer<Double> factorsPtr = _bindings.magickGetSamplingFactors(_wandPtr, numFactorsPtr);
        final int numFactors = numFactorsPtr.value;
        if (factorsPtr == nullptr) {
          return null;
        }
        final Float64List factors = factorsPtr.asTypedList(numFactors);
        _MagickRelinquishableResource.registerRelinquishable(factors, factorsPtr.cast());
        return factors;
      });

  /// Returns the size associated with the magick wand.
  MagickGetSizeResult? magickGetSize() => using((Arena arena) {
        final Pointer<Size> widthPtr = arena();
        final Pointer<Size> heightPtr = arena();
        final bool result = _bindings.magickGetSize(_wandPtr, widthPtr, heightPtr);
        if (!result) {
          return null;
        }
        return MagickGetSizeResult(widthPtr.value, heightPtr.value);
      });

  /// Returns the size offset associated with the magick wand.
  int? magickGetSizeOffset() => using((Arena arena) {
        Pointer<ssize_t> sizeOffsetPtr = arena();
        final bool result = _bindings.magickGetSizeOffset(_wandPtr, sizeOffsetPtr);
        if (!result) {
          return null;
        }
        return sizeOffsetPtr.value;
      });

  /// Returns the wand type
  ImageType magickGetType() => ImageType.values[_bindings.magickGetType(_wandPtr)];

  /// Adds or removes a ICC, IPTC, or generic profile from an image. If the profile is NULL, it is removed
  /// from the image otherwise added. Use a name of '*' and a profile of NULL to remove all profiles from
  /// the image.
  bool magickProfileImage(String name, List<int>? profile) => using((Arena arena) {
        final Pointer<UnsignedChar> profilePtr = profile?.toUnsignedCharArray(allocator: arena) ?? nullptr;
        final Pointer<Char> namePtr = name.toNativeUtf8(allocator: arena).cast();
        return _bindings.magickProfileImage(_wandPtr, namePtr, profilePtr.cast(), profile?.length ?? 0);
      });

  /// Removes the named image profile and returns it.
  List<int>? magickRemoveImageProfile(String name) => using((Arena arena) {
        final Pointer<Char> namePtr = name.toNativeUtf8(allocator: arena).cast();
        final Pointer<Size> lengthPtr = arena();
        final Pointer<UnsignedChar> profilePtr = _bindings.magickRemoveImageProfile(_wandPtr, namePtr, lengthPtr);
        int length = lengthPtr.value;
        List<int>? result = profilePtr.toIntList(length);
        _magickRelinquishMemory(profilePtr.cast());
        return result;
      });

  ///  Sets the antialias property of the wand.
  bool magickSetAntialias(bool antialias) => _bindings.magickSetAntialias(_wandPtr, antialias);

  /// Sets the wand background color.
  bool magickSetBackgroundColor(PixelWand pixelWand) =>
      _bindings.magickSetBackgroundColor(_wandPtr, pixelWand._wandPtr);

  /// Sets the wand colorspace type.
  bool magickSetColorspace(ColorspaceType colorspaceType) =>
      _bindings.magickSetColorspace(_wandPtr, colorspaceType.index);

  /// Sets the wand compression type.
  bool magickSetCompression(CompressionType compressionType) =>
      _bindings.magickSetCompression(_wandPtr, compressionType.index);

  /// Sets the wand compression quality.
  bool magickSetCompressionQuality(int quality) => _bindings.magickSetCompressionQuality(_wandPtr, quality);

  /// Sets the wand pixel depth.
  bool magickSetDepth(int depth) => _bindings.magickSetDepth(_wandPtr, depth);

  /// Sets the extract geometry before you read or write an image file. Use it for inline cropping
  /// (e.g. 200x200+0+0) or resizing (e.g.200x200).
  bool magickSetExtract(String geometry) =>
      using((Arena arena) => _bindings.magickSetExtract(_wandPtr, geometry.toNativeUtf8(allocator: arena).cast()));

  /// Sets the filename before you read or write an image file.
  bool magickSetFilename(String filename) =>
      using((Arena arena) => _bindings.magickSetFilename(_wandPtr, filename.toNativeUtf8(allocator: arena).cast()));

  /// Sets the font associated with the MagickWand.
  bool magickSetFont(String font) =>
      using((Arena arena) => _bindings.magickSetFont(_wandPtr, font.toNativeUtf8(allocator: arena).cast()));

  /// Sets the format of the magick wand.
  bool magickSetFormat(String format) =>
      using((Arena arena) => _bindings.magickSetFormat(_wandPtr, format.toNativeUtf8(allocator: arena).cast()));

  /// Sets the gravity type.
  bool magickSetGravity(GravityType gravityType) => _bindings.magickSetGravity(_wandPtr, gravityType.value);

  /// Sets a key-value pair in the image artifact namespace. Artifacts differ from properties.
  /// Properties are public and are generally exported to an external image format if the format
  /// supports it. Artifacts are private and are utilized by the internal ImageMagick API to modify
  /// the behavior of certain algorithms.
  bool magickSetImageArtifact(String key, String value) => using((Arena arena) {
        final Pointer<Char> keyPtr = key.toNativeUtf8(allocator: arena).cast();
        final Pointer<Char> valuePtr = value.toNativeUtf8(allocator: arena).cast();
        return _bindings.magickSetImageArtifact(_wandPtr, keyPtr, valuePtr);
      });

  /// Adds a named profile to the magick wand. If a profile with the same name already exists,
  /// it is replaced. This method differs from the MagickProfileImage() method in that it does not
  /// apply any CMS color profiles.
  bool magickSetImageProfile(String name, List<int> profile) => using((Arena arena) {
        final Pointer<UnsignedChar> profilePtr = profile.toUnsignedCharArray(allocator: arena);
        final Pointer<Char> namePtr = name.toNativeUtf8(allocator: arena).cast();
        return _bindings.magickSetImageProfile(_wandPtr, namePtr, profilePtr.cast(), profile.length);
      });

  /// Associates a property with an image.
  bool magickSetImageProperty(String key, String value) => using((Arena arena) {
        final Pointer<Char> keyPtr = key.toNativeUtf8(allocator: arena).cast();
        final Pointer<Char> valuePtr = value.toNativeUtf8(allocator: arena).cast();
        return _bindings.magickSetImageProperty(_wandPtr, keyPtr, valuePtr);
      });

  /// Sets the image compression.
  bool magickSetInterlaceScheme(InterlaceType interlaceType) =>
      _bindings.magickSetInterlaceScheme(_wandPtr, interlaceType.index);

  /// Sets the interpolate pixel method.
  bool magickSetInterpolateMethod(PixelInterpolateMethod pixelInterpolateMethod) =>
      _bindings.magickSetInterpolateMethod(_wandPtr, pixelInterpolateMethod.index);

  /// Associates one or options with the wand (.e.g MagickSetOption(wand,"jpeg:perserve","yes")).
  bool magickSetOption(String key, String value) => using((Arena arena) {
        final Pointer<Char> keyPtr = key.toNativeUtf8(allocator: arena).cast();
        final Pointer<Char> valuePtr = value.toNativeUtf8(allocator: arena).cast();
        return _bindings.magickSetOption(_wandPtr, keyPtr, valuePtr);
      });

  /// Sets the wand orientation type.
  bool magickSetOrientation(OrientationType orientationType) =>
      _bindings.magickSetOrientation(_wandPtr, orientationType.index);

  /// Sets the page geometry of the magick wand.
  bool magickSetPage(int width, int height, int x, int y) => _bindings.magickSetPage(_wandPtr, width, height, x, y);

  /// Sets the passphrase.
  bool magickSetPassphrase(String passphrase) =>
      using((Arena arena) => _bindings.magickSetPassphrase(_wandPtr, passphrase.toNativeUtf8(allocator: arena).cast()));

  /// Sets the font pointsize associated with the MagickWand.
  bool magickSetPointsize(double pointSize) => _bindings.magickSetPointsize(_wandPtr, pointSize);

  /// MagickSetProgressMonitor() sets the wand progress monitor to  monitor the progress of an image operation to
  /// the specified method.
  ///
  /// If the progress monitor method returns false, the current operation is interrupted.
  /// - [clientData] : any user-provided data that will be passed to the progress monitor callback.
  Future<void> magickSetProgressMonitor(MagickProgressMonitor progressMonitor, [dynamic clientData]) async {
    if (_progressMonitorReceivePort == null) {
      _progressMonitorReceivePort = ReceivePort();
      _progressMonitorReceivePortSendPortPtr =
          _bindings.magickSetProgressMonitorPort(_wandPtr, _progressMonitorReceivePort!.sendPort.nativePort);
      _progressMonitorStreamController = StreamController<dynamic>.broadcast();
      _progressMonitorReceivePortStreamSubscription = _progressMonitorReceivePort!.listen((dynamic data) {
        if (_progressMonitorStreamController!.hasListener) {
          _progressMonitorStreamController!.add(data);
        }
      });
    }
    await _progressMonitorStreamControllerStreamSubscription?.cancel(); // Cancel previous subscription, if any.
    _progressMonitorStreamControllerStreamSubscription = _progressMonitorStreamController!.stream.listen((event) {
      final data = jsonDecode(event);
      progressMonitor(data['info'], data['offset'], data['size'], clientData);
    });
  }

  // TODO: continue adding the remaining methods

  /// Reads an image or image sequence. The images are inserted just before the current image
  /// pointer position. Use magickSetFirstIterator(), to insert new images before all the current images
  /// in the wand, magickSetLastIterator() to append add to the end, magickSetIteratorIndex() to place
  /// images just after the given index.
  ///
  /// This method runs inside an isolate different from the main isolate.
  Future<bool> magickReadImage(String imageFilePath) async =>
      await compute(_magickReadImage, _MagickReadImageArgs(_wandPtr.address, imageFilePath));

  /// Writes an image to the specified filename. If the filename parameter is NULL, the image is written
  /// to the filename set by magickReadImage() or magickSetImageFilename().
  ///
  /// This method runs inside an isolate different from the main isolate.
  Future<bool> magickWriteImage(String imageFilePath) async =>
      await compute(_magickWriteImage, _MagickWriteImageArgs(_wandPtr.address, imageFilePath));
}

class _MagickReadImageArgs {
  final int wandPtrAddress;
  final String imageFilePath;

  _MagickReadImageArgs(this.wandPtrAddress, this.imageFilePath);
}

Future<bool> _magickReadImage(_MagickReadImageArgs args) async => using((Arena arena) => _bindings.magickReadImage(
    Pointer<Void>.fromAddress(args.wandPtrAddress), args.imageFilePath.toNativeUtf8(allocator: arena).cast()));

class _MagickWriteImageArgs {
  final int wandPtrAddress;
  final String imageFilePath;

  _MagickWriteImageArgs(this.wandPtrAddress, this.imageFilePath);
}

Future<bool> _magickWriteImage(_MagickWriteImageArgs args) async => using((Arena arena) => _bindings.magickWriteImage(
    Pointer<Void>.fromAddress(args.wandPtrAddress), args.imageFilePath.toNativeUtf8(allocator: arena).cast()));

/// Represents an exception that occurred while using the ImageMagick API.
class MagickGetExceptionResult {
  /// The type of the exception.
  final ExceptionType severity;

  /// The description of the exception.
  final String description;

  const MagickGetExceptionResult(this.severity, this.description);

  @override
  String toString() {
    return 'MagickException{severity: $severity, description: $description}';
  }
}

/// Represents a result to a call to `magickGetPage()`.
class MagickGetPageResult {
  final int width;
  final int height;
  final int x;
  final int y;

  const MagickGetPageResult(this.width, this.height, this.x, this.y);
}

/// Represents a result to a call to `magickGetResolution()`.
class MagickGetResolutionResult {
  final double x;
  final double y;

  const MagickGetResolutionResult(this.x, this.y);
}

/// Represents a result to a call to `magickGetSize()`.
class MagickGetSizeResult {
  final int width;
  final int height;

  const MagickGetSizeResult(this.width, this.height);
}
