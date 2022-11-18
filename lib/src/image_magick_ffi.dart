// ignore_for_file: constant_identifier_names

import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:image_magick_ffi/src/image_magick_ffi_bindings_generated.dart';

const String _libName = 'image_magick_ffi';

/// The dynamic library in which the symbols for [ImageMagickFfiBindings] can be found.
final ffi.DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return ffi.DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return ffi.DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return ffi.DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final ImageMagickFfiBindings _bindings = ImageMagickFfiBindings(_dylib);

/// Used with managing memory resources on the native heap associated with dart objects.
class _MagickRelinquishableResource implements ffi.Finalizable {
  static final ffi.NativeFinalizer _finalizer = ffi.NativeFinalizer(_dylib.lookup('magickRelinquishMemory'));

  /// Represents a map with weak keys. The keys of the map will be dart objects, and the values will be
  /// `_MagickRelinquishableResource` objects (which are `Finalizable` objects). When the dart object (the key)
  /// is garbage-collected, the associated `_MagickRelinquishableResource` object (the value) will be
  /// garbage-collected, and the native cleanup function will be invoked, which will cause the associated memory
  /// to be freed.
  static final Expando<_MagickRelinquishableResource> _relinquishables = Expando();

  _MagickRelinquishableResource._();

  /// Registers [ptr] to be freed when [obj] is garbage-collected.
  ///
  /// For more info on the other params, see [ffi.NativeFinalizer.attach]
  static void registerRelinquishable(TypedData obj, ffi.Pointer<ffi.Void> ptr,
      {ffi.Pointer<ffi.Void>? detach, int? externalSize}) {
    _MagickRelinquishableResource finalizable = _MagickRelinquishableResource._();
    _finalizer.attach(finalizable, ptr, detach: detach, externalSize: externalSize);
    _relinquishables[obj] = finalizable;
  }
}

