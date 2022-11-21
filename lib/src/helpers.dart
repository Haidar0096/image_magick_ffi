part of 'image_magick_ffi.dart';

/// Used with managing memory resources on the native heap associated with dart objects.
class _MagickRelinquishableResource implements Finalizable {
  static final NativeFinalizer _finalizer = NativeFinalizer(_dylib.lookup('magickRelinquishMemory'));

  /// Represents a map with weak keys. The keys of the map will be dart objects, and the values will be
  /// `_MagickRelinquishableResource` objects (which are `Finalizable` objects). When the dart object (the key)
  /// is garbage-collected, the associated `_MagickRelinquishableResource` object (the value) will be
  /// garbage-collected, and the native cleanup function will be invoked, which will cause the associated memory
  /// to be freed.
  static final Expando<_MagickRelinquishableResource> _relinquishables = Expando();

  _MagickRelinquishableResource._();

  /// Registers [ptr] to be freed when [obj] is garbage-collected.
  ///
  /// For more info on the other params, see [NativeFinalizer.attach]
  static void registerRelinquishable(TypedData obj, Pointer<Void> ptr, {Pointer<Void>? detach, int? externalSize}) {
    _MagickRelinquishableResource finalizable = _MagickRelinquishableResource._();
    _finalizer.attach(finalizable, ptr, detach: detach, externalSize: externalSize);
    _relinquishables[obj] = finalizable;
  }
}
