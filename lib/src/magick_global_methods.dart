part of 'image_magick_ffi.dart';

/// Returns the value associated with the specified configure option, or null in case of no match.
String? magickQueryConfigureOption(String option) {
  final Pointer<Char> optionPtr = option.toNativeUtf8().cast();
  final Pointer<Char> resultPtr = _bindings.magickQueryConfigureOption(optionPtr);
  malloc.free(optionPtr);
  if (resultPtr == nullptr) {
    return null;
  }
  final String result = resultPtr.cast<Utf8>().toDartString();
  _magickRelinquishMemory(resultPtr.cast());
  return result;
}

/// Returns any configure options that match the specified pattern (e.g. "*" for all). Options include NAME,
/// VERSION, LIB_VERSION, etc.
///
/// - Note: An empty list is returned if there are no results.
List<String>? magickQueryConfigureOptions(String pattern) {
  final Pointer<Char> patternPtr = pattern.toNativeUtf8().cast();
  final Pointer<Size> numOptionsPtr = malloc();
  final Pointer<Pointer<Char>> resultPtr = _bindings.magickQueryConfigureOptions(patternPtr, numOptionsPtr);
  malloc.free(patternPtr);
  int numOptions = numOptionsPtr.value;
  malloc.free(numOptionsPtr);
  final List<String>? result = resultPtr.toStringList(numOptions);
  _magickRelinquishMemory(resultPtr.cast());
  return result;
}

/// Returns any font that match the specified pattern (e.g. "*" for all).
List<String>? magickQueryFonts(String pattern) {
  final Pointer<Char> patternPtr = pattern.toNativeUtf8().cast();
  final Pointer<Size> numFontsPtr = malloc();
  final Pointer<Pointer<Char>> resultPtr = _bindings.magickQueryFonts(patternPtr, numFontsPtr);
  malloc.free(patternPtr);
  int numFonts = numFontsPtr.value;
  malloc.free(numFontsPtr);
  final List<String>? result = resultPtr.toStringList(numFonts);
  _magickRelinquishMemory(resultPtr.cast());
  return result;
}

/// Returns any image formats that match the specified pattern (e.g. "*" for all).
/// - Note: An empty list is returned if there are no results.
List<String>? magickQueryFormats(String pattern) {
  final Pointer<Char> patternPtr = pattern.toNativeUtf8().cast();
  final Pointer<Size> numFormatsPtr = malloc();
  final Pointer<Pointer<Char>> resultPtr = _bindings.magickQueryFormats(patternPtr, numFormatsPtr);
  malloc.free(patternPtr);
  int numFormats = numFormatsPtr.value;
  malloc.free(numFormatsPtr);
  final List<String>? result = resultPtr.toStringList(numFormats);
  _magickRelinquishMemory(resultPtr.cast());
  return result;
}

/// Relinquishes memory resources returned by such methods as MagickIdentifyImage(), MagickGetException(),
/// etc.
Pointer<Void> _magickRelinquishMemory(Pointer<Void> ptr) {
  return _bindings.magickRelinquishMemory(ptr);
}

/// Initializes the MagickWand environment.
void magickWandGenesis() {
  _bindings.magickWandGenesis();
}

/// Terminates the MagickWand environment.
void magickWandTerminus() {
  _bindings.magickWandTerminus();
}

/// Returns true if the ImageMagick environment is currently instantiated-- that is,
/// `magickWandGenesis()` has been called but `magickWandTerminus()` has not.
bool isMagickWandInstantiated() {
  return _bindings.isMagickWandInstantiated();
}

/// Returns the ImageMagick API copyright as a string.
String magickGetCopyright() {
  return _bindings.magickGetCopyright().cast<Utf8>().toDartString();
}

/// Returns the ImageMagick home URL.
String magickGetHomeURL() {
  Pointer<Char> resultPtr = _bindings.magickGetHomeURL();
  String result = resultPtr.cast<Utf8>().toDartString();
  _magickRelinquishMemory(resultPtr.cast());
  return result;
}

/// Returns the ImageMagick package name.
String magickGetPackageName() {
  return _bindings.magickGetPackageName().cast<Utf8>().toDartString();
}

/// Returns the ImageMagick quantum depth.
MagickGetQuantumDepthResult magickGetQuantumDepth() {
  final Pointer<Size> depthPtr = malloc();
  String depthString = _bindings.magickGetQuantumDepth(depthPtr).cast<Utf8>().toDartString();
  int depth = depthPtr.value;
  malloc.free(depthPtr);
  return MagickGetQuantumDepthResult(depth, depthString);
}

///  Returns the ImageMagick quantum range.
MagickGetQuantumRangeResult magickGetQuantumRange() {
  final Pointer<Size> rangePtr = malloc();
  String rangeString = _bindings.magickGetQuantumRange(rangePtr).cast<Utf8>().toDartString();
  int range = rangePtr.value;
  malloc.free(rangePtr);
  return MagickGetQuantumRangeResult(range, rangeString);
}

/// Returns the ImageMagick release date.
String magickGetReleaseDate() {
  return _bindings.magickGetReleaseDate().cast<Utf8>().toDartString();
}

/// Returns the specified resource in megabytes.
int magickGetResource(ResourceType type) {
  return _bindings.magickGetResource(type.index);
}

/// Returns the specified resource limit in megabytes.
int magickGetResourceLimit(ResourceType type) {
  return _bindings.magickGetResourceLimit(type.index);
}

/// Returns the ImageMagick version.
MagickGetVersionResult magickGetVersion() {
  final Pointer<Size> versionPtr = malloc();
  String versionString = _bindings.magickGetVersion(versionPtr).cast<Utf8>().toDartString();
  int version = versionPtr.value;
  malloc.free(versionPtr);
  return MagickGetVersionResult(version, versionString);
}

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
