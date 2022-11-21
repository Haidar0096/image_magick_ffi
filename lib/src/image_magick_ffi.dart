// ignore_for_file: constant_identifier_names

import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:image_magick_ffi/src/ffi_extensions.dart';
import 'package:image_magick_ffi/src/image_magick_ffi_bindings_generated.dart';

part 'magick_enums.dart';

const String _libName = 'image_magick_ffi';

/// The dynamic library in which the symbols for [ImageMagickFfiBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final ImageMagickFfiBindings _bindings = ImageMagickFfiBindings(_dylib);

/// Used with managing memory resources on the native heap associated with dart objects.
class _MagickRelinquishableResource implements Finalizable {
  static final NativeFinalizer _finalizer = NativeFinalizer(_dylib.lookup('magickRelinquishMemory'));

  /// Represents a map with weak keys. The keys of the map will be dart objects, and the values will be
  /// `_MagickRelinquishableResource` objects (which are `Finalizable` objects). When the dart object (the key)
  /// is garbage-collected, the associated `_MagickRelinquishableResource` object (the value) will be
  /// garbage-collected, and the native cleanup function will be invoked, which will cause the associated memory
  /// to be freed.
  static final Expando<_MagickRelinquishableResource> _relinquishables = Expando();

  _MagickRelinquishableResource._();

  /// Registers [ptr] to be freed when [obj] is garbage-collected.
  ///
  /// For more info on the other params, see [NativeFinalizer.attach]
  static void registerRelinquishable(TypedData obj, Pointer<Void> ptr, {Pointer<Void>? detach, int? externalSize}) {
    _MagickRelinquishableResource finalizable = _MagickRelinquishableResource._();
    _finalizer.attach(finalizable, ptr, detach: detach, externalSize: externalSize);
    _relinquishables[obj] = finalizable;
  }
}

// TODO: add docs
class MagickWand {
  Pointer<Void> _wandPtr;

  // TODO: check if you should add members of the struct _MagickWand here

  MagickWand._(this._wandPtr);

  /// Clears resources associated with this wand, leaving the wand blank, and ready to be used for a new
  /// set of images.
  void clearMagickWand() {
    _bindings.clearMagickWand(_wandPtr);
  }

  /// Makes an exact copy of this wand.
  MagickWand cloneMagickWand() {
    return MagickWand._(_bindings.cloneMagickWand(_wandPtr));
  }

  /// Deallocates memory associated with this wand. You can't use the wand after calling this function.
  void destroyMagickWand() {
    _wandPtr = _bindings.destroyMagickWand(_wandPtr);
  }

  /// Returns true if this wand is verified as a magick wand. For example, after calling
  /// [destroyMagickWand] on this wand, then this method will return false.
  bool isMagickWand() {
    return _bindings.isMagickWand(_wandPtr);
  }

  /// Clears any exceptions associated with this wand.
  bool magickClearException() {
    return _bindings.magickClearException(_wandPtr);
  }

  /// Returns the severity, reason, and description of any error that occurs when using other methods
  /// with this wand. For example, failure to read an image using [magickReadImage] will cause an exception
  /// to be associated with this wand and which can be retrieved by this method.
  ///
  /// - Note: if no exception has occurred, `UndefinedExceptionType` is returned.
  MagickGetExceptionResult magickGetException() {
    final Pointer<Int> severity = malloc();
    final Pointer<Char> description = _bindings.magickGetException(_wandPtr, severity);
    final MagickGetExceptionResult magickGetExceptionResult = MagickGetExceptionResult(
      ExceptionType.fromValue(severity.value),
      description.cast<Utf8>().toDartString(),
    );
    malloc.free(severity);
    _magickRelinquishMemory(description.cast());
    return magickGetExceptionResult;
  }

  /// Returns the exception type associated with this wand.
  /// If no exception has occurred, `UndefinedException` is returned.
  ExceptionType magickGetExceptionType() {
    return ExceptionType.fromValue(_bindings.magickGetExceptionType(_wandPtr));
  }

