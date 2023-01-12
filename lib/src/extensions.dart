import 'dart:ffi';

import 'package:ffi/ffi.dart';

extension UnsignedCharPointerExtension on Pointer<UnsignedChar> {
  /// Creates a `List<int>` from this pointer by copying the pointer's data.
  ///
  /// `length` is the length of the array.
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
  Pointer<UnsignedChar> toUnsignedCharArrayPointer({required Allocator allocator}) {
    if (isEmpty) {
      return nullptr;
    }
    final Pointer<UnsignedChar> array = allocator(sizeOf<UnsignedChar>() * length);
    for (int i = 0; i < length; i++) {
      array[i] = this[i];
    }
    return array;
  }
}

extension DoubleListExtension on List<double>{
  /// Creates a `double` array from this list by copying the list's data, and returns
  /// a pointer to it.
  ///
  /// `nullptr` is returned if the list is empty.
  Pointer<Double> toDoubleArrayPointer({required Allocator allocator}) {
    if (isEmpty) {
      return nullptr;
    }
    final Pointer<Double> array = allocator(sizeOf<Double>() * length);
    for (int i = 0; i < length; i++) {
      array[i] = this[i];
    }
    return array;
  }
}

extension CharPointerPointerExtension on Pointer<Pointer<Char>> {
  /// Creates a `List<String>` from this pointer by copying the pointer's data.
  ///
  /// `length` is the length of the array.
  ///
  /// null is returned if the pointer is equal to `nullptr`.
  List<String>? toStringList(int length) {
    if (this == nullptr) {
      return null;
    }
    final List<String> list = [];
    for (int i = 0; i < length; i++) {
      // this is sad, see if this can be done without copying the data.
      list.add(this[i].cast<Utf8>().toDartString());
    }
    return list;
  }
}
