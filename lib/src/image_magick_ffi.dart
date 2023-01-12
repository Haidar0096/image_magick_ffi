// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:image_magick_ffi/src/extensions.dart';
import 'package:image_magick_ffi/src/image_magick_ffi_bindings_generated.dart';

part 'magick_wand.dart';

part 'drawing_wand.dart';

part 'pixel_wand.dart';

part 'magick_enums.dart';

part 'magick_global_methods.dart';

part 'memory.dart';

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
