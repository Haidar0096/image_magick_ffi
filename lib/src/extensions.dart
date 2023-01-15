import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

extension UnsignedCharPointerExtension on Pointer<UnsignedChar> {
  /// Creates a `Uint8List` from this pointer by copying the pointer's data.
  ///
  /// `length` is the length of the array.
  ///
  /// null is returned if the pointer is equal to `nullptr`.
  Uint8List? toUint8List(int length) {
    if (this == nullptr) {
      return null;
    }
    final Uint8List list = Uint8List(length);
    for (int i = 0; i < length; i++) {
      // this is sad, see if this can be done without copying the data.
      list[i] = this[i];
    }
    return list;
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

extension Uint8ListExtension on Uint8List {
  /// Creates an `unsigned char` array from this list by copying the
  /// list's data, and returns a pointer to it.
  ///
  /// `nullptr` is returned if the list is empty.
  Pointer<UnsignedChar> toUnsignedCharArrayPointer(
      {required Allocator allocator}) {
    if (isEmpty) {
      return nullptr;
    }
    final Pointer<UnsignedChar> ptr =
        allocator(sizeOf<UnsignedChar>() * length);
    for (int i = 0; i < length; i++) {
      // this is sad, see if this can be done without copying the data.
      ptr[i] = this[i];
    }
    return ptr;
  }
}

extension Uint16ListExtension on Uint16List {
  /// Creates an `unsigned short` array from this list by copying the
  /// list's data, and returns a pointer to it.
  ///
  /// `nullptr` is returned if the list is empty.
  Pointer<Uint16> toUint16ArrayPointer({required Allocator allocator}) {
    if (isEmpty) {
      return nullptr;
    }
    final Pointer<Uint16> ptr = allocator(sizeOf<Uint16>() * length);
    for (int i = 0; i < length; i++) {
      // this is sad, see if this can be done without copying the data.
      ptr[i] = this[i];
    }
    return ptr;
  }
}

extension Uint32ListExtension on Uint32List {
  /// Creates an `unsigned int` array from this list by copying the
  /// list's data, and returns a pointer to it.
  ///
  /// `nullptr` is returned if the list is empty.
  Pointer<Uint32> toUint32ArrayPointer({required Allocator allocator}) {
    if (isEmpty) {
      return nullptr;
    }
    final Pointer<Uint32> ptr = allocator(sizeOf<Uint32>() * length);
    for (int i = 0; i < length; i++) {
      // this is sad, see if this can be done without copying the data.
      ptr[i] = this[i];
    }
    return ptr;
  }
}

extension Uint64ListExtension on Uint64List {
  /// Creates an `unsigned long long` array from this list by copying
  /// the list's  data, and returns a pointer to it.
  ///
  /// `nullptr` is returned if the list is empty.
  Pointer<Uint64> toUint64ArrayPointer({required Allocator allocator}) {
    if (isEmpty) {
      return nullptr;
    }
    final Pointer<Uint64> ptr = allocator(sizeOf<Uint64>() * length);
    for (int i = 0; i < length; i++) {
      // this is sad, see if this can be done without copying the data.
      ptr[i] = this[i];
    }
    return ptr;
  }
}

extension Float32ListExtension on Float32List {
  /// Creates a `float` array from this list by copying the list's data,
  /// and returns a pointer to it.
  ///
  /// `nullptr` is returned if the list is empty.
  Pointer<Float> toFloatArrayPointer({required Allocator allocator}) {
    if (isEmpty) {
      return nullptr;
    }
    final Pointer<Float> ptr = allocator(sizeOf<Float>() * length);
    for (int i = 0; i < length; i++) {
      // this is sad, see if this can be done without copying the data.
      ptr[i] = this[i];
    }
    return ptr;
  }
}

extension Float64ListExtension on Float64List {
  /// Creates a `double` array from this list by copying the list's
  /// data, and returns a pointer to it.
  ///
  /// `nullptr` is returned if the list is empty.
  Pointer<Double> toDoubleArrayPointer({required Allocator allocator}) {
    if (isEmpty) {
      return nullptr;
    }
    final Pointer<Double> ptr = allocator(sizeOf<Double>() * length);
    for (int i = 0; i < length; i++) {
      // this is sad, see if this can be done without copying the data.
      ptr[i] = this[i];
    }
    return ptr;
  }
}
