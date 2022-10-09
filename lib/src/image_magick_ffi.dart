import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:image_magick_ffi/src/image_magick_ffi_bindings_generated.dart';

////////////////////////////////////// Define the FFI library //////////////////////////////////////

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

////////////////////////////////////////////////////////////////////////////////////////////////////

/// The max size of the error message coming from the native code.
const int _maxErrorOutSize = 200;

/// Resizes an image.
///
/// Params:
/// - [inputFilePath] : The absolute path of the input image.
/// - [outputFilePath] : The absolute path of the output image.
/// - [width] : The target width.
/// - [height] : The target height.
/// - [keepAspectRatio] : Whether to keep aspect ratio of the output image. If this is false, then the output image may have
/// different size than the target size.
///
/// Returns:
/// - null if successful.
/// - A string with the failure message otherwise.
Future<String?> resize({
  required String inputFilePath,
  required String outputFilePath,
  required int width,
  required int height,
}) async {
  final ffi.Pointer<ffi.Char> inputFilePtr = inputFilePath.toNativeUtf8().cast<ffi.Char>();
  final ffi.Pointer<ffi.Char> outputFilePtr = outputFilePath.toNativeUtf8().cast<ffi.Char>();
  final ffi.Pointer<ffi.Char> errorOutPtr = calloc<ffi.Char>(_maxErrorOutSize);

  _bindings.resize(inputFilePtr, outputFilePtr, width, height, errorOutPtr, _maxErrorOutSize);

  calloc.free(inputFilePtr);
  calloc.free(outputFilePtr);
  final String result = errorOutPtr.cast<Utf8>().toDartString();
  calloc.free(errorOutPtr);

  if (result.isEmpty) {
    return null;
  } else {
    return result;
  }
}
