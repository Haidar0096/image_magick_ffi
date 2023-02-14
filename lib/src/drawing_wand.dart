part of 'image_magick_ffi.dart';

// TODO: add docs
class DrawingWand {
  final Pointer<mwbg.DrawingWand> _wandPtr;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DrawingWand &&
          runtimeType == other.runtimeType &&
          _wandPtr == other._wandPtr;

  @override
  int get hashCode => _wandPtr.hashCode;

  const DrawingWand._(this._wandPtr);

// TODO: add fields and methods later
}