  /// Returns the position of the iterator in the image list.
  int magickGetIteratorIndex() {
    return _bindings.magickGetIteratorIndex(_wandPtr);
  }

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
  Float64List? magickQueryFontMetrics(DrawingWand drawingWand, String text) {
    final Pointer<Char> textPtr = text.toNativeUtf8().cast();
    final Pointer<Double> metricsPtr = _bindings.magickQueryFontMetrics(_wandPtr, drawingWand._wandPtr, textPtr);
    malloc.free(textPtr);
    if (metricsPtr == nullptr) {
      return null;
    }
    final Float64List metrics = metricsPtr.asTypedList(13);
    _MagickRelinquishableResource.registerRelinquishable(metrics, metricsPtr.cast());
    return metrics;
  }

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
  Float64List? magickQueryMultilineFontMetrics(DrawingWand drawingWand, String text) {
    final Pointer<Char> textPtr = text.toNativeUtf8().cast();
    final Pointer<Double> metricsPtr =
        _bindings.magickQueryMultilineFontMetrics(_wandPtr, drawingWand._wandPtr, textPtr);
    malloc.free(textPtr);
    if (metricsPtr == nullptr) {
      return null;
    }
    final Float64List metrics = metricsPtr.asTypedList(13);
    _MagickRelinquishableResource.registerRelinquishable(metrics, metricsPtr.cast());
    return metrics;
  }

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
  void magickResetIterator() {
    _bindings.magickResetIterator(_wandPtr);
  }

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
  void magickSetFirstIterator() {
    _bindings.magickSetFirstIterator(_wandPtr);
  }

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
  bool magickSetIteratorIndex(int index) {
    return _bindings.magickSetIteratorIndex(_wandPtr, index);
  }

  /// Sets the wand iterator to the last image.
  ///
  /// The last image is actually the current image, and the next use of `magickPreviousImage()` will not
  /// change this allowing this function to be used to iterate over the images in the reverse direction.
  /// In this sense it is more like `magickResetIterator()` than `magickSetFirstIterator()`.
  ///
  /// Typically this function is used before `magickAddImage()`, `magickReadImage()` functions to ensure'
  /// new images are appended to the very end of wand's image list.
  void magickSetLastIterator() {
    _bindings.magickSetLastIterator(_wandPtr);
  }

  /// Returns a wand required for all other methods in the API.
  /// A fatal exception is thrown if there is not enough memory to allocate the wand.
  /// Use `destroyMagickWand()` to dispose of the wand when it is no longer needed.
  factory MagickWand.newMagickWand() {
    return MagickWand._(_bindings.newMagickWand());
  }

  /// Returns a wand with an image.
  factory MagickWand.newMagickWandFromImage(Image image) {
    return MagickWand._(_bindings.newMagickWandFromImage(image._imagePtr));
  }

  /// Deletes a wand artifact.
  bool magickDeleteImageArtifact(String artifact) {
    final Pointer<Char> artifactPtr = artifact.toNativeUtf8().cast();
    final bool result = _bindings.magickDeleteImageArtifact(_wandPtr, artifactPtr);
    malloc.free(artifactPtr);
    return result;
  }

  /// Deletes a wand property.
  bool magickDeleteImageProperty(String property) {
    final Pointer<Char> propertyPtr = property.toNativeUtf8().cast();
    final bool result = _bindings.magickDeleteImageProperty(_wandPtr, propertyPtr);
    malloc.free(propertyPtr);
    return result;
  }

  /// Deletes a wand option.
  bool magickDeleteOption(String option) {
    final Pointer<Char> keyPtr = option.toNativeUtf8().cast();
    final bool result = _bindings.magickDeleteOption(_wandPtr, keyPtr);
    malloc.free(keyPtr);
    return result;
  }

  /// Returns the antialias property associated with the wand.
  bool magickGetAntialias() {
    return _bindings.magickGetAntialias(_wandPtr);
  }

  /// Returns the wand background color.
  PixelWand magickGetBackgroundColor() {
    return PixelWand._(_bindings.magickGetBackgroundColor(_wandPtr));
  }

  /// Gets the wand colorspace type.
  ColorspaceType magickGetColorspace() {
    return ColorspaceType.values[_bindings.magickGetColorspace(_wandPtr)];
  }

  /// Gets the wand compression type.
  CompressionType magickGetCompression() {
    return CompressionType.values[_bindings.magickGetCompression(_wandPtr)];
  }

