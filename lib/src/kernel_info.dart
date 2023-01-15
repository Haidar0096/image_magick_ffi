part of 'image_magick_ffi.dart';

/// Represents an image kernel matrix.
class KernelInfo {
  KernelInfoType? type;
  int? width;
  int? height;
  int? x;
  int? y;
  Float64List? values;
  double? minimum;
  double? maximum;
  double? negativeRange;
  double? positiveRange;
  double? angle;
  KernelInfo? next;
  int? signature;

  KernelInfo({
    this.type,
    this.width,
    this.height,
    this.x,
    this.y,
    this.values,
    this.minimum,
    this.maximum,
    this.negativeRange,
    this.positiveRange,
    this.angle,
    this.next,
    this.signature,
  });

  Pointer<_KernelInfoStruct> _toKernelInfoStructPointer(
      {required Allocator allocator}) {
    final Pointer<_KernelInfoStruct> kernelInfoStruct =
        allocator<_KernelInfoStruct>();
    kernelInfoStruct.ref.type = type?.index ?? 0;
    kernelInfoStruct.ref.width = width ?? 0;
    kernelInfoStruct.ref.height = height ?? 0;
    kernelInfoStruct.ref.x = x ?? 0;
    kernelInfoStruct.ref.y = y ?? 0;
    kernelInfoStruct.ref.values =
        values?.toDoubleArrayPointer(allocator: allocator) ?? nullptr;
    kernelInfoStruct.ref.minimum = minimum ?? 0.0;
    kernelInfoStruct.ref.maximum = maximum ?? 0.0;
    kernelInfoStruct.ref.negativeRange = negativeRange ?? 0.0;
    kernelInfoStruct.ref.positiveRange = positiveRange ?? 0.0;
    kernelInfoStruct.ref.angle = angle ?? 0.0;
    kernelInfoStruct.ref.next =
        next?._toKernelInfoStructPointer(allocator: allocator) ?? nullptr;
    kernelInfoStruct.ref.signature = signature ?? 0;
    return kernelInfoStruct;
  }
}

class _KernelInfoStruct extends Struct {
  @Int32()
  external int type;

  @Uint64()
  external int width;

  @Uint64()
  external int height;

  @Int64()
  external int x;

  @Int64()
  external int y;

  external Pointer<Double> values;

  @Double()
  external double minimum;

  @Double()
  external double maximum;

  @Double()
  external double negativeRange;

  @Double()
  external double positiveRange;

  @Double()
  external double angle;

  external Pointer<_KernelInfoStruct> next;

  @Uint64()
  external int signature;
}
