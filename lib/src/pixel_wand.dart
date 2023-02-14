part of 'image_magick_ffi.dart';

// TODO: add docs
class PixelWand {
  final Pointer<mwbg.PixelWand> _wandPtr;

  const PixelWand._(this._wandPtr);

  static PixelWand? _fromAddress(int address) => address == 0
      ? null
      : PixelWand._(Pointer<mwbg.PixelWand>.fromAddress(address));

// TODO: add fields and methods later
}
