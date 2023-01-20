part of 'image_magick_ffi.dart';

/// Initializes the necessary resources used with the plugin. This must be
/// called before any use of the plugin.
void _initialize() {
  _magickWandGenesis();
  assert(_bindings.initDartAPI(NativeApi.initializeApiDLData) == 0,
      'Failed to initialize Dart_API_DL');
}

/// Disposes the resources used with the plugin.
void disposeImageMagick() => _magickWandTerminus();

/// Returns the value associated with the specified configure option, or null
/// in case of no match.
String? magickQueryConfigureOption(String option) => using((Arena arena) {
      final Pointer<Char> optionPtr =
          option.toNativeUtf8(allocator: arena).cast();
      final Pointer<Char> resultPtr =
          _bindings.magickQueryConfigureOption(optionPtr);
      if (resultPtr == nullptr) {
        return null;
      }
      final String result = resultPtr.cast<Utf8>().toDartString();
      _magickRelinquishMemory(resultPtr.cast());
      return result;
    });

/// Returns any configure options that match the specified pattern (e.g. "*"
/// for all). Options include NAME, VERSION, LIB_VERSION, etc.
///
/// - Note: An empty list is returned if there are no results.
List<String>? magickQueryConfigureOptions(String pattern) =>
    using((Arena arena) {
      final Pointer<Char> patternPtr =
          pattern.toNativeUtf8(allocator: arena).cast();
      final Pointer<Size> numOptionsPtr = arena();
      final Pointer<Pointer<Char>> resultPtr =
          _bindings.magickQueryConfigureOptions(patternPtr, numOptionsPtr);
      int numOptions = numOptionsPtr.value;
      final List<String>? result = resultPtr.toStringList(numOptions);
      _magickRelinquishMemory(resultPtr.cast());
      return result;
    });

/// Returns any font that match the specified pattern (e.g. "*" for all).
List<String>? magickQueryFonts(String pattern) => using((Arena arena) {
      final Pointer<Char> patternPtr =
          pattern.toNativeUtf8(allocator: arena).cast();
      final Pointer<Size> numFontsPtr = arena();
      final Pointer<Pointer<Char>> resultPtr =
          _bindings.magickQueryFonts(patternPtr, numFontsPtr);
      int numFonts = numFontsPtr.value;
      final List<String>? result = resultPtr.toStringList(numFonts);
      _magickRelinquishMemory(resultPtr.cast());
      return result;
    });

/// Returns any image formats that match the specified pattern (e.g. "*" for
/// all).
/// - Note: An empty list is returned if there are no results.
List<String>? magickQueryFormats(String pattern) => using((Arena arena) {
      final Pointer<Char> patternPtr =
          pattern.toNativeUtf8(allocator: arena).cast();
      final Pointer<Size> numFormatsPtr = arena();
      final Pointer<Pointer<Char>> resultPtr =
          _bindings.magickQueryFormats(patternPtr, numFormatsPtr);
      int numFormats = numFormatsPtr.value;
      final List<String>? result = resultPtr.toStringList(numFormats);
      _magickRelinquishMemory(resultPtr.cast());
      return result;
    });

/// Relinquishes memory resources returned by such methods as
/// MagickIdentifyImage(), MagickGetException(), etc.
Pointer<Void> _magickRelinquishMemory(Pointer<Void> ptr) =>
    _bindings.magickRelinquishMemory(ptr);

/// Initializes the MagickWand environment.
void _magickWandGenesis() => _bindings.magickWandGenesis();

/// Terminates the MagickWand environment.
void _magickWandTerminus() => _bindings.magickWandTerminus();

/// Returns true if the ImageMagick environment is currently instantiated--
/// that is, `magickWandGenesis()` has been called but `magickWandTerminus()`
/// has not.
bool isMagickWandInstantiated() => _bindings.isMagickWandInstantiated();

/// Returns the ImageMagick API copyright as a string.
String magickGetCopyright() =>
    _bindings.magickGetCopyright().cast<Utf8>().toDartString();

/// Returns the ImageMagick home URL.
String magickGetHomeURL() {
  Pointer<Char> resultPtr = _bindings.magickGetHomeURL();
  String result = resultPtr.cast<Utf8>().toDartString();
  _magickRelinquishMemory(resultPtr.cast());
  return result;
}

/// Returns the ImageMagick package name.
String magickGetPackageName() =>
    _bindings.magickGetPackageName().cast<Utf8>().toDartString();

/// Returns the ImageMagick quantum depth.
MagickGetQuantumDepthResult magickGetQuantumDepth() => using((Arena arena) {
      final Pointer<Size> depthPtr = arena();
      String depthString =
          _bindings.magickGetQuantumDepth(depthPtr).cast<Utf8>().toDartString();
      return MagickGetQuantumDepthResult(depthPtr.value, depthString);
    });

///  Returns the ImageMagick quantum range.
MagickGetQuantumRangeResult magickGetQuantumRange() => using((Arena arena) {
      final Pointer<Size> rangePtr = arena();
      String rangeString =
          _bindings.magickGetQuantumRange(rangePtr).cast<Utf8>().toDartString();
      return MagickGetQuantumRangeResult(rangePtr.value, rangeString);
    });

/// Returns the ImageMagick release date.
String magickGetReleaseDate() =>
    _bindings.magickGetReleaseDate().cast<Utf8>().toDartString();

/// Returns the specified resource in megabytes.
int magickGetResource(ResourceType type) =>
    _bindings.magickGetResource(type.index);

/// Returns the specified resource limit in megabytes.
int magickGetResourceLimit(ResourceType type) =>
    _bindings.magickGetResourceLimit(type.index);

/// Returns the ImageMagick version.
MagickGetVersionResult magickGetVersion() => using((Arena arena) {
      final Pointer<Size> versionPtr = arena();
      String versionString =
          _bindings.magickGetVersion(versionPtr).cast<Utf8>().toDartString();
      return MagickGetVersionResult(versionPtr.value, versionString);
    });

/// Sets the limit for a particular resource in megabytes.
/// - [type]: The resource type.
/// - [limit]: The limit in megabytes.
bool magickSetResourceLimit(ResourceType type, int limit) =>
    _bindings.magickSetResourceLimit(type.index, limit);

/// Sets the pseudo-random number generator seed. Use it to generate a
/// predictable sequence of random numbers.
void magickSetSeed(int seed) => _bindings.magickSetSeed(seed);

// TODO: continue adding the remaining methods

/// Represents a result to a call to `magickGetQuantumDepth()`.
class MagickGetQuantumDepthResult {
  /// The depth as an integer.
  final int depth;

  /// The depth as a string.
  final String depthString;

  const MagickGetQuantumDepthResult(this.depth, this.depthString);
}

/// Represents a result to a call to `magickGetQuantumRange()`.
class MagickGetQuantumRangeResult {
  /// The range as an integer.
  final int range;

  /// The range as a string.
  final String rangeString;

  const MagickGetQuantumRangeResult(this.range, this.rangeString);
}

/// Represents a result to a call to `magickGetVersion()`.
class MagickGetVersionResult {
  /// The version as an integer.
  final int version;

  /// The version as a string.
  final String versionString;

  const MagickGetVersionResult(this.version, this.versionString);
}
