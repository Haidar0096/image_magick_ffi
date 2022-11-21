import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

extension Uint8ListExtension on Uint8List {
  /// Creates an unsigned char array from this [Uint8List]. The caller is responsible for freeing the
  /// assigned memory.
  // TODO: this is sad, see if this can be done without copying the data.
  Pointer<UnsignedChar> toUnsignedCharArray() {
    final Pointer<UnsignedChar> pointer = malloc(sizeOf<UnsignedChar>() * (length));
    for (int i = 0; i < length; i++) {
      pointer[i] = this[i];
    }
    return pointer;
  }
}
