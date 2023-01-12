part of 'image_magick_ffi.dart';

/// Represents an image kernel matrix.
class KernelInfo {
  KernelInfoType? type;
  int? width;
  int? height;
  int? x;
  int? y;
  List<double>? values;
  double? minimum;
  double? maximum;
  double? negativeRange;
  double? positiveRange;
  double? angle;

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
  });

  Pointer<_KernelInfoStruct> _toKernelInfoStructPointer({required Allocator allocator}) {
    final Pointer<_KernelInfoStruct> kernelInfoStruct = allocator<_KernelInfoStruct>();
    kernelInfoStruct.ref.type = type?.index;
    kernelInfoStruct.ref.width = width;
    kernelInfoStruct.ref.height = height;
    kernelInfoStruct.ref.x = x;
    kernelInfoStruct.ref.y = y;
    kernelInfoStruct.ref.values = values?.toDoubleArrayPointer(allocator: allocator);
    kernelInfoStruct.ref.minimum = minimum;
    kernelInfoStruct.ref.maximum = maximum;
    kernelInfoStruct.ref.negativeRange = negativeRange;
    kernelInfoStruct.ref.positiveRange = positiveRange;
    kernelInfoStruct.ref.angle = angle;
    return kernelInfoStruct;
  }
}

class _KernelInfoStruct extends Struct {
  @Int32()
  external int? type;

  @Int64()
  external int? width;

  @Int64()
  external int? height;

  @Int64()
  external int? x;

  @Int64()
  external int? y;

  external Pointer<Double>? values;

  @Double()
  external double? minimum;

  @Double()
  external double? maximum;

  @Double()
  external double? negativeRange;

  @Double()
  external double? positiveRange;

  @Double()
  external double? angle;
}