  /// Gets the wand compression quality.
  int magickGetCompressionQuality() {
    return _bindings.magickGetCompressionQuality(_wandPtr);
  }

  /// Returns the filename associated with an image sequence.
  String magickGetFilename() {
    return _bindings.magickGetFilename(_wandPtr).cast<Utf8>().toDartString();
  }

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
  String magickGetFormat() {
    return _bindings.magickGetFormat(_wandPtr).cast<Utf8>().toDartString();
  }

  /// Gets the wand gravity.
  GravityType magickGetGravity() {
    return GravityType.fromValue(_bindings.magickGetGravity(_wandPtr));
  }

  /// Returns a value associated with the specified artifact.
  String? magickGetImageArtifact(String artifact) {
    final Pointer<Char> artifactPtr = artifact.toNativeUtf8().cast();
    final Pointer<Char> resultPtr = _bindings.magickGetImageArtifact(_wandPtr, artifactPtr);
    malloc.free(artifactPtr);
    if (resultPtr == nullptr) {
      return null;
    }
    final String result = resultPtr.cast<Utf8>().toDartString();
    _bindings.magickRelinquishMemory(resultPtr.cast());
    return result;
  }

  /// Returns all the artifact names that match the specified pattern associated with a wand.
  /// Use `magickGetImageProperty()` to return the value of a particular artifact.
  List<String>? magickGetImageArtifacts(String pattern) {
    final Pointer<Char> patternPtr = pattern.toNativeUtf8().cast();
    final Pointer<Size> numArtifactsPtr = malloc();
    final Pointer<Pointer<Char>> artifactsPtr =
        _bindings.magickGetImageArtifacts(_wandPtr, patternPtr, numArtifactsPtr);
    malloc.free(patternPtr);
    final int numArtifacts = numArtifactsPtr.value;
    malloc.free(numArtifactsPtr);
    if (artifactsPtr == nullptr) {
      return null;
    }
    final List<String> result = [];
    for (int i = 0; i < numArtifacts; i++) {
      result.add(artifactsPtr[i].cast<Utf8>().toDartString());
    }
    _bindings.magickRelinquishMemory(artifactsPtr.cast());
    return result;
  }

  /// Returns the named image profile.
  Uint8List? magickGetImageProfile(String name) {
    final Pointer<Char> namePtr = name.toNativeUtf8().cast();
    final Pointer<Size> lengthPtr = malloc();
    final Pointer<UnsignedChar> profilePtr = _bindings.magickGetImageProfile(_wandPtr, namePtr, lengthPtr);
    malloc.free(namePtr);
    final int length = lengthPtr.value;
    malloc.free(lengthPtr);
    if (profilePtr == nullptr) {
      return null;
    }
    final Uint8List profile = profilePtr.cast<Uint8>().asTypedList(length);
    _MagickRelinquishableResource.registerRelinquishable(profile, profilePtr.cast());
    return profile;
  }

  /// MagickGetImageProfiles() returns all the profile names that match the specified pattern associated
  /// with a wand. Use `magickGetImageProfile()` to return the value of a particular property.
  /// - Note: An empty list is returned if there are no results.
  List<String>? magickGetImageProfiles(String pattern) {
    final Pointer<Char> patternPtr = pattern.toNativeUtf8().cast();
    final Pointer<Size> numProfilesPtr = malloc();
    final Pointer<Pointer<Char>> profilesPtr = _bindings.magickGetImageProfiles(_wandPtr, patternPtr, numProfilesPtr);
    malloc.free(patternPtr);
    final int numProfiles = numProfilesPtr.value;
    malloc.free(numProfilesPtr);
    if (profilesPtr == nullptr) {
      return null;
    }
    final List<String> result = [];
    for (int i = 0; i < numProfiles; i++) {
      result.add(profilesPtr[i].cast<Utf8>().toDartString());
    }
    _bindings.magickRelinquishMemory(profilesPtr.cast());
    return result;
  }

