part of 'image_magick_ffi.dart';

/// Signature for a callback to be called when an operation's progress changes.
/// - [info] The progress information.
/// - [offset] The offset of the progress.
/// - [size] The total size of the progress.
/// - [clientData] The user-provided data.
typedef MagickProgressMonitor = void Function(
  String info,
  int offset,
  int size,
  dynamic clientData,
);

/// The [MagickWand] can do operations on images like reading, resizing,
/// writing, cropping an image, etc...
///
/// The [MagickWand] can hold reference to multiple images, and you can set the
/// current referenced image by [MagickSetIteratorIndex] or reset it by
/// [MagickResetIterator]. In general the operations called on the wand are done
/// on the image at the current iterator index.
///
/// Initialize an instance of it with [MagickWand.newMagickWand].
/// When done from it, call [destroyMagickWand] to release the resources.
/// See `https://imagemagick.org/script/magick-wand.php` for more information
/// about the backing C-API.
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

  /// Used to convert the stream of [_progressMonitorReceivePort] to a broadcast
  /// stream.
  StreamController<dynamic>? _progressMonitorStreamController;

  MagickWand._(this._wandPtr);

  /// Clears resources associated with this wand, leaving the wand blank,
  /// and ready to be used for a new set of images.
  void clearMagickWand() => _bindings.clearMagickWand(_wandPtr);

  /// Makes an exact copy of this wand.
  ///
  /// Don't forget to dispose the returned [MagickWand] when done.
  MagickWand cloneMagickWand() =>
      MagickWand._(_bindings.cloneMagickWand(_wandPtr));

  /// Deallocates memory associated with this wand. You can't use the wand after
  /// calling this function.
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

  /// Returns true if this wand is verified as a magick wand. For example, after
  /// calling [destroyMagickWand] on this wand, then this method will return
  /// false.
  bool isMagickWand() => _bindings.isMagickWand(_wandPtr);

  /// Clears any exceptions associated with this wand.
  bool magickClearException() => _bindings.magickClearException(_wandPtr);

  /// Returns the severity, reason, and description of any error that occurs
  /// when using other methods with this wand. For example, failure to read an
  /// image using [magickReadImage] will cause an exception to be associated
  /// with this wand and which can be retrieved by this method.
  ///
  /// - Note: if no exception has occurred, `UndefinedExceptionType` is
  /// returned.
  MagickGetExceptionResult magickGetException() => using((Arena arena) {
        final Pointer<Int> severity = arena();
        final Pointer<Char> description =
            _bindings.magickGetException(_wandPtr, severity);
        final MagickGetExceptionResult magickGetExceptionResult =
            MagickGetExceptionResult(
          ExceptionType.fromValue(severity.value),
          description.cast<Utf8>().toDartString(),
        );
        _magickRelinquishMemory(description.cast());
        return magickGetExceptionResult;
      });

  /// Returns the exception type associated with this wand.
  /// If no exception has occurred, `UndefinedException` is returned.
  ExceptionType magickGetExceptionType() =>
      ExceptionType.fromValue(_bindings.magickGetExceptionType(_wandPtr));

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
  /// - Note: null is returned if the font metrics cannot be determined from
  /// the given input (for ex: if the [MagickWand] contains no images).
  Float64List? magickQueryFontMetrics(DrawingWand drawingWand, String text) =>
      using((Arena arena) {
        final Pointer<Char> textPtr =
            text.toNativeUtf8(allocator: arena).cast();
        final Pointer<Double> metricsPtr = _bindings.magickQueryFontMetrics(
            _wandPtr, drawingWand._wandPtr, textPtr);
        if (metricsPtr == nullptr) {
          return null;
        }
        final Float64List metrics = metricsPtr.asTypedList(13);
        _MagickRelinquishableResource.registerRelinquishable(
          metrics,
          metricsPtr.cast(),
        );
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
  /// This method is like magickQueryFontMetrics() but it returns the maximum
  /// text width and height for multiple lines of text.
  /// - Note: null is returned if the font metrics cannot be determined from the
  /// given input (for ex: if the [MagickWand] contains no images).
  Float64List? magickQueryMultilineFontMetrics(
          DrawingWand drawingWand, String text) =>
      using((Arena arena) {
        final Pointer<Char> textPtr =
            text.toNativeUtf8(allocator: arena).cast();
        final Pointer<Double> metricsPtr =
            _bindings.magickQueryMultilineFontMetrics(
                _wandPtr, drawingWand._wandPtr, textPtr);
        if (metricsPtr == nullptr) {
          return null;
        }
        final Float64List metrics = metricsPtr.asTypedList(13);
        _MagickRelinquishableResource.registerRelinquishable(
          metrics,
          metricsPtr.cast(),
        );
        return metrics;
      });

  /// Resets the wand iterator.
  ///
  /// It is typically used either before iterating though images, or before
  /// calling specific functions such as `magickAppendImages()` to append all
  /// images together.
  ///
  /// Afterward you can use `magickNextImage()` to iterate over all the images
  /// in a wand container, starting with the first image.
  ///
  /// Using this before `magickAddImages()` or `magickReadImages()` will cause
  /// new images to be inserted between the first and second image.
  void magickResetIterator() => _bindings.magickResetIterator(_wandPtr);

  /// Sets the wand iterator to the first image.
  ///
  /// After using any images added to the wand using `magickAddImage()` or
  /// `magickReadImage()` will be prepended before any image in the wand.
  ///
  /// Also the current image has been set to the first image (if any) in the
  /// Magick Wand. Using `magickNextImage()` will then set the current image to
  /// the second image in the list (if present).
  ///
  /// This operation is similar to `magickResetIterator()` but differs in how
  /// `magickAddImage()`, `magickReadImage()`, and magickNextImage()` behaves
  /// afterward.
  void magickSetFirstIterator() => _bindings.magickSetFirstIterator(_wandPtr);

  /// Sets the iterator to the given position in the image list specified with
  /// the index parameter. A zero index will set the first image as current,
  /// and so on. Negative indexes can be used to specify an image relative to
  /// the end of the images in the wand, with -1 being the last image in the
  /// wand.
  ///
  /// If the index is invalid (range too large for number of images in wand) the
  /// function will return false, but no 'exception' will be raised, as it is
  /// not actually an error. In that case the current image will not change.
  ///
  /// After using any images added to the wand using `magickAddImage()` or
  /// `magickReadImage()` will be added after the image indexed, regardless of
  /// if a zero (first image in list) or negative index (from end) is used.
  ///
  /// Jumping to index 0 is similar to `magickResetIterator()` but differs in
  /// how `magickNextImage()` behaves afterward.
  bool magickSetIteratorIndex(int index) =>
      _bindings.magickSetIteratorIndex(_wandPtr, index);

  /// Sets the wand iterator to the last image.
  ///
  /// The last image is actually the current image, and the next use of
  /// `magickPreviousImage()` will not change this allowing this function to be
  /// used to iterate over the images in the reverse direction. In this sense
  /// it is more like `magickResetIterator()` than `magickSetFirstIterator()`.
  ///
  /// Typically this function is used before `magickAddImage()`,
  /// `magickReadImage()` functions to ensure' new images are appended to the
  /// very end of wand's image list.
  void magickSetLastIterator() => _bindings.magickSetLastIterator(_wandPtr);

  /// Returns a wand required for all other methods in the API.
  /// A fatal exception is thrown if there is not enough memory to allocate the
  /// wand. Use `destroyMagickWand()` to dispose of the wand when it is no
  /// longer needed.
  factory MagickWand.newMagickWand() => MagickWand._(_bindings.newMagickWand());

  /// Deletes a wand artifact.
  bool magickDeleteImageArtifact(String artifact) => using(
        (Arena arena) => _bindings.magickDeleteImageArtifact(
          _wandPtr,
          artifact.toNativeUtf8(allocator: arena).cast(),
        ),
      );

  /// Deletes a wand property.
  bool magickDeleteImageProperty(String property) => using(
        (Arena arena) => _bindings.magickDeleteImageProperty(
          _wandPtr,
          property.toNativeUtf8(allocator: arena).cast(),
        ),
      );

  /// Deletes a wand option.
  bool magickDeleteOption(String option) => using(
        (Arena arena) => _bindings.magickDeleteOption(
          _wandPtr,
          option.toNativeUtf8(allocator: arena).cast(),
        ),
      );

  /// Returns the antialias property associated with the wand.
  bool magickGetAntialias() => _bindings.magickGetAntialias(_wandPtr);

  /// Returns the wand background color.
  PixelWand magickGetBackgroundColor() =>
      PixelWand._(_bindings.magickGetBackgroundColor(_wandPtr));

  /// Gets the wand colorspace type.
  ColorspaceType magickGetColorspace() =>
      ColorspaceType.values[_bindings.magickGetColorspace(_wandPtr)];

  /// Gets the wand compression type.
  CompressionType magickGetCompression() =>
      CompressionType.values[_bindings.magickGetCompression(_wandPtr)];

  /// Gets the wand compression quality.
  int magickGetCompressionQuality() =>
      _bindings.magickGetCompressionQuality(_wandPtr);

  /// Returns the filename associated with an image sequence.
  String magickGetFilename() =>
      _bindings.magickGetFilename(_wandPtr).cast<Utf8>().toDartString();

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
  String magickGetFormat() =>
      _bindings.magickGetFormat(_wandPtr).cast<Utf8>().toDartString();

  /// Gets the wand gravity.
  GravityType magickGetGravity() =>
      GravityType.fromValue(_bindings.magickGetGravity(_wandPtr));

  /// Returns a value associated with the specified artifact.
  String? magickGetImageArtifact(String artifact) => using((Arena arena) {
        final Pointer<Char> artifactPtr =
            artifact.toNativeUtf8(allocator: arena).cast();
        final Pointer<Char> resultPtr =
            _bindings.magickGetImageArtifact(_wandPtr, artifactPtr);
        if (resultPtr == nullptr) {
          return null;
        }
        final String result = resultPtr.cast<Utf8>().toDartString();
        _bindings.magickRelinquishMemory(resultPtr.cast());
        return result;
      });

  /// Returns all the artifact names that match the specified pattern associated
  /// with a wand. Use `magickGetImageProperty()` to return the value of a
  /// particular artifact.
  List<String>? magickGetImageArtifacts(String pattern) => using((Arena arena) {
        final Pointer<Char> patternPtr =
            pattern.toNativeUtf8(allocator: arena).cast();
        final Pointer<Size> numArtifactsPtr = arena();
        final Pointer<Pointer<Char>> artifactsPtr = _bindings
            .magickGetImageArtifacts(_wandPtr, patternPtr, numArtifactsPtr);
        final int numArtifacts = numArtifactsPtr.value;
        final List<String>? result = artifactsPtr.toStringList(numArtifacts);
        _bindings.magickRelinquishMemory(artifactsPtr.cast());
        return result;
      });

  /// Returns the named image profile.
  Uint8List? magickGetImageProfile(String name) => using((Arena arena) {
        final Pointer<Char> namePtr =
            name.toNativeUtf8(allocator: arena).cast();
        final Pointer<Size> lengthPtr = arena();
        final Pointer<UnsignedChar> profilePtr =
            _bindings.magickGetImageProfile(_wandPtr, namePtr, lengthPtr);
        final Uint8List? profile = profilePtr.toUint8List(lengthPtr.value);
        _magickRelinquishMemory(profilePtr.cast());
        return profile;
      });

  /// MagickGetImageProfiles() returns all the profile names that match the
  /// specified pattern associated with a wand. Use `magickGetImageProfile()`
  /// to return the value of a particular property.
  /// - Note: An empty list is returned if there are no results.
  List<String>? magickGetImageProfiles(String pattern) => using((Arena arena) {
        final Pointer<Char> patternPtr =
            pattern.toNativeUtf8(allocator: arena).cast();
        final Pointer<Size> numProfilesPtr = arena();
        final Pointer<Pointer<Char>> profilesPtr = _bindings
            .magickGetImageProfiles(_wandPtr, patternPtr, numProfilesPtr);
        final int numProfiles = numProfilesPtr.value;
        final List<String>? result = profilesPtr.toStringList(numProfiles);
        _bindings.magickRelinquishMemory(profilesPtr.cast());
        return result;
      });

  /// Returns a value associated with the specified property.
  String? magickGetImageProperty(String property) => using((Arena arena) {
        final Pointer<Char> propertyPtr =
            property.toNativeUtf8(allocator: arena).cast();
        final Pointer<Char> resultPtr =
            _bindings.magickGetImageProperty(_wandPtr, propertyPtr);
        if (resultPtr == nullptr) {
          return null;
        }
        final String result = resultPtr.cast<Utf8>().toDartString();
        _bindings.magickRelinquishMemory(resultPtr.cast());
        return result;
      });

  /// Returns all the property names that match the specified pattern
  /// associated with a wand. Use `magickGetImageProperty()` to return the value
  /// of a particular property.
  List<String>? magickGetImageProperties(String pattern) =>
      using((Arena arena) {
        final Pointer<Char> patternPtr =
            pattern.toNativeUtf8(allocator: arena).cast();
        final Pointer<Size> numPropertiesPtr = arena();
        final Pointer<Pointer<Char>> propertiesPtr = _bindings
            .magickGetImageProperties(_wandPtr, patternPtr, numPropertiesPtr);
        final int numProperties = numPropertiesPtr.value;
        final List<String>? result = propertiesPtr.toStringList(numProperties);
        _bindings.magickRelinquishMemory(propertiesPtr.cast());
        return result;
      });

  /// Gets the wand interlace scheme.
  InterlaceType magickGetInterlaceScheme() =>
      InterlaceType.values[_bindings.magickGetInterlaceScheme(_wandPtr)];

  /// Gets the wand compression.
  PixelInterpolateMethod magickGetInterpolateMethod() => PixelInterpolateMethod
      .values[_bindings.magickGetInterpolateMethod(_wandPtr)];

  /// Returns a value associated with a wand and the specified key.
  String? magickGetOption(String key) => using((Arena arena) {
        final Pointer<Char> keyPtr = key.toNativeUtf8(allocator: arena).cast();
        final Pointer<Char> resultPtr =
            _bindings.magickGetOption(_wandPtr, keyPtr);
        if (resultPtr == nullptr) {
          return null;
        }
        final String result = resultPtr.cast<Utf8>().toDartString();
        _bindings.magickRelinquishMemory(resultPtr.cast());
        return result;
      });

  /// Returns all the option names that match the specified pattern associated
  /// with a wand. Use `magickGetOption()` to return the value of a particular
  /// option.
  List<String>? magickGetOptions(String pattern) => using((Arena arena) {
        final Pointer<Char> patternPtr =
            pattern.toNativeUtf8(allocator: arena).cast();
        final Pointer<Size> numOptionsPtr = arena();
        final Pointer<Pointer<Char>> optionsPtr =
            _bindings.magickGetOptions(_wandPtr, patternPtr, numOptionsPtr);
        final int numOptions = numOptionsPtr.value;
        final List<String>? result = optionsPtr.toStringList(numOptions);
        _bindings.magickRelinquishMemory(optionsPtr.cast());
        return result;
      });

  /// Gets the wand orientation type.
  OrientationType magickGetOrientation() =>
      OrientationType.values[_bindings.magickGetOrientation(_wandPtr)];

  /// Returns the page geometry associated with the magick wand.
  MagickGetPageResult? magickGetPage() => using((Arena arena) {
        final Pointer<Size> widthPtr = arena();
        final Pointer<Size> heightPtr = arena();
        final Pointer<ssize_t> xPtr = arena();
        final Pointer<ssize_t> yPtr = arena();
        final bool result =
            _bindings.magickGetPage(_wandPtr, widthPtr, heightPtr, xPtr, yPtr);
        if (!result) {
          return null;
        }
        return MagickGetPageResult(
            widthPtr.value, heightPtr.value, xPtr.value, yPtr.value);
      });

  /// Returns the font pointsize associated with the MagickWand.
  double magickGetPointsize() => _bindings.magickGetPointsize(_wandPtr);

  /// Gets the image X and Y resolution.
  MagickGetResolutionResult? magickGetResolution() => using((Arena arena) {
        final Pointer<Double> xResolutionPtr = arena();
        final Pointer<Double> yResolutionPtr = arena();
        final bool result = _bindings.magickGetResolution(
          _wandPtr,
          xResolutionPtr,
          yResolutionPtr,
        );
        if (!result) {
          return null;
        }
        return MagickGetResolutionResult(
            xResolutionPtr.value, yResolutionPtr.value);
      });

  /// Gets the horizontal and vertical sampling factor.
  Float64List? magickGetSamplingFactors() => using((Arena arena) {
        final Pointer<Size> numFactorsPtr = arena();
        final Pointer<Double> factorsPtr =
            _bindings.magickGetSamplingFactors(_wandPtr, numFactorsPtr);
        final int numFactors = numFactorsPtr.value;
        if (factorsPtr == nullptr) {
          return null;
        }
        final Float64List factors = factorsPtr.asTypedList(numFactors);
        _MagickRelinquishableResource.registerRelinquishable(
            factors, factorsPtr.cast());
        return factors;
      });

  /// Returns the size associated with the magick wand.
  MagickGetSizeResult? magickGetSize() => using((Arena arena) {
        final Pointer<Size> widthPtr = arena();
        final Pointer<Size> heightPtr = arena();
        final bool result =
            _bindings.magickGetSize(_wandPtr, widthPtr, heightPtr);
        if (!result) {
          return null;
        }
        return MagickGetSizeResult(widthPtr.value, heightPtr.value);
      });

  /// Returns the size offset associated with the magick wand.
  int? magickGetSizeOffset() => using((Arena arena) {
        Pointer<ssize_t> sizeOffsetPtr = arena();
        final bool result =
            _bindings.magickGetSizeOffset(_wandPtr, sizeOffsetPtr);
        if (!result) {
          return null;
        }
        return sizeOffsetPtr.value;
      });

  /// Returns the wand type
  ImageType magickGetType() =>
      ImageType.values[_bindings.magickGetType(_wandPtr)];

  /// Adds or removes a ICC, IPTC, or generic profile from an image. If the
  /// profile is NULL, it is removed from the image otherwise added. Use a name
  /// of '*' and a profile of NULL to remove all profiles from
  /// the image.
  bool magickProfileImage(String name, Uint8List? profile) => using(
        (Arena arena) {
          final Pointer<UnsignedChar> profilePtr =
              profile?.toUnsignedCharArrayPointer(allocator: arena) ?? nullptr;
          final Pointer<Char> namePtr =
              name.toNativeUtf8(allocator: arena).cast();
          return _bindings.magickProfileImage(
            _wandPtr,
            namePtr,
            profilePtr.cast(),
            profile?.length ?? 0,
          );
        },
      );

  /// Removes the named image profile and returns it.
  Uint8List? magickRemoveImageProfile(String name) => using((Arena arena) {
        final Pointer<Char> namePtr =
            name.toNativeUtf8(allocator: arena).cast();
        final Pointer<Size> lengthPtr = arena();
        final Pointer<UnsignedChar> profilePtr =
            _bindings.magickRemoveImageProfile(_wandPtr, namePtr, lengthPtr);
        Uint8List? result = profilePtr.toUint8List(lengthPtr.value);
        _magickRelinquishMemory(profilePtr.cast());
        return result;
      });

  ///  Sets the antialias property of the wand.
  bool magickSetAntialias(bool antialias) =>
      _bindings.magickSetAntialias(_wandPtr, antialias);

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
  bool magickSetCompressionQuality(int quality) =>
      _bindings.magickSetCompressionQuality(_wandPtr, quality);

  /// Sets the wand pixel depth.
  bool magickSetDepth(int depth) => _bindings.magickSetDepth(_wandPtr, depth);

  /// Sets the extract geometry before you read or write an image file. Use it
  /// for inline cropping (e.g. 200x200+0+0) or resizing (e.g.200x200).
  bool magickSetExtract(String geometry) => using(
        (Arena arena) => _bindings.magickSetExtract(
          _wandPtr,
          geometry.toNativeUtf8(allocator: arena).cast(),
        ),
      );

  /// Sets the filename before you read or write an image file.
  bool magickSetFilename(String filename) => using(
        (Arena arena) => _bindings.magickSetFilename(
          _wandPtr,
          filename.toNativeUtf8(allocator: arena).cast(),
        ),
      );

  /// Sets the font associated with the MagickWand.
  bool magickSetFont(String font) => using(
        (Arena arena) => _bindings.magickSetFont(
          _wandPtr,
          font.toNativeUtf8(allocator: arena).cast(),
        ),
      );

  /// Sets the format of the magick wand.
  bool magickSetFormat(String format) => using(
        (Arena arena) => _bindings.magickSetFormat(
          _wandPtr,
          format.toNativeUtf8(allocator: arena).cast(),
        ),
      );

  /// Sets the gravity type.
  bool magickSetGravity(GravityType gravityType) =>
      _bindings.magickSetGravity(_wandPtr, gravityType.value);

  /// Sets a key-value pair in the image artifact namespace. Artifacts differ
  /// from properties. Properties are public and are generally exported to an
  /// external image format if the format supports it. Artifacts are private
  /// and are utilized by the internal ImageMagick API to modify
  /// the behavior of certain algorithms.
  bool magickSetImageArtifact(String key, String value) => using(
        (Arena arena) {
          final Pointer<Char> keyPtr =
              key.toNativeUtf8(allocator: arena).cast();
          final Pointer<Char> valuePtr =
              value.toNativeUtf8(allocator: arena).cast();
          return _bindings.magickSetImageArtifact(_wandPtr, keyPtr, valuePtr);
        },
      );

  /// Adds a named profile to the magick wand. If a profile with the same name
  /// already exists, it is replaced. This method differs from the
  /// MagickProfileImage() method in that it does not apply any CMS color
  /// profiles.
  bool magickSetImageProfile(String name, Uint8List profile) => using(
        (Arena arena) {
          final Pointer<UnsignedChar> profilePtr =
              profile.toUnsignedCharArrayPointer(allocator: arena);
          final Pointer<Char> namePtr =
              name.toNativeUtf8(allocator: arena).cast();
          return _bindings.magickSetImageProfile(
            _wandPtr,
            namePtr,
            profilePtr.cast(),
            profile.length,
          );
        },
      );

  /// Associates a property with an image.
  bool magickSetImageProperty(String key, String value) => using(
        (Arena arena) {
          final Pointer<Char> keyPtr =
              key.toNativeUtf8(allocator: arena).cast();
          final Pointer<Char> valuePtr =
              value.toNativeUtf8(allocator: arena).cast();
          return _bindings.magickSetImageProperty(_wandPtr, keyPtr, valuePtr);
        },
      );

  /// Sets the image compression.
  bool magickSetInterlaceScheme(InterlaceType interlaceType) =>
      _bindings.magickSetInterlaceScheme(_wandPtr, interlaceType.index);

  /// Sets the interpolate pixel method.
  bool magickSetInterpolateMethod(
          PixelInterpolateMethod pixelInterpolateMethod) =>
      _bindings.magickSetInterpolateMethod(
        _wandPtr,
        pixelInterpolateMethod.index,
      );

  /// Associates one or options with the wand
  /// (.e.g MagickSetOption(wand,"jpeg:perserve","yes")).
  bool magickSetOption(String key, String value) => using(
        (Arena arena) {
          final Pointer<Char> keyPtr =
              key.toNativeUtf8(allocator: arena).cast();
          final Pointer<Char> valuePtr =
              value.toNativeUtf8(allocator: arena).cast();
          return _bindings.magickSetOption(_wandPtr, keyPtr, valuePtr);
        },
      );

  /// Sets the wand orientation type.
  bool magickSetOrientation(OrientationType orientationType) =>
      _bindings.magickSetOrientation(_wandPtr, orientationType.index);

  /// Sets the page geometry of the magick wand.
  bool magickSetPage({
    required int width,
    required int height,
    required int x,
    required int y,
  }) =>
      _bindings.magickSetPage(_wandPtr, width, height, x, y);

  /// Sets the passphrase.
  bool magickSetPassphrase(String passphrase) => using(
        (Arena arena) => _bindings.magickSetPassphrase(
          _wandPtr,
          passphrase.toNativeUtf8(allocator: arena).cast(),
        ),
      );

  /// Sets the font pointsize associated with the MagickWand.
  bool magickSetPointsize(double pointSize) =>
      _bindings.magickSetPointsize(_wandPtr, pointSize);

  /// MagickSetProgressMonitor() sets the wand progress monitor to  monitor the
  /// progress of an image operation to the specified method.
  ///
  //TODO: If the progress monitor method returns false, the current operation is
  // interrupted.
  /// - [clientData] : any user-provided data that will be passed to the
  /// progress monitor callback.
  Future<void> magickSetProgressMonitor(MagickProgressMonitor progressMonitor,
      [dynamic clientData]) async {
    if (_progressMonitorReceivePort == null) {
      _progressMonitorReceivePort = ReceivePort();
      _progressMonitorReceivePortSendPortPtr =
          _bindings.magickSetProgressMonitorPort(
        _wandPtr,
        _progressMonitorReceivePort!.sendPort.nativePort,
      );
      _progressMonitorStreamController = StreamController<dynamic>.broadcast();
      _progressMonitorReceivePortStreamSubscription =
          _progressMonitorReceivePort!.listen((dynamic data) {
        if (_progressMonitorStreamController!.hasListener) {
          _progressMonitorStreamController!.add(data);
        }
      });
    }
    await _progressMonitorStreamControllerStreamSubscription
        ?.cancel(); // Cancel previous subscription, if any.
    _progressMonitorStreamControllerStreamSubscription =
        _progressMonitorStreamController!.stream.listen((event) {
      final data = jsonDecode(event);
      progressMonitor(data['info'], data['offset'], data['size'], clientData);
    });
  }

  /// Sets the image resolution.
  bool magickSetResolution(double xResolution, double yResolution) =>
      _bindings.magickSetResolution(_wandPtr, xResolution, yResolution);

  /// Sets the image sampling factors.
  /// - [samplingFactors] : An array of doubles representing the sampling factor
  /// for each color component (in RGB order).
  bool magickSetSamplingFactors(Float64List samplingFactors) => using(
        (Arena arena) => _bindings.magickSetSamplingFactors(
          _wandPtr,
          samplingFactors.length,
          samplingFactors.toDoubleArrayPointer(allocator: arena),
        ),
      );

  /// Sets the ImageMagick security policy. It returns false if the policy is
  /// already set or if the policy does not parse.
  bool magickSetSecurityPolicy(String securityPolicy) => using(
        (Arena arena) => _bindings.magickSetSecurityPolicy(
          _wandPtr,
          securityPolicy.toNativeUtf8(allocator: arena).cast(),
        ),
      );

  /// Sets the size of the magick wand. Set it before you read a raw image
  /// format such as RGB, GRAY, or CMYK.
  /// - [width] : the width in pixels.
  /// - [height] : the height in pixels.
  bool magickSetSize(int width, int height) =>
      _bindings.magickSetSize(_wandPtr, width, height);

  /// Sets the size and offset of the magick wand. Set it before you read
  /// a raw image format such as RGB, GRAY, or CMYK.
  bool magickSetSizeOffset({
    required int columns,
    required int rows,
    required int offset,
  }) =>
      _bindings.magickSetSizeOffset(_wandPtr, columns, rows, offset);

  /// Sets the image type attribute.
  bool magickSetType(ImageType imageType) =>
      _bindings.magickSetType(_wandPtr, imageType.index);

  /// Adaptively blurs the image by blurring less intensely near image edges
  /// and more intensely far from edges. We blur the image with a Gaussian
  /// operator of the given radius and standard deviation (sigma). For
  /// reasonable results, radius should be larger than sigma. Use a radius of 0
  /// and `magickAdaptiveBlurImage()` selects a suitable radius for you.
  ///
  /// This method runs inside an isolate different from the main isolate.
  ///
  /// - [radius] : the radius of the Gaussian, in pixels, not counting the
  /// center pixel.
  /// - [sigma] : the standard deviation of the Gaussian, in pixels.
  Future<bool> magickAdaptiveBlurImage(double radius, double sigma) async =>
      await _magickCompute(
        _magickAdaptiveBlurImage,
        _MagickAdaptiveBlurImageParams(_wandPtr.address, radius, sigma),
      );

  /// Adaptively resize image with data dependent triangulation.
  ///
  /// This method runs inside an isolate different from the main isolate.
  ///
  /// - [columns] : the number of columns in the scaled image.
  /// - [rows] : the number of rows in the scaled image.
  Future<bool> magickAdaptiveResizeImage(int columns, int rows) async =>
      await _magickCompute(
        _magickAdaptiveResizeImage,
        _MagickAdaptiveResizeImageParams(_wandPtr.address, columns, rows),
      );

  /// Adaptively sharpens the image by sharpening more intensely near image edges
  /// and less intensely far from edges. We sharpen the image with a Gaussian
  /// operator of the given radius and standard deviation (sigma). For
  /// reasonable results, radius should be larger than sigma. Use a radius of 0
  /// and `magickAdaptiveSharpenImage()` selects a suitable radius for you.
  ///
  /// This method runs inside an isolate different from the main isolate.
  ///
  /// - [radius] : the radius of the Gaussian, in pixels, not counting the
  /// center pixel.
  /// - [sigma] : the standard deviation of the Gaussian, in pixels.
  Future<bool> magickAdaptiveSharpenImage(double radius, double sigma) async =>
      await _magickCompute(
        _magickAdaptiveSharpenImage,
        _MagickAdaptiveSharpenImageParams(_wandPtr.address, radius, sigma),
      );

  /// Selects an individual threshold for each pixel based on the range of
  /// intensity values in its local neighborhood. This allows for thresholding
  /// of an image whose global intensity histogram doesn't contain distinctive
  /// peaks.
  ///
  /// This method runs inside an isolate different from the main isolate.
  ///
  /// - [width] : the width of the local neighborhood.
  /// - [height] : the height of the local neighborhood.
  /// - [bias] : the mean offset.
  Future<bool> magickAdaptiveThresholdImage({
    required int width,
    required int height,
    required double bias,
  }) async =>
      await _magickCompute(
        _magickAdaptiveThresholdImage,
        _MagickAdaptiveThresholdImageParams(
          _wandPtr.address,
          width,
          height,
          bias,
        ),
      );

  /// Adds a clone of the images from the second wand and inserts them into the
  /// first wand. Use `magickSetLastIterator()`, to append new images into an
  /// existing wand, current image will be set to last image so later adds with
  /// also be appended to end of wand. Use `magickSetFirstIterator()` to
  /// prepend new images into wand, any more images added will also be
  /// prepended before other images in the wand. However the order of a list of
  /// new images will not change. Otherwise the new images will be inserted just
  /// after the current image, and any later image will also be added after this
  /// current image but before the previously added images. Caution is advised
  /// when multiple image adds are inserted into the middle of the wand image
  /// list.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [other] : the other wand to add images from.
  Future<bool> magickAddImage(MagickWand other) async => await _magickCompute(
        _magickAddImage,
        _MagickAddImageParams(_wandPtr.address, other._wandPtr.address),
      );

  /// Adds random noise to the image.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [noiseType] : the type of noise.
  /// - [attenuate] : attenuate the random distribution.
  Future<bool> magickAddNoiseImage(
          NoiseType noiseType, double attenuate) async =>
      await _magickCompute(
        _magickAddNoiseImage,
        _MagickAddNoiseImageParams(
          _wandPtr.address,
          noiseType.index,
          attenuate,
        ),
      );

  /// Transforms an image as dictated by the affine matrix of the drawing wand.
  ///
  /// This method runs inside an isolate different from the main isolate.
  Future<bool> magickAffineTransformImage(DrawingWand drawingWand) async =>
      await _magickCompute(
          _magickAffineTransformImage,
          _MagickAffineTransformImageParams(
              _wandPtr.address, drawingWand._wandPtr.address));

  /// Annotates an image with text.
  /// This method runs inside an isolate different from the main isolate.
  /// - [x] : x ordinate to left of text.
  /// - [y] : y ordinate to text baseline.
  /// - [angle] : the text rotation angle.
  /// - [text] : the text to draw.
  Future<bool> magickAnnotateImage({
    required DrawingWand drawingWand,
    required double x,
    required double y,
    required double angle,
    required String text,
  }) async =>
      await _magickCompute(
        _magickAnnotateImage,
        _MagickAnnotateImageParams(
          _wandPtr.address,
          drawingWand._wandPtr.address,
          x,
          y,
          angle,
          text,
        ),
      );

  /// Append the images in a wand from the current image onwards, creating a new
  /// wand with the single image result. This is affected by the gravity and
  /// background settings of the first image. Typically you would call either
  /// `magickResetIterator()` or `magickSetFirstImage()` before calling this
  /// function to ensure that all the images in the wand's image list will be
  /// appended together.
  ///
  /// Don't forget to dispose the returned [MagickWand] object when done.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [stack] : By default, images are stacked left-to-right. Set stack to
  /// true to stack them top-to-bottom.
  Future<MagickWand?> magickAppendImages(bool stack) async {
    final Pointer<Void> resultPtr = Pointer<Void>.fromAddress(
      await _magickCompute(
        _magickAppendImages,
        _MagickAppendImagesParams(_wandPtr.address, stack),
      ),
    );
    if (resultPtr == nullptr) {
      return null;
    }
    return MagickWand._(resultPtr);
  }

  /// Extracts the 'mean' from the image and adjust the image to try make set
  /// its gamma appropriately.
  ///
  /// This method runs inside an isolate different from the main isolate.
  Future<bool> magickAutoGammaImage() async =>
      await _magickCompute(_magickAutoGammaImage, _wandPtr.address);

  /// Adjusts the levels of a particular image channel by scaling the minimum
  /// and maximum values to the
  /// full quantum range.
  ///
  /// This method runs inside an isolate different from the main isolate.
  Future<bool> magickAutoLevelImage() async =>
      await _magickCompute(_magickAutoLevelImage, _wandPtr.address);

  /// Adjusts an image so that its orientation is suitable $ for viewing (i.e.
  /// top-left orientation).
  ///
  /// This method runs inside an isolate different from the main isolate.
  Future<bool> magickAutoOrientImage() async =>
      await _magickCompute(_magickAutoOrientImage, _wandPtr.address);

  /// Automatically performs image thresholding dependent on which method you
  /// specify.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [method] : the method to use.
  Future<bool> magickAutoThresholdImage(AutoThresholdMethod method) async =>
      await _magickCompute(
        _magickAutoThresholdImage,
        _MagickAutoThresholdImageParams(_wandPtr.address, method.index),
      );

  /// `magickBilateralBlurImage()` is a non-linear, edge-preserving, and
  /// noise-reducing smoothing filter for images. It replaces the intensity of
  /// each pixel with a weighted average of intensity values from nearby pixels.
  /// This weight is based on a Gaussian distribution. The weights depend not
  /// only on Euclidean distance of pixels, but also on the radiometric
  /// differences (e.g., range differences, such as color intensity, depth
  /// distance, etc.). This preserves sharp edges.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [radius] : the radius of the Gaussian, in pixels, not counting the
  /// center pixel.
  /// - [sigma] : the standard deviation of the , in pixels.
  /// - [intensity_sigma] :  sigma in the intensity space. A larger value means
  /// that farther colors within the pixel neighborhood (see spatial_sigma) will
  /// be mixed together, resulting in larger areas of semi-equal color.
  /// - [spatial_sigma] : sigma in the coordinate space. A larger value means
  /// that farther pixels influence each other as long as their colors are close
  /// enough (see intensity_sigma ). When the neighborhood diameter is greater
  /// than zero, it specifies the neighborhood size regardless of spatial_sigma.
  /// Otherwise, the neighborhood diameter is proportional to spatial_sigma.
  Future<bool> magickBilateralBlurImage({
    required double radius,
    required double sigma,
    required double intensitySigma,
    required double spatialSigma,
  }) async =>
      await _magickCompute(
        _magickBilateralBlurImage,
        _MagickBilateralBlurImageParams(
          _wandPtr.address,
          radius,
          sigma,
          intensitySigma,
          spatialSigma,
        ),
      );

  /// `magickBlackThresholdImage()` is like MagickThresholdImage() but forces
  /// all pixels below the threshold into black while leaving all pixels above
  /// the threshold unchanged.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [pixelWand] : the pixel wand to determine the threshold.
  Future<bool> magickBlackThresholdImage(PixelWand pixelWand) async =>
      await _magickCompute(
        _magickBlackThresholdImage,
        _MagickBlackThresholdImageParams(
          _wandPtr.address,
          pixelWand._wandPtr.address,
        ),
      );

  /// Mutes the colors of the image to simulate a scene at nighttime in the
  /// moonlight.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [factor] : the blue shift factor (default 1.5).
  Future<bool> magickBlueShiftImage([double factor = 1.5]) async =>
      await _magickCompute(
        _magickBlueShiftImage,
        _MagickBlueShiftImageParams(_wandPtr.address, factor),
      );

  /// `magickBlurImage()` blurs an image. We convolve the image with a gaussian
  /// operator of the given radius and standard deviation (sigma). For
  /// reasonable results, the radius should be larger than sigma.
  /// Use a radius of 0 and BlurImage() selects a suitable radius for you.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [radius] : the radius of the Gaussian, in pixels, not counting the
  /// center pixel.
  /// - [sigma] : the standard deviation of the Gaussian, in pixels.
  Future<bool> magickBlurImage({
    required double radius,
    required double sigma,
  }) async =>
      await _magickCompute(
        _magickBlurImage,
        _MagickBlurImageParams(_wandPtr.address, radius, sigma),
      );

  /// `magickBorderImage()` surrounds the image with a border of the color
  /// defined by the bordercolor pixel wand.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [borderColorWand] : the border color pixel wand.
  /// - [width] : the border width.
  /// - [height] : the border height.
  /// - [compose] : the composite operator.
  Future<bool> magickBorderImage({
    required PixelWand borderColorWand,
    required int width,
    required int height,
    required CompositeOperator compose,
  }) async =>
      await _magickCompute(
        _magickBorderImage,
        _MagickBorderImageParams(
          _wandPtr.address,
          borderColorWand._wandPtr.address,
          width,
          height,
          compose.index,
        ),
      );

  /// Use `magickBrightnessContrastImage()` to change the brightness and/or
  /// contrast of an image.
  /// It converts the brightness and contrast parameters into slope and
  /// intercept and calls a polynomial function to apply to the image.
  ///
  /// This method runs inside an isolate different from the main isolate.
  ///
  /// - [brightness] : the brightness percent (-100 .. 100).
  /// - [contrast] : the contrast percent (-100 .. 100).
  Future<bool> magickBrightnessContrastImage({
    required double brightness,
    required double contrast,
  }) async =>
      await _magickCompute(
        _magickBrightnessContrastImage,
        _MagickBrightnessContrastImageParams(
          _wandPtr.address,
          brightness,
          contrast,
        ),
      );

  /// `magickCannyEdgeImage()` uses a multi-stage algorithm to detect a wide
  /// range of edges in images.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [radius] : the radius of the gaussian smoothing filter.
  /// - [sigma] : the sigma of the gaussian smoothing filter.
  /// - [lowerPercent] : percentage of edge pixels in the lower threshold.
  /// - [upperPercent] : percentage of edge pixels in the upper threshold.
  Future<bool> magickCannyEdgeImage({
    required double radius,
    required double sigma,
    required double lowerPercent,
    required double upperPercent,
  }) async =>
      await _magickCompute(
        _magickCannyEdgeImage,
        _MagickCannyEdgeImageParams(
          _wandPtr.address,
          radius,
          sigma,
          lowerPercent,
          upperPercent,
        ),
      );

  /// `magickChannelFxImage()` applies a channel expression to the specified
  /// image. The expression consists of one or more channels, either mnemonic
  /// or numeric (e.g. red, 1), separated by actions as follows:
  /// <=> exchange two channels (e.g. red<=>blue) => transfer a channel to
  /// another (e.g. red=>green) , separate channel operations (e.g. red, green)
  /// | read channels from next input image (e.g. red | green) ; write channels
  /// to next output image (e.g. red; green; blue) A channel without a operation
  /// symbol implies extract. For example, to create 3 grayscale images from the
  /// red, green, and blue channels of an image, use: -channel-fx "red; green;
  /// blue".
  ///
  /// Don't forget to dispose the returned [MagickWand] when done.
  ///
  /// This method runs inside an isolate different from the main isolate.
  ///
  /// - [expression] : the expression.
  ///
  /// <b>Sending an invalid input will crash the app abruptly,
  /// so you should be careful not sending invalid input to this method.</b>
  Future<MagickWand?> magickChannelFxImage(String expression) async {
    final Pointer<Void> resultPtr = Pointer<Void>.fromAddress(
      await _magickCompute(
        _magickChannelFxImage,
        _MagickChannelFxImageParams(_wandPtr.address, expression),
      ),
    );
    if (resultPtr == nullptr) {
      return null;
    }
    return MagickWand._(resultPtr);
  }

  /// Simulates a charcoal drawing.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [radius] : the radius of the Gaussian, in pixels, not counting the
  /// center pixel.
  /// - [sigma] : the standard deviation of the Gaussian, in pixels.
  Future<bool> magickCharcoalImage(
          {required double radius, required double sigma}) async =>
      await _magickCompute(
        _magickCharcoalImage,
        _MagickCharcoalImageParams(_wandPtr.address, radius, sigma),
      );

  /// Removes a region of an image and collapses the image to occupy the
  /// removed portion.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [width] : the width of the region.
  /// - [height] : the height of the region.
  /// - [x] : the x offset of the region.
  /// - [y] : the y offset of the region.
  Future<bool> magickChopImage({
    required int width,
    required int height,
    required int x,
    required int y,
  }) async =>
      await _magickCompute(
        _magickChopImage,
        _MagickChopImageParams(
          _wandPtr.address,
          width,
          height,
          x,
          y,
        ),
      );

  /// `magickCLAHEImage()` is a variant of adaptive histogram equalization in
  /// which the contrast amplification is limited, so as to reduce this problem
  /// of noise amplification.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [width] : the width of the tile divisions to use in horizontal
  /// direction.
  /// - [height] : the height of the tile divisions to use in vertical
  /// direction.
  /// - [numberBins] : number of bins for histogram ("dynamic range").
  /// Although parameter is currently
  /// a double, it is cast to size_t internally.
  /// - [clipLimit] : contrast limit for localised changes in contrast.
  /// A limit less than 1 results in
  /// standard non-contrast limited AHE.
  Future<bool> magickClaheImage({
    required int width,
    required int height,
    required double numberBins,
    required double clipLimit,
  }) async =>
      await _magickCompute(
        _magickCLAHEImage,
        _MagickCLAHEImageParams(
          _wandPtr.address,
          width,
          height,
          numberBins,
          clipLimit,
        ),
      );

  /// Restricts the color range from 0 to the quantum depth.
  ///
  /// This method runs inside an isolate different from the main isolate.
  Future<bool> magickClampImage() async =>
      await _magickCompute(_magickClampImage, _wandPtr.address);

  /// Clips along the first path from the 8BIM profile, if present.
  ///
  /// This method runs inside an isolate different from the main isolate.
  Future<bool> magickClipImage() async =>
      await _magickCompute(_magickClipImage, _wandPtr.address);

  /// Clips along the named paths from the 8BIM profile, if present.
  /// Later operations take effect inside the path. Id may be a number if
  /// preceded with #, to work on a numbered path, e.g., "#1" to use the first
  /// path.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [pathName] : name of clipping path resource. If name is preceded by #,
  /// use clipping path numbered
  /// by name.
  /// - [inside] : if non-zero, later operations take effect inside clipping
  /// path. Otherwise later operations
  /// take effect outside clipping path.
  Future<bool> magickClipImagePath(
          {required String pathName, required bool inside}) async =>
      await _magickCompute(
        _magickClipImagePath,
        _MagickClipImagePathParams(_wandPtr.address, pathName, inside),
      );

  /// Replaces colors in the image from a color lookup table.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [clutImage] : the clut image.
  /// - [method] : the pixel interpolation method.
  Future<bool> magickClutImage(
          {required MagickWand clutImage,
          required PixelInterpolateMethod method}) async =>
      await _magickCompute(
        _magickClutImage,
        _MagickClutImageParams(
          _wandPtr.address,
          clutImage._wandPtr.address,
          method.index,
        ),
      );

  /// `magickCoalesceImages()` composites a set of images while respecting any
  /// page offsets and disposal methods. GIF, MIFF, and MNG animation sequences
  /// typically start with an image background and each subsequent image varies
  /// in size and offset. `magickCoalesceImages()` returns a new sequence where
  /// each image in the sequence is the same size as the first and composited
  /// with the next image in the sequence.
  ///
  /// Don't forget to dispose the returned [MagickWand] when done.
  ///
  /// This method runs inside an isolate different from the main isolate.
  Future<MagickWand?> magickCoalesceImages() async {
    final Pointer<Void> resultPtr = Pointer<Void>.fromAddress(
      await _magickCompute(_magickCoalesceImages, _wandPtr.address),
    );
    if (resultPtr == nullptr) {
      return null;
    }
    return MagickWand._(resultPtr);
  }

  // ignore: slash_for_doc_comments
  /**`magickColorDecisionListImage()` accepts a lightweight Color Correction
      Collection (CCC) file which
      solely contains one or more color corrections and applies the color
      correction to the image. Here is
      a sample CCC file:
      <ColorCorrectionCollection xmlns="urn:ASC:CDL:v1.2">
      <ColorCorrection id="cc03345">
      <SOPNode>
      <Slope> 0.9 1.2 0.5 </Slope>
      <Offset> 0.4 -0.5 0.6 </Offset>
      <Power> 1.0 0.8 1.5 </Power>
      </SOPNode>
      <SATNode>
      <Saturation> 0.85 </Saturation>
      </SATNode>
      </ColorCorrection>
      </ColorCorrectionCollection>
      which includes the offset, slope, and power for each of the RGB channels
      as well as the saturation.

      This method runs inside an isolate different from the main isolate.
      - [colorCorrectionCollection] : the color correction collection in XML.*/
  Future<bool> magickColorDecisionListImage(
          String colorCorrectionCollection) async =>
      await _magickCompute(
        _magickColorDecisionListImage,
        _MagickColorDecisionListImageParams(
          _wandPtr.address,
          colorCorrectionCollection,
        ),
      );

  /// Blends the fill color with each pixel in the image.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [colorize] : the colorize pixel wand.
  /// - [blend] : the alpha pixel wand.
  Future<bool> magickColorizeImage(
          {required PixelWand colorize, required PixelWand blend}) async =>
      await _magickCompute(
        _magickColorizeImage,
        _MagickColorizeImageParams(
          _wandPtr.address,
          colorize._wandPtr.address,
          blend._wandPtr.address,
        ),
      );

  /// Apply color transformation to an image. The method permits saturation
  /// changes, hue rotation, luminance to alpha, and various other effects.
  /// Although variable-sized transformation matrices can be used, typically one
  /// uses a 5x5 matrix for an RGBA image and a 6x6 for CMYKA (or RGBA with
  /// offsets). The matrix is similar to those used by Adobe Flash except
  /// offsets are in column 6 rather than 5 (in support of CMYKA images) and
  /// offsets are normalized (divide Flash offset by 255).
  ///
  /// This method runs inside an isolate different from the main isolate.
  ///
  /// - [colorMatrix] : the color matrix.
  Future<bool> magickColorMatrixImage(
          {required KernelInfo colorMatrix}) async =>
      await _magickCompute(
        _magickColorMatrixImage,
        _MagickColorMatrixImageParams(
          _wandPtr.address,
          colorMatrix,
        ),
      );

  /// Forces all pixels in the color range to white otherwise black.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [startColor] : the start color pixel wand.
  /// - [stopColor] : the stop color pixel wand.
  Future<bool> magickColorThresholdImage(
          {required PixelWand startColor,
          required PixelWand stopColor}) async =>
      await _magickCompute(
        _magickColorThresholdImage,
        _MagickColorThresholdImageParams(
          _wandPtr.address,
          startColor._wandPtr.address,
          stopColor._wandPtr.address,
        ),
      );

  /// `magickCombineImages()` combines one or more images into a single image.
  /// The grayscale value of the pixels of each image in the sequence is
  /// assigned in order to the specified channels of the combined image.
  /// The typical ordering would be image 1 => Red, 2 => Green, 3 => Blue, etc.
  ///
  /// Don't forget to dispose the returned [MagickWand] when done.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [colorSpace]: the colorspace.
  Future<MagickWand?> magickCombineImages(ColorspaceType colorSpace) async {
    final Pointer<Void> resultPtr = Pointer<Void>.fromAddress(
      await _magickCompute(
        _magickCombineImages,
        _MagickCombineImagesParams(_wandPtr.address, colorSpace.index),
      ),
    );
    if (resultPtr == nullptr) {
      return null;
    }
    return MagickWand._(resultPtr);
  }

  /// `magickCommentImage()` adds a comment to your image.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [comment]: the image comment.
  Future<bool> magickCommentImage(String comment) async => await _magickCompute(
        _magickCommentImage,
        _MagickCommentImageParams(_wandPtr.address, comment),
      );

  /// `magickCompareImagesLayers()` compares each image with the next in a
  /// sequence and returns the maximum bounding region of any pixel differences
  /// it discovers.
  ///
  /// Don't forget to dispose the returned [MagickWand] when done.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [method] : the compare method.
  Future<MagickWand?> magickCompareImagesLayers(LayerMethod method) async {
    final Pointer<Void> resultPtr = Pointer<Void>.fromAddress(
      await _magickCompute(
        _magickCompareImagesLayers,
        _MagickCompareImagesLayersParams(_wandPtr.address, method.index),
      ),
    );
    if (resultPtr == nullptr) {
      return null;
    }
    return MagickWand._(resultPtr);
  }

  /// Compares an image to a reconstructed image and returns the specified
  /// difference image.
  ///
  /// Don't forget to dispose the returned [MagickWand] when done.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [reference] : the reference wand.
  /// - [metric] : the metric.
  /// - [distortion] : the computed distortion between the images.
  Future<MagickWand?> magickCompareImages({
    required MagickWand reference,
    required MetricType metric,
    required Float64List distortion,
  }) async {
    final Pointer<Void> resultPtr = Pointer<Void>.fromAddress(
      await _magickCompute(
        _magickCompareImages,
        _MagickCompareImagesParams(
          _wandPtr.address,
          reference._wandPtr.address,
          metric.index,
          distortion,
        ),
      ),
    );
    if (resultPtr == nullptr) {
      return null;
    }
    return MagickWand._(resultPtr);
  }

  /// Performs complex mathematics on an image sequence.
  ///
  /// Don't forget to dispose the returned [MagickWand] when done.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [operator]: A complex operator.
  Future<MagickWand?> magickComplexImages(ComplexOperator operator) async {
    final Pointer<Void> resultPtr = Pointer<Void>.fromAddress(
      await _magickCompute(
        _magickComplexImages,
        _MagickComplexImagesParams(_wandPtr.address, operator.index),
      ),
    );
    if (resultPtr == nullptr) {
      return null;
    }
    return MagickWand._(resultPtr);
  }

  /// Composite one image onto another at the specified offset.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [sourceImage]: the magick wand holding source image
  /// - [compose]: This operator affects how the composite is applied to the
  /// image.
  /// The default is Over. These are some of the compose methods available.
  /// - [clipToSelf]: set to true to limit composition to area composed.
  /// - [x]: the column offset of the composited image.
  /// - [y]: the row offset of the composited image.
  Future<bool> magickCompositeImage({
    required MagickWand sourceImage,
    required CompositeOperator compose,
    required bool clipToSelf,
    required int x,
    required int y,
  }) async =>
      await _magickCompute(
        _magickCompositeImage,
        _MagickCompositeImageParams(
          _wandPtr.address,
          sourceImage._wandPtr.address,
          compose.index,
          clipToSelf,
          x,
          y,
        ),
      );

  /// Composite one image onto another using the specified gravity.
  ///
  /// This method runs inside an isolate different from the main isolate.
  ///  - [sourceWand]: the magick wand holding source image.
  ///  - [compose]: This operator affects how the composite is applied to the
  ///  image.
  ///  The default is Over.
  ///  - [gravity]: positioning gravity.
  Future<bool> magickCompositeImageGravity({
    required MagickWand sourceWand,
    required CompositeOperator compose,
    required GravityType gravity,
  }) async =>
      await _magickCompute(
        _magickCompositeImageGravity,
        _MagickCompositeImageGravityParams(
          _wandPtr.address,
          sourceWand._wandPtr.address,
          compose.index,
          gravity.value,
        ),
      );

  /// `magickCompositeLayers()` composite the images in the source wand over
  /// the images in the destination wand in sequence, starting with the current
  /// image in both lists. Each layer from the two image lists are composted
  /// together until the end of one of the image lists is reached. The offset
  /// of each composition is also adjusted to match the virtual canvas offsets
  /// of each layer. As such the given offset is relative to the virtual canvas,
  /// and not the actual image. Composition uses given x and y offsets, as the
  /// 'origin' location of the source images virtual canvas (not the real
  /// image) allowing you to compose a list of 'layer images' into the
  /// destination images. This makes it well suitable for directly composing
  /// 'Clears Frame Animations' or 'Coalesced Animations' onto a static or
  /// other 'Coalesced Animation' destination image list. GIF disposal handling
  /// is not looked at. Special case:- If one of the image sequences is the
  /// last image (just a single image remaining), that image is repeatedly
  /// composed with all the images in the other image list. Either the source
  /// or destination lists may be the single image, for this situation. In the
  /// case of a single destination image (or last image given), that image will
  /// be cloned to match the number of images remaining in the source image
  /// list. This is equivalent to the "-layer Composite" Shell API operator.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [sourceWand]: the magick wand holding source image.
  /// - Compose, x, and y are the compose arguments.
  Future<bool> magickCompositeLayers({
    required MagickWand sourceWand,
    required CompositeOperator compose,
    required int x,
    required int y,
  }) async =>
      await _magickCompute(
        _magickCompositeLayers,
        _MagickCompositeLayersParams(
          _wandPtr.address,
          sourceWand._wandPtr.address,
          compose.index,
          x,
          y,
        ),
      );

  /// Enhances the intensity differences between the lighter and darker
  /// elements of the image. Set sharpen to a value other than 0 to increase
  /// the image contrast otherwise the contrast is reduced.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [sharpen]: Increase or decrease image contrast.
  Future<bool> magickContrastImage(bool sharpen) async => await _magickCompute(
        _magickContrastImage,
        _MagickContrastImageParams(_wandPtr.address, sharpen),
      );

  /// Enhances the contrast of a color image by adjusting the pixels color to
  /// span the entire range of colors available. You can also reduce the
  /// influence of a particular channel with a gamma value of 0.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [blackPoint]: the black point.
  /// - [whitePoint]: the white point.
  Future<bool> magickContrastStretchImage(
          {required double whitePoint, required double blackPoint}) async =>
      await _magickCompute(
        _magickContrastStretchImage,
        _MagickContrastStretchImageParams(
          _wandPtr.address,
          whitePoint,
          blackPoint,
        ),
      );

  /// Applies a custom convolution kernel to the image.
  ///
  /// This method runs inside an isolate different from the main isolate.
  ///
  /// - [kernel]: An array of doubles representing the convolution kernel.
  Future<bool> magickConvolveImage({required KernelInfo kernel}) async =>
      await _magickCompute(
        _magickConvolveImage,
        _MagickConvolveImageParams(_wandPtr.address, kernel),
      );

  /// Extracts a region of the image.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [width]: the region width.
  /// - [height]: the region height.
  /// - [x]: the region x offset.
  /// - [y]: the region y offset.
  Future<bool> magickCropImage({
    required int width,
    required int height,
    required int x,
    required int y,
  }) async =>
      await _magickCompute(
        _magickCropImage,
        _MagickCropImageParams(_wandPtr.address, width, height, x, y),
      );

  /// Displaces an image's colormap by a given number of positions. If you
  /// cycle the colormap a number of times you can produce a psychodelic effect.
  ///
  /// This method runs inside an isolate different from the main isolate.
  Future<bool> magickCycleColormapImage(int displace) async =>
      await _magickCompute(
        _magickCycleColormapImage,
        _MagickCycleColormapImageParams(_wandPtr.address, displace),
      );

  /// Adds an image to the wand comprised of the pixel data you supply. The
  /// pixel data must be in scanline order top-to-bottom. For example, to create
  /// a 640x480 image from unsigned red-green-blue character data, in the C API,
  /// you would use
  ///
  /// ```
  /// MagickConstituteImage(wand,640,480,"RGB",CharPixel,pixels);
  /// ```
  ///
  /// And the equivalent dart code here would be
  ///
  /// ```
  /// wand.magickConstituteImageFromCharPixel(640,640,'RGB',pixels)
  /// ```
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [columns]: width in pixels of the image.
  /// - [rows]: height in pixels of the image.
  /// - [map]: This string reflects the expected ordering of the pixel array.
  /// It can be any combination or order of R = red, G = green, B = blue,
  /// A = alpha (0 is transparent), O = alpha (0 is opaque), C = cyan, Y =
  /// yellow, M = magenta, K = black, I = intensity (for grayscale), P = pad.
  /// - [pixels]: A Uint8List of values contain the pixel components as defined
  /// by map.
  ///
  /// - See also: [magickExportImageCharPixels].
  ///
  /// <b>Sending an invalid input will crash the app abruptly,
  /// so you should be careful not sending invalid input to this method.</b>
  Future<bool> magickConstituteImageFromCharPixel({
    required int columns,
    required int rows,
    required String map,
    required Uint8List pixels,
  }) async =>
      await _magickCompute(
        _magickConstituteImage,
        _MagickConstituteImageParams(
          _wandPtr.address,
          columns,
          rows,
          map,
          _StorageType.CharPixel,
          pixels,
        ),
      );

  /// Adds an image to the wand comprised of the pixel data you supply. The
  /// pixel data must be in scanline order top-to-bottom.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [columns]: width in pixels of the image.
  /// - [rows]: height in pixels of the image.
  /// - [map]: This string reflects the expected ordering of the pixel array.
  /// It can be any combination or order of R = red, G = green, B = blue,
  /// A = alpha (0 is transparent), O = alpha (0 is opaque), C = cyan, Y =
  /// yellow, M = magenta, K = black, I = intensity (for grayscale), P = pad.
  /// - [pixels]: A Float64List of values contain the pixel components as
  /// defined  by map.
  ///
  /// - See also: [magickExportImageDoublePixels].
  ///
  /// <b>Sending an invalid input will crash the app abruptly,
  /// so you should be careful not sending invalid input to this method.</b>
  Future<bool> magickConstituteImageFromDoublePixel({
    required int columns,
    required int rows,
    required String map,
    required Float64List pixels,
  }) async =>
      await _magickCompute(
        _magickConstituteImage,
        _MagickConstituteImageParams(
          _wandPtr.address,
          columns,
          rows,
          map,
          _StorageType.DoublePixel,
          pixels,
        ),
      );

  /// Adds an image to the wand comprised of the pixel data you supply. The
  /// pixel data must be in scanline order top-to-bottom.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [columns]: width in pixels of the image.
  /// - [rows]: height in pixels of the image.
  /// - [map]: This string reflects the expected ordering of the pixel array.
  /// It can be any combination or order of R = red, G = green, B = blue,
  /// A = alpha (0 is transparent), O = alpha (0 is opaque), C = cyan, Y =
  /// yellow, M = magenta, K = black, I = intensity (for grayscale), P = pad.
  /// - [pixels]: A Float32List of values contain the pixel components as defined
  /// by map.
  ///
  /// - See also: [magickExportImageFloatPixels].
  ///
  /// <b>Sending an invalid input will crash the app abruptly,
  /// so you should be careful not sending invalid input to this method.</b>
  Future<bool> magickConstituteImageFromFloatPixel({
    required int columns,
    required int rows,
    required String map,
    required Float32List pixels,
  }) async =>
      await _magickCompute(
        _magickConstituteImage,
        _MagickConstituteImageParams(
          _wandPtr.address,
          columns,
          rows,
          map,
          _StorageType.FloatPixel,
          pixels,
        ),
      );

  /// Adds an image to the wand comprised of the pixel data you supply. The
  /// pixel data must be in scanline order top-to-bottom.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [columns]: width in pixels of the image.
  /// - [rows]: height in pixels of the image.
  /// - [map]: This string reflects the expected ordering of the pixel array.
  /// It can be any combination or order of R = red, G = green, B = blue,
  /// A = alpha (0 is transparent), O = alpha (0 is opaque), C = cyan, Y =
  /// yellow, M = magenta, K = black, I = intensity (for grayscale), P = pad.
  /// - [pixels]: A Uint32List of values contain the pixel components as defined
  /// by map.
  ///
  /// - See also: [magickExportImageLongPixels].
  ///
  /// <b>Sending an invalid input will crash the app abruptly,
  /// so you should be careful not sending invalid input to this method.</b>
  Future<bool> magickConstituteImageFromLongPixel({
    required int columns,
    required int rows,
    required String map,
    required Uint32List pixels,
  }) async =>
      await _magickCompute(
        _magickConstituteImage,
        _MagickConstituteImageParams(
          _wandPtr.address,
          columns,
          rows,
          map,
          _StorageType.LongPixel,
          pixels,
        ),
      );

  /// Adds an image to the wand comprised of the pixel data you supply. The
  /// pixel data must be in scanline order top-to-bottom.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [columns]: width in pixels of the image.
  /// - [rows]: height in pixels of the image.
  /// - [map]: This string reflects the expected ordering of the pixel array.
  /// It can be any combination or order of R = red, G = green, B = blue,
  /// A = alpha (0 is transparent), O = alpha (0 is opaque), C = cyan, Y =
  /// yellow, M = magenta, K = black, I = intensity (for grayscale), P = pad.
  /// - [pixels]: A Uint64List of values contain the pixel components as defined
  /// by map.
  ///
  /// - See also: [magickExportImageLongLongPixels].
  ///
  /// <b>Sending an invalid input will crash the app abruptly,
  /// so you should be careful not sending invalid input to this method.</b>
  Future<bool> magickConstituteImageFromLongLongPixel({
    required int columns,
    required int rows,
    required String map,
    required Uint64List pixels,
  }) async =>
      await _magickCompute(
        _magickConstituteImage,
        _MagickConstituteImageParams(
          _wandPtr.address,
          columns,
          rows,
          map,
          _StorageType.LongLongPixel,
          pixels,
        ),
      );

  /// Adds an image to the wand comprised of the pixel data you supply. The
  /// pixel data must be in scanline order top-to-bottom.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [columns]: width in pixels of the image.
  /// - [rows]: height in pixels of the image.
  /// - [map]: This string reflects the expected ordering of the pixel array.
  /// It can be any combination or order of R = red, G = green, B = blue,
  /// A = alpha (0 is transparent), O = alpha (0 is opaque), C = cyan, Y =
  /// yellow, M = magenta, K = black, I = intensity (for grayscale), P = pad.
  /// - [pixels]: A Uint16List of values contain the pixel components as defined
  /// by map.
  ///
  /// - See also: [magickExportImageShortPixels].
  ///
  /// <b>Sending an invalid input will crash the app abruptly,
  /// so you should be careful not sending invalid input to this method.</b>
  Future<bool> magickConstituteImageFromShortPixel({
    required int columns,
    required int rows,
    required String map,
    required Uint16List pixels,
  }) async =>
      await _magickCompute(
        _magickConstituteImage,
        _MagickConstituteImageParams(
          _wandPtr.address,
          columns,
          rows,
          map,
          _StorageType.ShortPixel,
          pixels,
        ),
      );

  /// Converts cipher pixels to plain pixels.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [passphrase]: the passphrase
  Future<bool> magickDecipherImage(String passphrase) async =>
      await _magickCompute(
        _magickDecipherImage,
        _MagickDecipherImageParams(_wandPtr.address, passphrase),
      );

  /// Compares each image with the next in a sequence and returns the maximum
  /// bounding region of any pixel differences it discovers.
  ///
  /// Don't forget to dispose the returned [MagickWand] when done.
  /// This method runs inside an isolate different from the main isolate.
  Future<MagickWand?> magickDeconstructImages() async {
    final int resultWandAddress =
        await _magickCompute(_magickDeconstructImages, _wandPtr.address);
    if (resultWandAddress == 0) {
      return null;
    }
    return MagickWand._(Pointer<Void>.fromAddress(resultWandAddress));
  }

  /// Removes skew from the image. Skew is an artifact that occurs in scanned
  /// images because of the camera being misaligned, imperfections in the
  /// scanning or surface, or simply because the paper was not placed
  /// completely flat when scanned.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [threshold]: separate background from foreground.
  Future<bool> magickDeskewImage(double threshold) async =>
      await _magickCompute(
        _magickDeskewImage,
        _MagickDeskewImageParams(_wandPtr.address, threshold),
      );

  /// Reduces the speckle noise in an image while preserving the edges of the
  /// original image.
  ///
  /// This method runs inside an isolate different from the main isolate.
  Future<bool> magickDespeckleImage() async => await _magickCompute(
        _magickDespeckleImage,
        _wandPtr.address,
      );

  /// Distorts an image using various distortion methods, by mapping color
  /// lookups of the source image to a new destination image usually of the
  /// same size as the source image, unless 'bestfit' is set to true.
  ///
  /// If 'bestfit' is enabled, and distortion allows it, the destination image
  /// is adjusted to ensure the whole source 'image' will just fit within the
  /// final destination image, which will be sized and offset accordingly.
  /// Also in many cases the virtual offset of the source image will be taken
  /// into account in the mapping.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [method]: the method of image distortion.
  ///
  /// ArcDistortion always ignores the source image offset, and always 'bestfit'
  /// the destination image with the top left corner offset relative to the
  /// polar mapping center.
  ///
  /// Bilinear has no simple inverse mapping so it does not allow 'bestfit'
  /// style of image distortion.
  ///
  /// Affine, Perspective, and Bilinear, do least squares fitting of the
  /// distortion when more than the minimum number of control point pairs are
  /// provided.
  ///
  /// Perspective, and Bilinear, falls back to a Affine distortion when less
  /// that 4 control point pairs are provided. While Affine distortions let you
  /// use any number of control point pairs, that is Zero pairs is a no-Op
  /// (viewport only) distortion, one pair is a translation and two pairs of
  /// control points do a scale-rotate-translate, without any shearing.
  /// - [arguments]: the arguments for this distortion method.
  /// - [bestFit]: Attempt to resize destination to fit distorted source.
  Future<bool> magickDistortImage({
    required DistortMethod method,
    required Float64List arguments,
    required bool bestFit,
  }) async =>
      await _magickCompute(
        _magickDistortImage,
        _MagickDistortImageParams(
          _wandPtr.address,
          method,
          arguments,
          bestFit,
        ),
      );

  /// Renders the drawing wand on the current image.
  ///
  /// This method runs inside an isolate different from the main isolate.
  Future<bool> magickDrawImage(DrawingWand drawWand) async =>
      await _magickCompute(
        _magickDrawImage,
        _MagickDrawImageParams(_wandPtr.address, drawWand._wandPtr.address),
      );

  /// Enhance edges within the image with a convolution filter of the given
  /// radius. Use a radius of 0 and Edge() selects a suitable radius for you.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [radius]: the radius of the pixel neighborhood.
  Future<bool> magickEdgeImage(double radius) async => await _magickCompute(
        _magickEdgeImage,
        _MagickEdgeImageParams(_wandPtr.address, radius),
      );

  /// MagickEmbossImage() returns a grayscale image with a three-dimensional
  /// effect. We convolve the image with a Gaussian operator of the given radius
  /// and standard deviation (sigma). For reasonable results, radius should be
  /// larger than sigma. Use a radius of 0 and Emboss() selects a suitable
  /// radius for you.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [radius]: the radius of the Gaussian, in pixels, not counting the center
  /// pixel.
  /// - [sigma]: the standard deviation of the Gaussian, in pixels.
  Future<bool> magickEmbossImage({
    required double radius,
    required double sigma,
  }) async =>
      await _magickCompute(
        _magickEmbossImage,
        _MagickEmbossImageParams(_wandPtr.address, radius, sigma),
      );

  /// MagickEncipherImage() converts plaint pixels to cipher pixels.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [passphrase]: the passphrase
  Future<bool> magickEncipherImage(String passphrase) async =>
      await _magickCompute(
        _magickEncipherImage,
        _MagickEncipherImageParams(_wandPtr.address, passphrase),
      );

  /// MagickEnhanceImage() applies a digital filter that improves the quality
  /// of a noisy image.
  ///
  /// This method runs inside an isolate different from the main isolate.
  Future<bool> magickEnhanceImage() async => await _magickCompute(
        _magickEnhanceImage,
        _wandPtr.address,
      );

  /// MagickEqualizeImage() equalizes the image histogram.
  ///
  /// This method runs inside an isolate different from the main isolate.
  Future<bool> magickEqualizeImage() async => await _magickCompute(
        _magickEqualizeImage,
        _wandPtr.address,
      );

  /// MagickEvaluateImage() applies an arithmetic, relational, or logical
  /// expression to an image. Use these operators to lighten or darken an image,
  /// to increase or decrease contrast in an image, or to produce the "negative"
  /// of an image.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [operator]: the operator channel.
  Future<bool> magickEvaluateImage({
    required MagickEvaluateOperator operator,
    required double value,
  }) async =>
      await _magickCompute(
        _magickEvaluateImage,
        _MagickEvaluateImageParams(_wandPtr.address, operator, value),
      );

  /// Extracts pixel data from an image and returns it to you.
  /// The data is returned as in the order specified by map.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [x]: The region x offset.
  /// - [y]: The region y offset.
  /// - [columns]: The region width.
  /// - [rows]: The region height.
  /// - [map]: This string reflects the expected ordering of the pixel array.
  /// It can be any combination or order of R = red, G = green, B = blue, A =
  /// alpha (0 is transparent), O = alpha (0 is opaque), C = cyan, Y = yellow,
  /// M = magenta, K = black, I = intensity (for grayscale), P = pad.
  ///
  /// - See also: [magickConstituteImageFromCharPixel]
  ///
  /// <b>Sending an invalid input will crash the app abruptly, so you should be
  /// careful not sending invalid input to this method.</b>
  Future<Uint8List?> magickExportImageCharPixels({
    required int x,
    required int y,
    required int columns,
    required int rows,
    required String map,
  }) async =>
      await _magickCompute(
        _magickExportImageCharPixels,
        _MagickExportImagePixelsParams(
          _wandPtr.address,
          x,
          y,
          columns,
          rows,
          map,
        ),
      );

  /// Extracts pixel data from an image and returns it to you.
  /// The data is returned as in the order specified by map.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [x]: The region x offset.
  /// - [y]: The region y offset.
  /// - [columns]: The region width.
  /// - [rows]: The region height.
  /// - [map]: This string reflects the expected ordering of the pixel array.
  /// It can be any combination or order of R = red, G = green, B = blue, A =
  /// alpha (0 is transparent), O = alpha (0 is opaque), C = cyan, Y = yellow,
  /// M = magenta, K = black, I = intensity (for grayscale), P = pad.
  ///
  /// - See also: [magickConstituteImageFromDoublePixel]
  ///
  /// <b>Sending an invalid input will crash the app abruptly, so you should be
  /// careful not sending invalid input to this method.</b>
  Future<Float64List?> magickExportImageDoublePixels({
    required int x,
    required int y,
    required int columns,
    required int rows,
    required String map,
  }) async =>
      await _magickCompute(
        _magickExportImageDoublePixels,
        _MagickExportImagePixelsParams(
          _wandPtr.address,
          x,
          y,
          columns,
          rows,
          map,
        ),
      );

  /// Extracts pixel data from an image and returns it to you.
  /// The data is returned as in the order specified by map.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [x]: The region x offset.
  /// - [y]: The region y offset.
  /// - [columns]: The region width.
  /// - [rows]: The region height.
  /// - [map]: This string reflects the expected ordering of the pixel array.
  /// It can be any combination or order of R = red, G = green, B = blue, A =
  /// alpha (0 is transparent), O = alpha (0 is opaque), C = cyan, Y = yellow,
  /// M = magenta, K = black, I = intensity (for grayscale), P = pad.
  ///
  /// - See also: [magickConstituteImageFromFloatPixel]
  ///
  /// <b>Sending an invalid input will crash the app abruptly, so you should be
  /// careful not sending invalid input to this method.</b>
  Future<Float32List?> magickExportImageFloatPixels({
    required int x,
    required int y,
    required int columns,
    required int rows,
    required String map,
  }) async =>
      await _magickCompute(
        _magickExportImageFloatPixels,
        _MagickExportImagePixelsParams(
          _wandPtr.address,
          x,
          y,
          columns,
          rows,
          map,
        ),
      );

  /// Extracts pixel data from an image and returns it to you.
  /// The data is returned as in the order specified by map.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [x]: The region x offset.
  /// - [y]: The region y offset.
  /// - [columns]: The region width.
  /// - [rows]: The region height.
  /// - [map]: This string reflects the expected ordering of the pixel array.
  /// It can be any combination or order of R = red, G = green, B = blue, A =
  /// alpha (0 is transparent), O = alpha (0 is opaque), C = cyan, Y = yellow,
  /// M = magenta, K = black, I = intensity (for grayscale), P = pad.
  ///
  /// - See also: [magickConstituteImageFromLongPixel]
  ///
  /// <b>Sending an invalid input will crash the app abruptly, so you should be
  /// careful not sending invalid input to this method.</b>
  Future<Uint32List?> magickExportImageLongPixels({
    required int x,
    required int y,
    required int columns,
    required int rows,
    required String map,
  }) async =>
      await _magickCompute(
        _magickExportImageLongPixels,
        _MagickExportImagePixelsParams(
          _wandPtr.address,
          x,
          y,
          columns,
          rows,
          map,
        ),
      );

  /// Extracts pixel data from an image and returns it to you.
  /// The data is returned as in the order specified by map.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [x]: The region x offset.
  /// - [y]: The region y offset.
  /// - [columns]: The region width.
  /// - [rows]: The region height.
  /// - [map]: This string reflects the expected ordering of the pixel array.
  /// It can be any combination or order of R = red, G = green, B = blue, A =
  /// alpha (0 is transparent), O = alpha (0 is opaque), C = cyan, Y = yellow,
  /// M = magenta, K = black, I = intensity (for grayscale), P = pad.
  ///
  /// - See also: [magickConstituteImageFromLongLongPixel]
  ///
  /// <b>Sending an invalid input will crash the app abruptly, so you should be
  /// careful not sending invalid input to this method.</b>
  Future<Uint64List?> magickExportImageLongLongPixels({
    required int x,
    required int y,
    required int columns,
    required int rows,
    required String map,
  }) async =>
      await _magickCompute(
        _magickExportImageLongLongPixels,
        _MagickExportImagePixelsParams(
          _wandPtr.address,
          x,
          y,
          columns,
          rows,
          map,
        ),
      );

  /// Extracts pixel data from an image and returns it to you.
  /// The data is returned as in the order specified by map.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [x]: The region x offset.
  /// - [y]: The region y offset.
  /// - [columns]: The region width.
  /// - [rows]: The region height.
  /// - [map]: This string reflects the expected ordering of the pixel array.
  /// It can be any combination or order of R = red, G = green, B = blue, A =
  /// alpha (0 is transparent), O = alpha (0 is opaque), C = cyan, Y = yellow,
  /// M = magenta, K = black, I = intensity (for grayscale), P = pad.
  ///
  /// - See also: [magickConstituteImageFromShortPixel]
  ///
  /// <b>Sending an invalid input will crash the app abruptly, so you should be
  /// careful not sending invalid input to this method.</b>
  Future<Uint16List?> magickExportImageShortPixels({
    required int x,
    required int y,
    required int columns,
    required int rows,
    required String map,
  }) async =>
      await _magickCompute(
        _magickExportImageShortPixels,
        _MagickExportImagePixelsParams(
          _wandPtr.address,
          x,
          y,
          columns,
          rows,
          map,
        ),
      );

  /// Extends the image as defined by the geometry, gravity, and wand background
  /// color. Set the (x,y) offset of the geometry to move the original wand
  /// relative to the extended wand.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [width]: the region width.
  /// - [height]: the region height.
  /// - [x]: the region x offset.
  /// - [y]: the region y offset.
  Future<bool> magickExtentImage({
    required int width,
    required int height,
    required int x,
    required int y,
  }) async =>
      await _magickCompute(
        _magickExtentImage,
        _MagickExtentImageParams(
          _wandPtr.address,
          width,
          height,
          x,
          y,
        ),
      );

  /// Creates a vertical mirror image by reflecting the pixels around the
  /// central x-axis.
  ///
  /// This method runs inside an isolate different from the main isolate.
  Future<bool> magickFlipImage() async => await _magickCompute(
        _magickFlipImage,
        _wandPtr.address,
      );

  /// Changes the color value of any pixel that matches target and is an
  /// immediate neighbor. If the method FillToBorderMethod is specified, the
  /// color value is changed for any neighbor pixel that does not match the
  /// bordercolor member of image.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [fill]: the floodfill color pixel wand.
  /// - [fuzz]: By default target must match a particular pixel color exactly.
  /// However, in many cases two colors may differ by a small amount. The fuzz
  /// member of image defines how much tolerance is acceptable to consider two
  /// colors as the same. For example, set fuzz to 10 and the color red at
  /// intensities of 100 and 102 respectively are now interpreted as the same
  /// color for the purposes of the floodfill.
  /// - [bordercolor]: the border color pixel wand.
  /// - [x]: the x starting location of the operation.
  /// - [y]: the y starting location of the operation.
  /// - [invert]:  paint any pixel that does not match the target color.
  Future<bool> magickFloodfillPaintImage({
    required PixelWand fill,
    required double fuzz,
    required PixelWand bordercolor,
    required int x,
    required int y,
    required bool invert,
  }) async =>
      await _magickCompute(
        _magickFloodfillPaintImage,
        _MagickFloodfillPaintImageParams(
          _wandPtr.address,
          fill._wandPtr.address,
          fuzz,
          bordercolor._wandPtr.address,
          x,
          y,
          invert,
        ),
      );

  /// Creates a horizontal mirror image by reflecting the pixels around the
  /// central y-axis.
  ///
  /// This method runs inside an isolate different from the main isolate.
  Future<bool> magickFlopImage() async => await _magickCompute(
        _magickFlopImage,
        _wandPtr.address,
      );

  /// Adds a simulated three-dimensional border around the image. The width and
  /// height specify the border width of the vertical and horizontal sides of
  /// the frame. The inner and outer bevels indicate the width of the inner and
  /// outer shadows of the frame.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [matteColor]: the frame color pixel wand.
  /// - [width]: the border width.
  /// - [height]: the border height.
  /// - [innerBevel]: the inner bevel width.
  /// - [outerBevel]: the outer bevel width.
  /// - [compose]: the composite operator.
  Future<bool> magickFrameImage({
    required PixelWand matteColor,
    required int width,
    required int height,
    required int innerBevel,
    required int outerBevel,
    required CompositeOperator compose,
  }) async =>
      await _magickCompute(
        _magickFrameImage,
        _MagickFrameImageParams(
          _wandPtr.address,
          matteColor._wandPtr.address,
          width,
          height,
          innerBevel,
          outerBevel,
          compose,
        ),
      );

  /// Applies an arithmetic, relational, or logical expression to an image. Use
  /// these operators to lighten or darken an image, to increase or decrease
  /// contrast in an image, or to produce the "negative" of an image.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [function]: the image function.
  /// - [arguments]: the function arguments.
  Future<bool> magickFunctionImage({
    required MagickFunctionType function,
    required Float64List arguments,
  }) async =>
      await _magickCompute(
        _magickFunctionImage,
        _MagickFunctionImageParams(
          _wandPtr.address,
          function,
          arguments,
        ),
      );

  /// Evaluate expression for each pixel in the image.
  ///
  /// Don't forget to dispose the returned [MagickWand] when done.
  ///
  /// This method runs inside an isolate different from the main isolate.
  /// - [expression]: the expression.
  Future<MagickWand?> magickFxImage(String expression) async {
    final int resultWandAddress = await _magickCompute(
      _magickFxImage,
      _MagickFxImageParams(
        _wandPtr.address,
        expression,
      ),
    );
    return resultWandAddress == 0
        ? null
        : MagickWand._(Pointer<Void>.fromAddress(resultWandAddress));
  }

  // TODO: continue adding the remaining methods

  /// Reads an image or image sequence. The images are inserted just before the
  /// current image pointer position. Use magickSetFirstIterator(), to insert
  /// new images before all the current images in the wand,
  /// magickSetLastIterator() to append add to the end,
  /// magickSetIteratorIndex() to place images just after the given index.
  ///
  /// This method runs inside an isolate different from the main isolate.
  Future<bool> magickReadImage(String imageFilePath) async =>
      await _magickCompute(
        _magickReadImage,
        _MagickReadImageParams(_wandPtr.address, imageFilePath),
      );

  /// Writes an image to the specified filename. If the filename parameter is
  /// NULL, the image is written to the filename set by magickReadImage() or
  /// magickSetImageFilename().
  ///
  /// This method runs inside an isolate different from the main isolate.
  Future<bool> magickWriteImage(String imageFilePath) async =>
      await _magickCompute(
        _magickWriteImage,
        _MagickWriteImageParams(_wandPtr.address, imageFilePath),
      );
}
