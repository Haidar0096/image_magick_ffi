import 'dart:ffi';

import 'package:ffi/ffi.dart';

extension UnsignedCharPointerExtension on Pointer<UnsignedChar> {
  /// Creates a `List<int>` from this pointer by copying the pointer's data.
  ///
  /// null is returned if the pointer is equal to `nullptr`.
  List<int>? toIntList(int length) {
    if (this == nullptr) {
      return null;
    }
    final List<int> list = [];
    for (int i = 0; i < length; i++) {
      // this is sad, see if this can be done without copying the data.
      list.add(this[i]);
    }
    return list;
  }
}

extension IntListExtension on List<int> {
  /// Creates an `unsigned char` array from this list by copying the list's data, and returns
  /// a pointer to it.
  ///
  /// `nullptr` is returned if the list is empty.
  Pointer<UnsignedChar> toUnsignedCharPointer() {
    if (isEmpty) {
      return nullptr;
    }
    final Pointer<UnsignedChar> array = malloc(sizeOf<UnsignedChar>() * length);
    for (int i = 0; i < length; i++) {
      array[i] = this[i];
    }
    return array;
  }
}