  /// Returns a value associated with the specified property.
  String? magickGetImageProperty(String property) {
    final Pointer<Char> propertyPtr = property.toNativeUtf8().cast();
    final Pointer<Char> resultPtr = _bindings.magickGetImageProperty(_wandPtr, propertyPtr);
    malloc.free(propertyPtr);
    if (resultPtr == nullptr) {
      return null;
    }
    final String result = resultPtr.cast<Utf8>().toDartString();
    _bindings.magickRelinquishMemory(resultPtr.cast());
    return result;
  }

  /// Returns all the property names that match the specified pattern associated with a wand.
  /// Use `magickGetImageProperty()` to return the value of a particular property.
  List<String>? magickGetImageProperties(String pattern) {
    final Pointer<Char> patternPtr = pattern.toNativeUtf8().cast();
    final Pointer<Size> numPropertiesPtr = malloc();
    final Pointer<Pointer<Char>> propertiesPtr =
        _bindings.magickGetImageProperties(_wandPtr, patternPtr, numPropertiesPtr);
    malloc.free(patternPtr);
    final int numProperties = numPropertiesPtr.value;
    malloc.free(numPropertiesPtr);
    if (propertiesPtr == nullptr) {
      return null;
    }
    final List<String> result = [];
    for (int i = 0; i < numProperties; i++) {
      result.add(propertiesPtr[i].cast<Utf8>().toDartString());
    }
    _bindings.magickRelinquishMemory(propertiesPtr.cast());
    return result;
  }

  /// Gets the wand interlace scheme.
  InterlaceType magickGetInterlaceScheme() {
    return InterlaceType.values[_bindings.magickGetInterlaceScheme(_wandPtr)];
  }

  /// Gets the wand compression.
  PixelInterpolateMethod magickGetInterpolateMethod() {
    return PixelInterpolateMethod.values[_bindings.magickGetInterpolateMethod(_wandPtr)];
  }

  /// Returns a value associated with a wand and the specified key.
  String? magickGetOption(String key) {
    final Pointer<Char> keyPtr = key.toNativeUtf8().cast();
    final Pointer<Char> resultPtr = _bindings.magickGetOption(_wandPtr, keyPtr);
    malloc.free(keyPtr);
    if (resultPtr == nullptr) {
      return null;
    }
    final String result = resultPtr.cast<Utf8>().toDartString();
    _bindings.magickRelinquishMemory(resultPtr.cast());
    return result;
  }

  /// Returns all the option names that match the specified pattern associated with a wand.
  /// Use `magickGetOption()` to return the value of a particular option.
  List<String>? magickGetOptions(String pattern) {
    final Pointer<Char> patternPtr = pattern.toNativeUtf8().cast();
    final Pointer<Size> numOptionsPtr = malloc();
    final Pointer<Pointer<Char>> optionsPtr = _bindings.magickGetOptions(_wandPtr, patternPtr, numOptionsPtr);
    malloc.free(patternPtr);
    final int numOptions = numOptionsPtr.value;
    malloc.free(numOptionsPtr);
    if (optionsPtr == nullptr) {
      return null;
    }
    final List<String> result = [];
    for (int i = 0; i < numOptions; i++) {
      result.add(optionsPtr[i].cast<Utf8>().toDartString());
    }
    _bindings.magickRelinquishMemory(optionsPtr.cast());
    return result;
  }

  /// Gets the wand orientation type.
  OrientationType magickGetOrientation() {
    return OrientationType.values[_bindings.magickGetOrientation(_wandPtr)];
  }

  /// Returns the page geometry associated with the magick wand.
  MagickGetPageResult? magickGetPage() {
    final Pointer<Size> widthPtr = malloc();
    final Pointer<Size> heightPtr = malloc();
    final Pointer<ssize_t> xPtr = malloc();
    final Pointer<ssize_t> yPtr = malloc();
    final bool result = _bindings.magickGetPage(_wandPtr, widthPtr, heightPtr, xPtr, yPtr);
    if (!result) {
      return null;
    }
    int width = widthPtr.value;
    malloc.free(widthPtr);
    int height = heightPtr.value;
    malloc.free(heightPtr);
    int x = xPtr.value;
    malloc.free(xPtr);
    int y = yPtr.value;
    malloc.free(yPtr);
    return MagickGetPageResult(width, height, x, y);
  }