// TODO: add docs
class MagickWand {
  ffi.Pointer<ffi.Void> _wandPtr;

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
    final ffi.Pointer<ffi.Int> severity = malloc<ffi.Int>();
    final ffi.Pointer<ffi.Char> description = _bindings.magickGetException(_wandPtr, severity);
    final MagickGetExceptionResult magickGetExceptionResult = MagickGetExceptionResult(
      ExceptionType.fromValue(severity.value),
      description.cast<Utf8>().toDartString(),
    );
    malloc.free(severity);
    _magickRelinquishMemory(description.cast<ffi.Void>());
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
    final ffi.Pointer<ffi.Char> textPtr = text.toNativeUtf8().cast<ffi.Char>();
    final ffi.Pointer<ffi.Double> metricsPtr =
        _bindings.magickQueryFontMetrics(_wandPtr, drawingWand._wandPtr, textPtr);
    malloc.free(textPtr);
    if (metricsPtr == ffi.nullptr) {
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
    final ffi.Pointer<ffi.Char> textPtr = text.toNativeUtf8().cast<ffi.Char>();
    final ffi.Pointer<ffi.Double> metricsPtr =
        _bindings.magickQueryMultilineFontMetrics(_wandPtr, drawingWand._wandPtr, textPtr);
    malloc.free(textPtr);
    if (metricsPtr == ffi.nullptr) {
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
    final ffi.Pointer<ffi.Char> artifactPtr = artifact.toNativeUtf8().cast<ffi.Char>();
    final bool result = _bindings.magickDeleteImageArtifact(_wandPtr, artifactPtr);
    malloc.free(artifactPtr);
    return result;
  }

  /// Deletes a wand property.
  bool magickDeleteImageProperty(String property) {
    final ffi.Pointer<ffi.Char> propertyPtr = property.toNativeUtf8().cast<ffi.Char>();
    final bool result = _bindings.magickDeleteImageProperty(_wandPtr, propertyPtr);
    malloc.free(propertyPtr);
    return result;
  }

  /// Deletes a wand option.
  bool magickDeleteOption(String option) {
    final ffi.Pointer<ffi.Char> keyPtr = option.toNativeUtf8().cast<ffi.Char>();
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
    final ffi.Pointer<ffi.Char> fontPtr = _bindings.magickGetFont(_wandPtr);
    if (fontPtr == ffi.nullptr) {
      return null;
    }
    final String result = fontPtr.cast<Utf8>().toDartString();
    _bindings.magickRelinquishMemory(fontPtr.cast<ffi.Void>());
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
    final ffi.Pointer<ffi.Char> artifactPtr = artifact.toNativeUtf8().cast<ffi.Char>();
    final ffi.Pointer<ffi.Char> resultPtr = _bindings.magickGetImageArtifact(_wandPtr, artifactPtr);
    malloc.free(artifactPtr);
    if (resultPtr == ffi.nullptr) {
      return null;
    }
    final String result = resultPtr.cast<Utf8>().toDartString();
    _bindings.magickRelinquishMemory(resultPtr.cast<ffi.Void>());
    return result;
  }

  /// Returns all the artifact names that match the specified pattern associated with a wand.
  /// Use `magickGetImageProperty()` to return the value of a particular artifact.
  List<String>? magickGetImageArtifacts(String pattern) {
    final ffi.Pointer<ffi.Char> patternPtr = pattern.toNativeUtf8().cast<ffi.Char>();
    final ffi.Pointer<ffi.Size> numArtifactsPtr = malloc<ffi.Size>();
    final ffi.Pointer<ffi.Pointer<ffi.Char>> artifactsPtr =
        _bindings.magickGetImageArtifacts(_wandPtr, patternPtr, numArtifactsPtr);
    malloc.free(patternPtr);
    final int numArtifacts = numArtifactsPtr.value;
    malloc.free(numArtifactsPtr);
    if (artifactsPtr == ffi.nullptr) {
      return null;
    }
    final List<String> result = [];
    for (int i = 0; i < numArtifacts; i++) {
      result.add(artifactsPtr[i].cast<Utf8>().toDartString());
    }
    _bindings.magickRelinquishMemory(artifactsPtr.cast<ffi.Void>());
    return result;
  }

  /// Returns the named image profile.
  Uint8List? magickGetImageProfile(String name) {
    final ffi.Pointer<ffi.Char> namePtr = name.toNativeUtf8().cast<ffi.Char>();
    final ffi.Pointer<ffi.Size> lengthPtr = malloc<ffi.Size>();
    final ffi.Pointer<ffi.UnsignedChar> profilePtr = _bindings.magickGetImageProfile(_wandPtr, namePtr, lengthPtr);
    malloc.free(namePtr);
    final int length = lengthPtr.value;
    malloc.free(lengthPtr);
    if (profilePtr == ffi.nullptr) {
      return null;
    }
    final Uint8List profile = profilePtr.cast<ffi.Uint8>().asTypedList(length);
    _MagickRelinquishableResource.registerRelinquishable(profile, profilePtr.cast());
    return profile;
  }

  // TODO: complete adding the other methods

  /// Reads an image or image sequence. The images are inserted just before the current image
  /// pointer position. Use magickSetFirstIterator(), to insert new images before all the current images
  /// in the wand, magickSetLastIterator() to append add to the end, magickSetIteratorIndex() to place
  /// images just after the given index.
  bool magickReadImage(String imageFilePath) {
    final ffi.Pointer<ffi.Char> imageFilePathPtr = imageFilePath.toNativeUtf8().cast<ffi.Char>();
    final bool result = _bindings.magickReadImage(_wandPtr, imageFilePathPtr);
    malloc.free(imageFilePathPtr);
    return result;
  }

  /// Writes an image to the specified filename. If the filename parameter is NULL, the image is written
  /// to the filename set by magickReadImage() or magickSetImageFilename().
  bool magickWriteImage(String imageFilePath) {
    final ffi.Pointer<ffi.Char> imageFilePathPtr = imageFilePath.toNativeUtf8().cast<ffi.Char>();
    final bool result = _bindings.magickWriteImage(_wandPtr, imageFilePathPtr);
    malloc.free(imageFilePathPtr);
    return result;
  }
}

/// Returns the value associated with the specified configure option, or null in case of no match.
String? magickQueryConfigureOption(String option) {
  final ffi.Pointer<ffi.Char> optionPtr = option.toNativeUtf8().cast<ffi.Char>();
  final ffi.Pointer<ffi.Char> resultPtr = _bindings.magickQueryConfigureOption(optionPtr);
  malloc.free(optionPtr);
  if (resultPtr == ffi.nullptr) {
    return null;
  }
  final String result = resultPtr.cast<Utf8>().toDartString();
  _magickRelinquishMemory(resultPtr.cast<ffi.Void>());
  return result;
}

/// Returns any configure options that match the specified pattern (e.g. "*" for all). Options include NAME,
/// VERSION, LIB_VERSION, etc.
///
/// - Note: An empty list is returned if there are no results.
List<String>? magickQueryConfigureOptions(String pattern) {
  final ffi.Pointer<ffi.Char> patternPtr = pattern.toNativeUtf8().cast<ffi.Char>();
  final ffi.Pointer<ffi.Size> numOptionsPtr = malloc<ffi.Size>();
  final ffi.Pointer<ffi.Pointer<ffi.Char>> resultPtr = _bindings.magickQueryConfigureOptions(patternPtr, numOptionsPtr);
  malloc.free(patternPtr);
  int numOptions = numOptionsPtr.value;
  malloc.free(numOptionsPtr);
  if (resultPtr == ffi.nullptr) {
    return null;
  }
  final List<String> result = [];
  for (int i = 0; i < numOptions; i++) {
    result.add(resultPtr[i].cast<Utf8>().toDartString());
  }
  _magickRelinquishMemory(resultPtr.cast<ffi.Void>());
  return result;
}

/// Returns any font that match the specified pattern (e.g. "*" for all).
List<String>? magickQueryFonts(String pattern) {
  final ffi.Pointer<ffi.Char> patternPtr = pattern.toNativeUtf8().cast<ffi.Char>();
  final ffi.Pointer<ffi.Size> numFontsPtr = malloc<ffi.Size>();
  final ffi.Pointer<ffi.Pointer<ffi.Char>> resultPtr = _bindings.magickQueryFonts(patternPtr, numFontsPtr);
  malloc.free(patternPtr);
  int numFonts = numFontsPtr.value;
  malloc.free(numFontsPtr);
  if (resultPtr == ffi.nullptr) {
    return null;
  }
  final List<String> result = [];
  for (int i = 0; i < numFonts; i++) {
    result.add(resultPtr[i].cast<Utf8>().toDartString());
  }
  _magickRelinquishMemory(resultPtr.cast<ffi.Void>());
  return result;
}

/// Returns any image formats that match the specified pattern (e.g. "*" for all).
/// - Note: An empty list is returned if there are no results.
List<String>? magickQueryFormats(String pattern) {
  final ffi.Pointer<ffi.Char> patternPtr = pattern.toNativeUtf8().cast<ffi.Char>();
  final ffi.Pointer<ffi.Size> numFormatsPtr = malloc<ffi.Size>();
  final ffi.Pointer<ffi.Pointer<ffi.Char>> resultPtr = _bindings.magickQueryFormats(patternPtr, numFormatsPtr);
  malloc.free(patternPtr);
  int numFormats = numFormatsPtr.value;
  malloc.free(numFormatsPtr);
  if (resultPtr == ffi.nullptr) {
    return null;
  }
  final List<String> result = [];
  for (int i = 0; i < numFormats; i++) {
    result.add(resultPtr[i].cast<Utf8>().toDartString());
  }
  _magickRelinquishMemory(resultPtr.cast<ffi.Void>());
  return result;
}

/// Relinquishes memory resources returned by such methods as MagickIdentifyImage(), MagickGetException(),
/// etc.
ffi.Pointer<ffi.Void> _magickRelinquishMemory(ffi.Pointer<ffi.Void> ptr) {
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
  ffi.Pointer<ffi.Char> resultPtr = _bindings.magickGetHomeURL();
  String result = resultPtr.cast<Utf8>().toDartString();
  _magickRelinquishMemory(resultPtr.cast<ffi.Void>());
  return result;
}

// TODO: add docs
class DrawingWand {
  final ffi.Pointer<ffi.Void> _wandPtr;

