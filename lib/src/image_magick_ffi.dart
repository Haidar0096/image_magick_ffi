// ignore_for_file: constant_identifier_names

import 'dart:ffi' as ffi;
import 'dart:io';

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

/// An object that can be used to manipulate images. You must call `MagickWand.magickWandGenesis` before using any MagickWand object,
/// and `MagickWand.magickWandTerminus` after you're done using the last MagickWand object (this process can be repeated).
///
/// Each MagickWand object should be destroyed after use by using `destroyMagickWand`.
///
/// For more info about the native API, see https://imagemagick.org/script/magick-wand.php
class MagickWand {
  final ffi.Pointer<ffi.Void> _wandPtr;

  const MagickWand._(this._wandPtr);

  /// Clears resources associated with this wand, leaving the wand blank, and ready to be used for a new set of images.
  void clearMagickWand() {
    _bindings.clearMagickWand(_wandPtr);
  }

  /// Makes an exact copy of this wand.
  MagickWand cloneMagickWand() {
    return MagickWand._(_bindings.cloneMagickWand(_wandPtr));
  }

  /// Deallocates memory associated with this MagickWand. You can't use the wand after calling this function.
  void destroyMagickWand() {
    _bindings.destroyMagickWand(_wandPtr);
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
  /// - Note: if no exception has occurred, UndefinedExceptionType is returned.
  MagickGetExceptionResult magickGetException() {
    final ffi.Pointer<ffi.Int> severity = malloc<ffi.Int>();
    final ffi.Pointer<ffi.Char> description = _bindings.magickGetException(_wandPtr, severity);
    final MagickGetExceptionResult magickException = MagickGetExceptionResult(
      ExceptionType.fromValue(severity.value),
      description.cast<Utf8>().toDartString(),
    );
    calloc.free(severity);
    calloc.free(description);
    return magickException;
  }

  /// Returns the exception type associated with this wand.
  /// If no exception has occurred, UndefinedExceptionType is returned.
  ExceptionType magickGetExceptionType() {
    return ExceptionType.fromValue(_bindings.magickGetExceptionType(_wandPtr));
  }

  /// Returns the position of the iterator in the image list.
  int magickGetIteratorIndex() {
    return _bindings.magickGetIteratorIndex(_wandPtr);
  }

  /// Returns the value associated with the specified configure option, or null in case of no match.
  static String? magickQueryConfigureOption(String option) {
    final ffi.Pointer<ffi.Char> optionPtr = option.toNativeUtf8().cast<ffi.Char>();
    final ffi.Pointer<ffi.Char> resultPtr = _bindings.magickQueryConfigureOption(optionPtr);
    final String? result = resultPtr != ffi.nullptr ? resultPtr.cast<Utf8>().toDartString() : null;
    calloc.free(optionPtr);
    calloc.free(resultPtr);
    return result;
  }

  /// Returns any configure options that match the specified pattern (e.g. "*" for all). Options include NAME, VERSION, LIB_VERSION, etc.
  ///
  /// - Note: An empty list is returned if there are no results.
  static List<String> magickQueryConfigureOptions(String pattern) {
    final ffi.Pointer<ffi.Char> patternPtr = pattern.toNativeUtf8().cast<ffi.Char>();
    final ffi.Pointer<ffi.Size> numOptionsPtr = malloc<ffi.Size>();
    final ffi.Pointer<ffi.Pointer<ffi.Char>> resultPtr =
        _bindings.magickQueryConfigureOptions(patternPtr, numOptionsPtr);
    final List<String> result = [];
    for (int i = 0; i < numOptionsPtr.value; i++) {
      result.add(resultPtr[i].cast<Utf8>().toDartString());
    }
    calloc.free(patternPtr);
    calloc.free(numOptionsPtr);
    calloc.free(resultPtr);
    return result;
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
  /// - Note: null is returned if the font metrics cannot be determined from the given input (for ex: if the
  /// [MagickWand] contains no images).
  List<double>? magickQueryFontMetrics(DrawingWand drawingWand, String text) {
    final ffi.Pointer<ffi.Char> textPtr = text.toNativeUtf8().cast<ffi.Char>();
    final ffi.Pointer<ffi.Double> metricsPtr =
        _bindings.magickQueryFontMetrics(_wandPtr, drawingWand._wandPtr, textPtr);
    final List<double>? metrics = metricsPtr == ffi.nullptr ? null : [];
    if (metrics != null) {
      for (int i = 0; i < 13; i++) {
        metrics.add(metricsPtr[i]);
      }
    }
    calloc.free(textPtr);
    calloc.free(metricsPtr);
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
  /// This method is like magickQueryFontMetrics() but it returns the maximum text width and height for multiple lines of text.
  /// - Note: null is returned if the font metrics cannot be determined from the given input (for ex: if the
  /// [MagickWand] contains no images).
  List<double>? magickQueryMultilineFontMetrics(DrawingWand drawingWand, String text) {
    final ffi.Pointer<ffi.Char> textPtr = text.toNativeUtf8().cast<ffi.Char>();
    final ffi.Pointer<ffi.Double> metricsPtr =
        _bindings.magickQueryMultilineFontMetrics(_wandPtr, drawingWand._wandPtr, textPtr);
    final List<double>? metrics = metricsPtr == ffi.nullptr ? null : [];
    if (metrics != null) {
      for (int i = 0; i < 13; i++) {
        metrics.add(metricsPtr[i]);
      }
    }
    calloc.free(textPtr);
    calloc.free(metricsPtr);
    return metrics;
  }

  /// Returns any font that match the specified pattern (e.g. "*" for all).
  static List<String> magickQueryFonts(String pattern) {
    final ffi.Pointer<ffi.Char> patternPtr = pattern.toNativeUtf8().cast<ffi.Char>();
    final ffi.Pointer<ffi.Size> numFontsPtr = malloc<ffi.Size>();
    final ffi.Pointer<ffi.Pointer<ffi.Char>> resultPtr = _bindings.magickQueryFonts(patternPtr, numFontsPtr);
    final List<String> result = [];
    for (int i = 0; i < numFontsPtr.value; i++) {
      result.add(resultPtr[i].cast<Utf8>().toDartString());
    }
    calloc.free(patternPtr);
    calloc.free(numFontsPtr);
    calloc.free(resultPtr);
    return result;
  }

  // TODO: complete adding the other methods

  /// Initializes the MagickWand environment.
  static void magickWandGenesis() {
    _bindings.magickWandGenesis();
  }

  /// Terminates the MagickWand environment.
  static void magickWandTerminus() {
    _bindings.magickWandTerminus();
  }

  /// Returns a wand required for all other methods in the API.
  /// A fatal exception is thrown if there is not enough memory to allocate the wand.
  /// Use destroyMagickWand() to dispose of the wand when it is no longer needed.
  factory MagickWand.newMagickWand() {
    return MagickWand._(_bindings.newMagickWand());
  }

  /// Reads an image or image sequence. The images are inserted just before the current image
  /// pointer position. Use magickSetFirstIterator(), to insert new images before all the current images
  /// in the wand, magickSetLastIterator() to append add to the end, magickSetIteratorIndex() to place
  /// images just after the given index.
  bool magickReadImage(String imageFilePath) {
    final ffi.Pointer<ffi.Char> imageFilePathPtr = imageFilePath.toNativeUtf8().cast<ffi.Char>();
    final bool result = _bindings.magickReadImage(_wandPtr, imageFilePathPtr);
    calloc.free(imageFilePathPtr);
    return result;
  }

  /// Writes an image to the specified filename. If the filename parameter is NULL, the image is written
  /// to the filename set by magickReadImage() or magickSetImageFilename().
  bool magickWriteImage(String imageFilePath) {
    final ffi.Pointer<ffi.Char> imageFilePathPtr = imageFilePath.toNativeUtf8().cast<ffi.Char>();
    final bool result = _bindings.magickWriteImage(_wandPtr, imageFilePathPtr);
    calloc.free(imageFilePathPtr);
    return result;
  }
}

/// An object used for drawing on an image.
class DrawingWand {
  final ffi.Pointer<ffi.Void> _wandPtr;

  const DrawingWand._(this._wandPtr);

// TODO: add fields and methods later
}

/// Represents the type of an exception that occurred when using the ImageMagick API.
enum ExceptionType {
  UndefinedException(0),
  WarningException(300),
  ResourceLimitWarning(300),
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
  ResourceLimitError(400),
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
  ResourceLimitFatalError(700),
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