  /// Returns the font pointsize associated with the MagickWand.
  double magickGetPointsize() {
    return _bindings.magickGetPointsize(_wandPtr);
  }

  /// Gets the image X and Y resolution.
  MagickGetResolutionResult? magickGetResolution() {
    final Pointer<Double> xResolutionPtr = malloc();
    final Pointer<Double> yResolutionPtr = malloc();
    final bool result = _bindings.magickGetResolution(_wandPtr, xResolutionPtr, yResolutionPtr);
    if (!result) {
      return null;
    }
    double xResolution = xResolutionPtr.value;
    malloc.free(xResolutionPtr);
    double yResolution = yResolutionPtr.value;
    malloc.free(yResolutionPtr);
    return MagickGetResolutionResult(xResolution, yResolution);
  }

  /// Gets the horizontal and vertical sampling factor.
  Float64List? magickGetSamplingFactors() {
    final Pointer<Size> numFactorsPtr = malloc();
    final Pointer<Double> factorsPtr = _bindings.magickGetSamplingFactors(_wandPtr, numFactorsPtr);
    final int numFactors = numFactorsPtr.value;
    malloc.free(numFactorsPtr);
    if (factorsPtr == nullptr) {
      return null;
    }
    final Float64List factors = factorsPtr.asTypedList(numFactors);
    _MagickRelinquishableResource.registerRelinquishable(factors, factorsPtr.cast());
    return factors;
  }

  /// Returns the size associated with the magick wand.
  MagickGetSizeResult? magickGetSize() {
    final Pointer<Size> widthPtr = malloc();
    final Pointer<Size> heightPtr = malloc();
    final bool result = _bindings.magickGetSize(_wandPtr, widthPtr, heightPtr);
    if (!result) {
      return null;
    }
    int width = widthPtr.value;
    malloc.free(widthPtr);
    int height = heightPtr.value;
    malloc.free(heightPtr);
    return MagickGetSizeResult(width, height);
  }

  /// Returns the size offset associated with the magick wand.
  int? magickGetSizeOffset() {
    Pointer<ssize_t> sizeOffsetPtr = malloc();
    final bool result = _bindings.magickGetSizeOffset(_wandPtr, sizeOffsetPtr);
    if (!result) {
      return null;
    }
    int sizeOffset = sizeOffsetPtr.value;
    malloc.free(sizeOffsetPtr);
    return sizeOffset;
  }

  /// Returns the wand type.
  ImageType magickGetType() {
    return ImageType.values[_bindings.magickGetType(_wandPtr)];
  }

  /// Adds or removes a ICC, IPTC, or generic profile from an image. If the profile is NULL, it is removed
  /// from the image otherwise added. Use a name of '*' and a profile of NULL to remove all profiles from
  /// the image.
  bool magickProfileImage(String name, Uint8List? profile) {
    final Pointer<UnsignedChar> profilePtr = profile == null ? nullptr : profile.toUnsignedCharArray();
    final Pointer<Char> namePtr = name.toNativeUtf8().cast();
    final bool result = _bindings.magickProfileImage(_wandPtr, namePtr, profilePtr.cast(), profile?.length ?? 0);
    malloc.free(namePtr);
    malloc.free(profilePtr);
    return result;
  }

  /// Removes the named image profile and returns it.
  Uint8List? magickRemoveImageProfile(String name) {
    final Pointer<Char> namePtr = name.toNativeUtf8().cast();
    final Pointer<Size> lengthPtr = malloc();
    final Pointer<UnsignedChar> profilePtr = _bindings.magickRemoveImageProfile(_wandPtr, namePtr, lengthPtr);
    malloc.free(namePtr);
    int length = lengthPtr.value;
    malloc.free(lengthPtr);
    if (profilePtr == nullptr) {
      return null;
    }
    Uint8List result = profilePtr.cast<Uint8>().asTypedList(length);
    _MagickRelinquishableResource.registerRelinquishable(result, profilePtr.cast());
    return result;
  }

  // TODO: complete adding the other methods