  const DrawingWand._(this._wandPtr);

// TODO: add fields and methods later
}

// TODO: add docs
class Image {
  final ffi.Pointer<ffi.Void> _imagePtr;

  const Image._(this._imagePtr);

// TODO: add fields and methods later
}

// TODO: add docs
class PixelWand {
  final ffi.Pointer<ffi.Void> _wandPtr;

  const PixelWand._(this._wandPtr);

// TODO: add fields and methods later
}

/// Represents the type of an exception that occurred when using the ImageMagick API.
enum ExceptionType {
  UndefinedException(0),
  WarningException(300),
  TypeWarning(305),
  OptionWarning(310),
  DelegateWarning(315),
  MissingDelegateWarning(320),
  CorruptImageWarning(325),
  FileOpenWarning(330),
  BlobWarning(335),
  StreamWarning(340),
  CacheWarning(345),
  CoderWarning(350),
  FilterWarning(352),
  ModuleWarning(355),
  DrawWarning(360),
  ImageWarning(365),
  WandWarning(370),
  RandomWarning(375),
  XServerWarning(380),
  MonitorWarning(385),
  RegistryWarning(390),
  ConfigureWarning(395),
  PolicyWarning(399),
  ErrorException(400),
  TypeError(405),
  OptionError(410),
  DelegateError(415),
  MissingDelegateError(420),
  CorruptImageError(425),
  FileOpenError(430),
  BlobError(435),
  StreamError(440),
  CacheError(445),
  CoderError(450),
  FilterError(452),
  ModuleError(455),
  DrawError(460),
  ImageError(465),
  WandError(470),
  RandomError(475),
  XServerError(480),
  MonitorError(485),
  RegistryError(490),
  ConfigureError(495),
  PolicyError(499),
  FatalErrorException(700),
  TypeFatalError(705),
  OptionFatalError(710),
  DelegateFatalError(715),
  MissingDelegateFatalError(720),
  CorruptImageFatalError(725),
  FileOpenFatalError(730),
  BlobFatalError(735),
  StreamFatalError(740),
  CacheFatalError(745),
  CoderFatalError(750),
  FilterFatalError(752),
  ModuleFatalError(755),
  DrawFatalError(760),
  ImageFatalError(765),
  WandFatalError(770),
  RandomFatalError(775),
  XServerFatalError(780),
  MonitorFatalError(785),
  RegistryFatalError(790),
  ConfigureFatalError(795),
  PolicyFatalError(799);