  /// Reads an image or image sequence. The images are inserted just before the current image
  /// pointer position. Use magickSetFirstIterator(), to insert new images before all the current images
  /// in the wand, magickSetLastIterator() to append add to the end, magickSetIteratorIndex() to place
  /// images just after the given index.
  bool magickReadImage(String imageFilePath) {
    final Pointer<Char> imageFilePathPtr = imageFilePath.toNativeUtf8().cast();
    final bool result = _bindings.magickReadImage(_wandPtr, imageFilePathPtr);
    malloc.free(imageFilePathPtr);
    return result;
  }

  /// Writes an image to the specified filename. If the filename parameter is NULL, the image is written
  /// to the filename set by magickReadImage() or magickSetImageFilename().
  bool magickWriteImage(String imageFilePath) {
    final Pointer<Char> imageFilePathPtr = imageFilePath.toNativeUtf8().cast();
    final bool result = _bindings.magickWriteImage(_wandPtr, imageFilePathPtr);
    malloc.free(imageFilePathPtr);
    return result;
  }
}

/// Returns the value associated with the specified configure option, or null in case of no match.
String? magickQueryConfigureOption(String option) {
  final Pointer<Char> optionPtr = option.toNativeUtf8().cast();
  final Pointer<Char> resultPtr = _bindings.magickQueryConfigureOption(optionPtr);
  malloc.free(optionPtr);
  if (resultPtr == nullptr) {
    return null;
  }
  final String result = resultPtr.cast<Utf8>().toDartString();
  _magickRelinquishMemory(resultPtr.cast());
  return result;
}

/// Returns any configure options that match the specified pattern (e.g. "*" for all). Options include NAME,
/// VERSION, LIB_VERSION, etc.
///
/// - Note: An empty list is returned if there are no results.
List<String>? magickQueryConfigureOptions(String pattern) {
  final Pointer<Char> patternPtr = pattern.toNativeUtf8().cast();
  final Pointer<Size> numOptionsPtr = malloc();
  final Pointer<Pointer<Char>> resultPtr = _bindings.magickQueryConfigureOptions(patternPtr, numOptionsPtr);
  malloc.free(patternPtr);
  int numOptions = numOptionsPtr.value;
  malloc.free(numOptionsPtr);
  if (resultPtr == nullptr) {
    return null;
  }
  final List<String> result = [];
  for (int i = 0; i < numOptions; i++) {
    result.add(resultPtr[i].cast<Utf8>().toDartString());
  }
  _magickRelinquishMemory(resultPtr.cast());
  return result;
}

/// Returns any font that match the specified pattern (e.g. "*" for all).
List<String>? magickQueryFonts(String pattern) {
  final Pointer<Char> patternPtr = pattern.toNativeUtf8().cast();
  final Pointer<Size> numFontsPtr = malloc();
  final Pointer<Pointer<Char>> resultPtr = _bindings.magickQueryFonts(patternPtr, numFontsPtr);
  malloc.free(patternPtr);
  int numFonts = numFontsPtr.value;
  malloc.free(numFontsPtr);
  if (resultPtr == nullptr) {
    return null;
  }
  final List<String> result = [];
  for (int i = 0; i < numFonts; i++) {
    result.add(resultPtr[i].cast<Utf8>().toDartString());
  }
  _magickRelinquishMemory(resultPtr.cast());
  return result;
}

/// Returns any image formats that match the specified pattern (e.g. "*" for all).
/// - Note: An empty list is returned if there are no results.
List<String>? magickQueryFormats(String pattern) {
  final Pointer<Char> patternPtr = pattern.toNativeUtf8().cast();
  final Pointer<Size> numFormatsPtr = malloc();
  final Pointer<Pointer<Char>> resultPtr = _bindings.magickQueryFormats(patternPtr, numFormatsPtr);
  malloc.free(patternPtr);
  int numFormats = numFormatsPtr.value;
  malloc.free(numFormatsPtr);
  if (resultPtr == nullptr) {
    return null;
  }
  final List<String> result = [];
  for (int i = 0; i < numFormats; i++) {
    result.add(resultPtr[i].cast<Utf8>().toDartString());
  }
  _magickRelinquishMemory(resultPtr.cast());
  return result;
}

/// Relinquishes memory resources returned by such methods as MagickIdentifyImage(), MagickGetException(),
/// etc.
Pointer<Void> _magickRelinquishMemory(Pointer<Void> ptr) {
  return _bindings.magickRelinquishMemory(ptr);
}

/// Initializes the MagickWand environment.
void magickWandGenesis() {
  _bindings.magickWandGenesis();
}

/// Terminates the MagickWand environment.
void magickWandTerminus() {
  _bindings.magickWandTerminus();
}

/// Returns true if the ImageMagick environment is currently instantiated-- that is,
/// `magickWandGenesis()` has been called but `magickWandTerminus()` has not.
bool isMagickWandInstantiated() {
  return _bindings.isMagickWandInstantiated();
}

/// Returns the ImageMagick API copyright as a string.
String magickGetCopyright() {
  return _bindings.magickGetCopyright().cast<Utf8>().toDartString();
}

/// Returns the ImageMagick home URL.
String magickGetHomeURL() {
  Pointer<Char> resultPtr = _bindings.magickGetHomeURL();
  String result = resultPtr.cast<Utf8>().toDartString();
  _magickRelinquishMemory(resultPtr.cast());
  return result;
}

/// Returns the ImageMagick package name.
String magickGetPackageName() {
  return _bindings.magickGetPackageName().cast<Utf8>().toDartString();
}

/// Returns the ImageMagick quantum depth.
MagickGetQuantumDepthResult magickGetQuantumDepth() {
  final Pointer<Size> depthPtr = malloc();
  String depthString = _bindings.magickGetQuantumDepth(depthPtr).cast<Utf8>().toDartString();
  int depth = depthPtr.value;
  malloc.free(depthPtr);
  return MagickGetQuantumDepthResult(depth, depthString);
}

///  Returns the ImageMagick quantum range.
MagickGetQuantumRangeResult magickGetQuantumRange() {
  final Pointer<Size> rangePtr = malloc();
  String rangeString = _bindings.magickGetQuantumRange(rangePtr).cast<Utf8>().toDartString();
  int range = rangePtr.value;
  malloc.free(rangePtr);
  return MagickGetQuantumRangeResult(range, rangeString);
}

/// Returns the ImageMagick release date.
String magickGetReleaseDate() {
  return _bindings.magickGetReleaseDate().cast<Utf8>().toDartString();
}

/// Returns the specified resource in megabytes.
int magickGetResource(ResourceType type) {
  return _bindings.magickGetResource(type.index);
}

/// Returns the specified resource limit in megabytes.
int magickGetResourceLimit(ResourceType type) {
  return _bindings.magickGetResourceLimit(type.index);
}

/// Returns the ImageMagick version.
MagickGetVersionResult magickGetVersion() {
  final Pointer<Size> versionPtr = malloc();
  String versionString = _bindings.magickGetVersion(versionPtr).cast<Utf8>().toDartString();
  int version = versionPtr.value;
  malloc.free(versionPtr);
  return MagickGetVersionResult(version, versionString);
}

// TODO: add docs
class DrawingWand {
  final Pointer<Void> _wandPtr;

  const DrawingWand._(this._wandPtr);

// TODO: add fields and methods later
}

// TODO: add docs
class Image {
  final Pointer<Void> _imagePtr;

  const Image._(this._imagePtr);

// TODO: add fields and methods later
}

// TODO: add docs
class PixelWand {
  final Pointer<Void> _wandPtr;

  const PixelWand._(this._wandPtr);

// TODO: add fields and methods later
}

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

/// Represents a result to a call to `magickGetQuantumDepth()`.
class MagickGetQuantumDepthResult {
  /// The depth as an integer.
  final int depth;

  /// The depth as a string.
  final String depthString;

  const MagickGetQuantumDepthResult(this.depth, this.depthString);
}

/// Represents a result to a call to `magickGetQuantumRange()`.
class MagickGetQuantumRangeResult {
  /// The range as an integer.
  final int range;

  /// The range as a string.
  final String rangeString;

  const MagickGetQuantumRangeResult(this.range, this.rangeString);
}

// Represents a result to a call to `magickGetResolution()`.
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

/// Represents a result to a call to `magickGetVersion()`.
class MagickGetVersionResult {
  /// The version as an integer.
  final int version;

  /// The version as a string.
  final String versionString;

  const MagickGetVersionResult(this.version, this.versionString);
}