  static const ResourceLimitWarning = WarningException;

  static const ResourceLimitError = ErrorException;

  static const ResourceLimitFatalError = FatalErrorException;

  final int value;

  const ExceptionType(this.value);

  static ExceptionType fromValue(int value) => ExceptionType.values.firstWhere((e) => e.value == value);
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

/// Represents a colorspace type.
enum ColorspaceType {
  UndefinedColorspace,
  CMYColorspace,
  CMYKColorspace,
  GRAYColorspace,
  HCLColorspace,
  HCLpColorspace,
  HSBColorspace,
  HSIColorspace,
  HSLColorspace,
  HSVColorspace,
  HWBColorspace,
  LabColorspace,
  LCHColorspace,
  LCHabColorspace,
  LCHuvColorspace,
  LogColorspace,
  LMSColorspace,
  LuvColorspace,
  OHTAColorspace,
  Rec601YCbCrColorspace,
  Rec709YCbCrColorspace,
  RGBColorspace,
  scRGBColorspace,
  sRGBColorspace,
  TransparentColorspace,
  xyYColorspace,
  XYZColorspace,
  YCbCrColorspace,
  YCCColorspace,
  YDbDrColorspace,
  YIQColorspace,
  YPbPrColorspace,
  YUVColorspace,
  LinearGRAYColorspace,
  JzazbzColorspace,
  DisplayP3Colorspace,
  Adobe98Colorspace,
  ProPhotoColorspace
}

/// Represents an image compression type.
enum CompressionType {
  UndefinedCompression,
  B44ACompression,
  B44Compression,
  BZipCompression,
  DXT1Compression,
  DXT3Compression,
  DXT5Compression,
  FaxCompression,
  Group4Compression,
  JBIG1Compression,
  JBIG2Compression,
  JPEG2000Compression,
  JPEGCompression,
  LosslessJPEGCompression,
  LZMACompression,
  LZWCompression,
  NoCompression,
  PizCompression,
  Pxr24Compression,
  RLECompression,
  ZipCompression,
  ZipSCompression,
  ZstdCompression,
  WebPCompression,
  DWAACompression,
  DWABCompression,
  BC7Compression
}

/// Represents a gravity type.
enum GravityType {
  UndefinedGravity(0),
  NorthWestGravity(1),
  NorthGravity(2),
  NorthEastGravity(3),
  WestGravity(4),
  CenterGravity(5),
  EastGravity(6),
  SouthWestGravity(7),
  SouthGravity(8),
  SouthEastGravity(9);

  static const ForgetGravity = UndefinedGravity;

  final int value;

  const GravityType(this.value);

  static GravityType fromValue(int value) => GravityType.values.firstWhere((e) => e.value == value);
}
