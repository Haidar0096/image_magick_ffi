part of 'image_magick_ffi.dart';

/// Represents an exception that occurred while using the ImageMagick API.
class MagickGetExceptionResult {
  /// The type of the exception.
  final ExceptionType severity;

  /// The description of the exception.
  final String description;

  const MagickGetExceptionResult(this.severity, this.description);

  @override
  String toString() {
    return 'MagickException{severity: $severity, description: $description}';
  }
}

/// Represents a result to a call to `magickGetPage()`.
class MagickGetPageResult {
  final int width;
  final int height;
  final int x;
  final int y;

  const MagickGetPageResult(this.width, this.height, this.x, this.y);
}

/// Represents a result to a call to `magickGetResolution()`.
class MagickGetResolutionResult {
  final double x;
  final double y;

  const MagickGetResolutionResult(this.x, this.y);
}

/// Represents a result to a call to `magickGetSize()`.
class MagickGetSizeResult {
  final int width;
  final int height;

  const MagickGetSizeResult(this.width, this.height);
}

class _MagickAdaptiveBlurImageParams {
  final int wandPtrAddress;
  final double radius;
  final double sigma;

  _MagickAdaptiveBlurImageParams(this.wandPtrAddress, this.radius, this.sigma);
}

Future<bool> _magickAdaptiveBlurImage(
        _MagickAdaptiveBlurImageParams params) async =>
    _bindings.magickAdaptiveBlurImage(
      Pointer<Void>.fromAddress(params.wandPtrAddress),
      params.radius,
      params.sigma,
    );

class _MagickAdaptiveResizeImageParams {
  final int wandPtrAddress;
  final int columns;
  final int rows;

  _MagickAdaptiveResizeImageParams(
      this.wandPtrAddress, this.columns, this.rows);
}

Future<bool> _magickAdaptiveResizeImage(
        _MagickAdaptiveResizeImageParams params) async =>
    _bindings.magickAdaptiveResizeImage(
      Pointer<Void>.fromAddress(params.wandPtrAddress),
      params.columns,
      params.rows,
    );

class _MagickAdaptiveSharpenImageParams {
  final int wandPtrAddress;
  final double radius;
  final double sigma;

  _MagickAdaptiveSharpenImageParams(
    this.wandPtrAddress,
    this.radius,
    this.sigma,
  );
}

Future<bool> _magickAdaptiveSharpenImage(
        _MagickAdaptiveSharpenImageParams params) async =>
    _bindings.magickAdaptiveSharpenImage(
      Pointer<Void>.fromAddress(params.wandPtrAddress),
      params.radius,
      params.sigma,
    );

class _MagickAdaptiveThresholdImageParams {
  final int wandPtrAddress;
  final int width;
  final int height;
  final double bias;

  _MagickAdaptiveThresholdImageParams(
      this.wandPtrAddress, this.width, this.height, this.bias);
}

Future<bool> _magickAdaptiveThresholdImage(
        _MagickAdaptiveThresholdImageParams params) async =>
    _bindings.magickAdaptiveThresholdImage(
      Pointer<Void>.fromAddress(params.wandPtrAddress),
      params.width,
      params.height,
      params.bias,
    );

class _MagickAddImageParams {
  final int wandPtrAddress;
  final int otherWandPtrAddress;

  _MagickAddImageParams(this.wandPtrAddress, this.otherWandPtrAddress);
}

Future<bool> _magickAddImage(_MagickAddImageParams params) async =>
    _bindings.magickAddImage(
      Pointer<Void>.fromAddress(params.wandPtrAddress),
      Pointer<Void>.fromAddress(params.otherWandPtrAddress),
    );

class _MagickAddNoiseImageParams {
  final int wandPtrAddress;
  final int noiseTypeIndex;
  final double attenuate;

  _MagickAddNoiseImageParams(
      this.wandPtrAddress, this.noiseTypeIndex, this.attenuate);
}

Future<bool> _magickAddNoiseImage(_MagickAddNoiseImageParams params) async =>
    _bindings.magickAddNoiseImage(
      Pointer<Void>.fromAddress(params.wandPtrAddress),
      params.noiseTypeIndex,
      params.attenuate,
    );

class _MagickAffineTransformImageParams {
  final int wandPtrAddress;
  final int drawingWandPtrAddress;

  _MagickAffineTransformImageParams(
    this.wandPtrAddress,
    this.drawingWandPtrAddress,
  );
}

Future<bool> _magickAffineTransformImage(
        _MagickAffineTransformImageParams params) async =>
    _bindings.magickAffineTransformImage(
      Pointer<Void>.fromAddress(params.wandPtrAddress),
      Pointer<Void>.fromAddress(params.drawingWandPtrAddress),
    );

class _MagickAnnotateImageParams {
  final int wandPtrAddress;
  final int drawingWandPtrAddress;
  final double x;
  final double y;
  final double angle;
  final String text;

  _MagickAnnotateImageParams(this.wandPtrAddress, this.drawingWandPtrAddress,
      this.x, this.y, this.angle, this.text);
}

Future<bool> _magickAnnotateImage(_MagickAnnotateImageParams params) async =>
    using(
      (Arena arena) => _bindings.magickAnnotateImage(
        Pointer<Void>.fromAddress(params.wandPtrAddress),
        Pointer<Void>.fromAddress(params.drawingWandPtrAddress),
        params.x,
        params.y,
        params.angle,
        params.text.toNativeUtf8(allocator: arena).cast(),
      ),
    );

class _MagickAppendImagesParams {
  final int wandPtrAddress;
  final bool stack;

  _MagickAppendImagesParams(this.wandPtrAddress, this.stack);
}

Future<int> _magickAppendImages(_MagickAppendImagesParams params) async =>
    _bindings
        .magickAppendImages(
          Pointer<Void>.fromAddress(params.wandPtrAddress),
          params.stack,
        )
        .address;

Future<bool> _magickAutoGammaImage(int wandPtrAddress) async =>
    _bindings.magickAutoGammaImage(Pointer<Void>.fromAddress(wandPtrAddress));

Future<bool> _magickAutoLevelImage(int wandPtrAddress) async =>
    _bindings.magickAutoLevelImage(Pointer<Void>.fromAddress(wandPtrAddress));

Future<bool> _magickAutoOrientImage(int wandPtrAddress) async =>
    _bindings.magickAutoOrientImage(Pointer<Void>.fromAddress(wandPtrAddress));

class _MagickAutoThresholdImageParams {
  final int wandPtrAddress;
  final int thresholdMethodIndex;

  _MagickAutoThresholdImageParams(
      this.wandPtrAddress, this.thresholdMethodIndex);
}

Future<bool> _magickAutoThresholdImage(
        _MagickAutoThresholdImageParams params) async =>
    _bindings.magickAutoThresholdImage(
      Pointer<Void>.fromAddress(params.wandPtrAddress),
      params.thresholdMethodIndex,
    );

class _MagickBilateralBlurImageParams {
  final int wandPtrAddress;
  final double radius;
  final double sigma;
  final double intensitySigma;
  final double spatialSigma;

  _MagickBilateralBlurImageParams(
    this.wandPtrAddress,
    this.radius,
    this.sigma,
    this.intensitySigma,
    this.spatialSigma,
  );
}

Future<bool> _magickBilateralBlurImage(
        _MagickBilateralBlurImageParams params) async =>
    _bindings.magickBilateralBlurImage(
      Pointer<Void>.fromAddress(params.wandPtrAddress),
      params.radius,
      params.sigma,
      params.intensitySigma,
      params.spatialSigma,
    );

class _MagickBlackThresholdImageParams {
  final int wandPtrAddress;
  final int thresholdWandPtrAddress;

  _MagickBlackThresholdImageParams(
      this.wandPtrAddress, this.thresholdWandPtrAddress);
}

Future<bool> _magickBlackThresholdImage(
        _MagickBlackThresholdImageParams params) async =>
    _bindings.magickBlackThresholdImage(
      Pointer<Void>.fromAddress(params.wandPtrAddress),
      Pointer<Void>.fromAddress(params.thresholdWandPtrAddress),
    );

class _MagickBlueShiftImageParams {
  final int wandPtrAddress;
  final double factor;

  _MagickBlueShiftImageParams(this.wandPtrAddress, this.factor);
}

Future<bool> _magickBlueShiftImage(_MagickBlueShiftImageParams params) async =>
    _bindings.magickBlueShiftImage(
      Pointer<Void>.fromAddress(params.wandPtrAddress),
      params.factor,
    );

class _MagickBlurImageParams {
  final int wandPtrAddress;
  final double radius;
  final double sigma;

  _MagickBlurImageParams(this.wandPtrAddress, this.radius, this.sigma);
}

Future<bool> _magickBlurImage(_MagickBlurImageParams params) async =>
    _bindings.magickBlurImage(
      Pointer<Void>.fromAddress(params.wandPtrAddress),
      params.radius,
      params.sigma,
    );

class _MagickBorderImageParams {
  final int wandPtrAddress;
  final int borderWandPtrAddress;
  final int width;
  final int height;
  final int composeIndex;

  _MagickBorderImageParams(
    this.wandPtrAddress,
    this.borderWandPtrAddress,
    this.width,
    this.height,
    this.composeIndex,
  );
}

Future<bool> _magickBorderImage(_MagickBorderImageParams params) async =>
    _bindings.magickBorderImage(
      Pointer<Void>.fromAddress(params.wandPtrAddress),
      Pointer<Void>.fromAddress(params.borderWandPtrAddress),
      params.width,
      params.height,
      params.composeIndex,
    );

class _MagickBrightnessContrastImageParams {
  final int wandPtrAddress;
  final double brightness;
  final double contrast;

  _MagickBrightnessContrastImageParams(
    this.wandPtrAddress,
    this.brightness,
    this.contrast,
  );
}

Future<bool> _magickBrightnessContrastImage(
        _MagickBrightnessContrastImageParams params) async =>
    _bindings.magickBrightnessContrastImage(
      Pointer<Void>.fromAddress(params.wandPtrAddress),
      params.brightness,
      params.contrast,
    );

class _MagickCannyEdgeImageParams {
  final int wandPtrAddress;
  final double radius;
  final double sigma;
  final double lowerPercent;
  final double upperPercent;

  _MagickCannyEdgeImageParams(
    this.wandPtrAddress,
    this.radius,
    this.sigma,
    this.lowerPercent,
    this.upperPercent,
  );
}

Future<bool> _magickCannyEdgeImage(_MagickCannyEdgeImageParams params) async =>
    _bindings.magickCannyEdgeImage(
      Pointer<Void>.fromAddress(params.wandPtrAddress),
      params.radius,
      params.sigma,
      params.lowerPercent,
      params.upperPercent,
    );

class _MagickChannelFxImageParams {
  final int wandPtrAddress;
  final String expression;

  _MagickChannelFxImageParams(this.wandPtrAddress, this.expression);
}

Future<int> _magickChannelFxImage(_MagickChannelFxImageParams params) async =>
    using(
      (Arena arena) => _bindings
          .magickChannelFxImage(
            Pointer<Void>.fromAddress(params.wandPtrAddress),
            params.expression.toNativeUtf8(allocator: arena).cast(),
          )
          .address,
    );

class _MagickCharcoalImageParams {
  final int wandPtrAddress;
  final double radius;
  final double sigma;

  _MagickCharcoalImageParams(this.wandPtrAddress, this.radius, this.sigma);
}

Future<bool> _magickCharcoalImage(_MagickCharcoalImageParams params) async =>
    _bindings.magickCharcoalImage(
      Pointer<Void>.fromAddress(params.wandPtrAddress),
      params.radius,
      params.sigma,
    );

class _MagickChopImageParams {
  final int wandPtrAddress;
  final int width;
  final int height;
  final int x;
  final int y;

  _MagickChopImageParams(
    this.wandPtrAddress,
    this.width,
    this.height,
    this.x,
    this.y,
  );
}

Future<bool> _magickChopImage(_MagickChopImageParams params) async =>
    _bindings.magickChopImage(Pointer<Void>.fromAddress(params.wandPtrAddress),
        params.width, params.height, params.x, params.y);

class _MagickCLAHEImageParams {
  final int wandPtrAddress;
  final int width;
  final int height;
  final double numberBins;
  final double clipLimit;

  _MagickCLAHEImageParams(
    this.wandPtrAddress,
    this.width,
    this.height,
    this.numberBins,
    this.clipLimit,
  );
}

Future<bool> _magickCLAHEImage(_MagickCLAHEImageParams params) async =>
    _bindings.magickCLAHEImage(
      Pointer<Void>.fromAddress(params.wandPtrAddress),
      params.width,
      params.height,
      params.numberBins,
      params.clipLimit,
    );

Future<bool> _magickClampImage(int wandPtrAddress) async =>
    _bindings.magickClampImage(Pointer<Void>.fromAddress(wandPtrAddress));

Future<bool> _magickClipImage(int wandPtrAddress) async =>
    _bindings.magickClipImage(Pointer<Void>.fromAddress(wandPtrAddress));

class _MagickClipImagePathParams {
  final int wandPtrAddress;
  final String pathname;
  final bool inside;

  _MagickClipImagePathParams(this.wandPtrAddress, this.pathname, this.inside);
}

Future<bool> _magickClipImagePath(_MagickClipImagePathParams params) async =>
    using(
      (Arena arena) => _bindings.magickClipImagePath(
        Pointer<Void>.fromAddress(params.wandPtrAddress),
        params.pathname.toNativeUtf8(allocator: arena).cast(),
        params.inside,
      ),
    );

class _MagickClutImageParams {
  final int wandPtrAddress;
  final int clutWandPtrAddress;
  final int interpolateMethod;

  _MagickClutImageParams(
    this.wandPtrAddress,
    this.clutWandPtrAddress,
    this.interpolateMethod,
  );
}

Future<bool> _magickClutImage(_MagickClutImageParams params) async =>
    _bindings.magickClutImage(
      Pointer<Void>.fromAddress(params.wandPtrAddress),
      Pointer<Void>.fromAddress(params.clutWandPtrAddress),
      params.interpolateMethod,
    );

Future<int> _magickCoalesceImages(int wandPtrAddress) async => _bindings
    .magickCoalesceImages(Pointer<Void>.fromAddress(wandPtrAddress))
    .address;

class _MagickColorDecisionListImageParams {
  final int wandPtrAddress;
  final String colorCorrectionCollection;

  _MagickColorDecisionListImageParams(
    this.wandPtrAddress,
    this.colorCorrectionCollection,
  );
}

Future<bool> _magickColorDecisionListImage(
        _MagickColorDecisionListImageParams params) async =>
    using(
      (Arena arena) => _bindings.magickColorDecisionListImage(
        Pointer<Void>.fromAddress(params.wandPtrAddress),
        params.colorCorrectionCollection.toNativeUtf8(allocator: arena).cast(),
      ),
    );

class _MagickColorizeImageParams {
  final int wandPtrAddress;
  final int colorizePixelWandPtrAddress;
  final int blendPixelWandPtrAddress;

  _MagickColorizeImageParams(
    this.wandPtrAddress,
    this.colorizePixelWandPtrAddress,
    this.blendPixelWandPtrAddress,
  );
}

Future<bool> _magickColorizeImage(_MagickColorizeImageParams params) async =>
    _bindings.magickColorizeImage(
      Pointer<Void>.fromAddress(params.wandPtrAddress),
      Pointer<Void>.fromAddress(params.colorizePixelWandPtrAddress),
      Pointer<Void>.fromAddress(params.blendPixelWandPtrAddress),
    );

class _MagickColorMatrixImageParams {
  final int wandPtrAddress;
  final KernelInfo colorMatrix;

  _MagickColorMatrixImageParams(this.wandPtrAddress, this.colorMatrix);
}

Future<bool> _magickColorMatrixImage(
        _MagickColorMatrixImageParams params) async =>
    using(
      (Arena arena) => _bindings.magickColorMatrixImage(
        Pointer<Void>.fromAddress(params.wandPtrAddress),
        params.colorMatrix._toKernelInfoStructPointer(allocator: arena).cast(),
      ),
    );

class _MagickColorThresholdImageParams {
  final int wandPtrAddress;
  final int startColorPixelWandPtrAddress;
  final int endColorPixelWandPtrAddress;

  _MagickColorThresholdImageParams(
    this.wandPtrAddress,
    this.startColorPixelWandPtrAddress,
    this.endColorPixelWandPtrAddress,
  );
}

Future<bool> _magickColorThresholdImage(
        _MagickColorThresholdImageParams params) async =>
    _bindings.magickColorThresholdImage(
      Pointer<Void>.fromAddress(params.wandPtrAddress),
      Pointer<Void>.fromAddress(params.startColorPixelWandPtrAddress),
      Pointer<Void>.fromAddress(params.endColorPixelWandPtrAddress),
    );

class _MagickCombineImagesParams {
  final int wandPtrAddress;
  final int colorSpaceType;

  _MagickCombineImagesParams(this.wandPtrAddress, this.colorSpaceType);
}

Future<int> _magickCombineImages(_MagickCombineImagesParams params) async =>
    _bindings
        .magickCombineImages(
          Pointer<Void>.fromAddress(params.wandPtrAddress),
          params.colorSpaceType,
        )
        .address;

class _MagickCommentImageParams {
  final int wandPtrAddress;
  final String comment;

  _MagickCommentImageParams(this.wandPtrAddress, this.comment);
}

Future<bool> _magickCommentImage(_MagickCommentImageParams args) async => using(
      (Arena arena) => _bindings.magickCommentImage(
        Pointer<Void>.fromAddress(args.wandPtrAddress),
        args.comment.toNativeUtf8(allocator: arena).cast(),
      ),
    );

class _MagickCompareImagesLayersParams {
  final int wandPtrAddress;
  final int compareLayerMethod;

  _MagickCompareImagesLayersParams(
      this.wandPtrAddress, this.compareLayerMethod);
}

Future<int> _magickCompareImagesLayers(
        _MagickCompareImagesLayersParams args) async =>
    _bindings
        .magickCompareImagesLayers(
          Pointer<Void>.fromAddress(args.wandPtrAddress),
          args.compareLayerMethod,
        )
        .address;

class _MagickCompareImagesParams {
  final int wandPtrAddress;
  final int referenceWandPtrAddress;
  final int metricType;
  final Float64List distortion;

  _MagickCompareImagesParams(
    this.wandPtrAddress,
    this.referenceWandPtrAddress,
    this.metricType,
    this.distortion,
  );
}

Future<int> _magickCompareImages(_MagickCompareImagesParams args) async =>
    using(
      (Arena arena) => _bindings
          .magickCompareImages(
            Pointer<Void>.fromAddress(args.wandPtrAddress),
            Pointer<Void>.fromAddress(args.referenceWandPtrAddress),
            args.metricType,
            args.distortion.toDoubleArrayPointer(allocator: arena),
          )
          .address,
    );

class _MagickComplexImagesParams {
  final int wandPtrAddress;
  final int complexOperator;

  _MagickComplexImagesParams(this.wandPtrAddress, this.complexOperator);
}

Future<int> _magickComplexImages(_MagickComplexImagesParams args) async =>
    _bindings
        .magickComplexImages(
          Pointer<Void>.fromAddress(args.wandPtrAddress),
          args.complexOperator,
        )
        .address;

class _MagickCompositeImageParams {
  final int wandPtrAddress;
  final int sourceWandPtrAddress;
  final int compositeOperator;
  final bool clipToSelf;
  final int x;
  final int y;

  _MagickCompositeImageParams(
    this.wandPtrAddress,
    this.sourceWandPtrAddress,
    this.compositeOperator,
    this.clipToSelf,
    this.x,
    this.y,
  );
}

Future<bool> _magickCompositeImage(_MagickCompositeImageParams args) async =>
    _bindings.magickCompositeImage(
      Pointer<Void>.fromAddress(args.wandPtrAddress),
      Pointer<Void>.fromAddress(args.sourceWandPtrAddress),
      args.compositeOperator,
      args.clipToSelf,
      args.x,
      args.y,
    );

class _MagickCompositeImageGravityParams {
  final int wandPtrAddress;
  final int sourceWandPtrAddress;
  final int compositeOperator;
  final int gravityType;

  _MagickCompositeImageGravityParams(
    this.wandPtrAddress,
    this.sourceWandPtrAddress,
    this.compositeOperator,
    this.gravityType,
  );
}

Future<bool> _magickCompositeImageGravity(
        _MagickCompositeImageGravityParams args) async =>
    _bindings.magickCompositeImageGravity(
      Pointer<Void>.fromAddress(args.wandPtrAddress),
      Pointer<Void>.fromAddress(args.sourceWandPtrAddress),
      args.compositeOperator,
      args.gravityType,
    );

class _MagickCompositeLayersParams {
  final int wandPtrAddress;
  final int sourceWandPtrAddress;
  final int compositeOperator;
  final int x;
  final int y;

  _MagickCompositeLayersParams(
    this.wandPtrAddress,
    this.sourceWandPtrAddress,
    this.compositeOperator,
    this.x,
    this.y,
  );
}

Future<bool> _magickCompositeLayers(_MagickCompositeLayersParams args) async =>
    _bindings.magickCompositeLayers(
      Pointer<Void>.fromAddress(args.wandPtrAddress),
      Pointer<Void>.fromAddress(args.sourceWandPtrAddress),
      args.compositeOperator,
      args.x,
      args.y,
    );

class _MagickContrastImageParams {
  final int wandPtrAddress;
  final bool sharpen;

  _MagickContrastImageParams(this.wandPtrAddress, this.sharpen);
}

Future<bool> _magickContrastImage(_MagickContrastImageParams args) async =>
    _bindings.magickContrastImage(
      Pointer<Void>.fromAddress(args.wandPtrAddress),
      args.sharpen,
    );

class _MagickContrastStretchImageParams {
  final int wandPtrAddress;
  final double whitePoint;
  final double blackPoint;

  _MagickContrastStretchImageParams(
    this.wandPtrAddress,
    this.whitePoint,
    this.blackPoint,
  );
}

Future<bool> _magickContrastStretchImage(
        _MagickContrastStretchImageParams args) async =>
    _bindings.magickContrastStretchImage(
      Pointer<Void>.fromAddress(args.wandPtrAddress),
      args.blackPoint,
      args.whitePoint,
    );

class _MagickConvolveImageParams {
  final int wandPtrAddress;
  final KernelInfo kernel;

  _MagickConvolveImageParams(this.wandPtrAddress, this.kernel);
}

Future<bool> _magickConvolveImage(_MagickConvolveImageParams args) async =>
    using(
      (Arena arena) => _bindings.magickConvolveImage(
        Pointer<Void>.fromAddress(args.wandPtrAddress),
        args.kernel._toKernelInfoStructPointer(allocator: arena).cast(),
      ),
    );

class _MagickCropImageParams {
  final int wandPtrAddress;
  final int width;
  final int height;
  final int x;
  final int y;

  _MagickCropImageParams(
    this.wandPtrAddress,
    this.width,
    this.height,
    this.x,
    this.y,
  );
}

Future<bool> _magickCropImage(_MagickCropImageParams args) async => using(
      (Arena arena) => _bindings.magickCropImage(
        Pointer<Void>.fromAddress(args.wandPtrAddress),
        args.width,
        args.height,
        args.x,
        args.y,
      ),
    );

class _MagickCycleColormapImageParams {
  final int wandPtrAddress;
  final int displace;

  _MagickCycleColormapImageParams(this.wandPtrAddress, this.displace);
}

Future<bool> _magickCycleColormapImage(
        _MagickCycleColormapImageParams args) async =>
    _bindings.magickCycleColormapImage(
      Pointer<Void>.fromAddress(args.wandPtrAddress),
      args.displace,
    );

class _MagickConstituteImageParams {
  final int wandPtrAddress;
  final int columns;
  final int rows;
  final String map;
  final StorageType storageType;
  final TypedData pixels;

  _MagickConstituteImageParams(
    this.wandPtrAddress,
    this.columns,
    this.rows,
    this.map,
    this.storageType,
    this.pixels,
  );
}

Future<bool> _magickConstituteImage(_MagickConstituteImageParams args) async =>
    using(
      (Arena arena) {
        if (args.pixels.lengthInBytes == 0) {
          return false;
        }
        final Pointer<Void> pixelsPtr;
        switch (args.storageType) {
          case StorageType.UndefinedPixel:
            return false;
          case StorageType.CharPixel:
            pixelsPtr = (args.pixels as Uint8List)
                .toUnsignedCharArrayPointer(allocator: arena)
                .cast();
            break;
          case StorageType.DoublePixel:
            pixelsPtr = (args.pixels as Float64List)
                .toDoubleArrayPointer(allocator: arena)
                .cast();
            break;
          case StorageType.FloatPixel:
            pixelsPtr = (args.pixels as Float32List)
                .toFloatArrayPointer(allocator: arena)
                .cast();
            break;
          case StorageType.LongPixel:
            pixelsPtr = (args.pixels as Uint32List)
                .toUint32ArrayPointer(allocator: arena)
                .cast();
            break;
          case StorageType.LongLongPixel:
            pixelsPtr = (args.pixels as Uint64List)
                .toUint64ArrayPointer(allocator: arena)
                .cast();
            break;
          case StorageType.QuantumPixel:
            pixelsPtr = (args.pixels as Uint16List)
                .toUint16ArrayPointer(allocator: arena)
                .cast();
            break;
          case StorageType.ShortPixel:
            pixelsPtr = (args.pixels as Uint16List)
                .toUint16ArrayPointer(allocator: arena)
                .cast();
            break;
        }
        return _bindings.magickConstituteImage(
          Pointer<Void>.fromAddress(args.wandPtrAddress),
          args.columns,
          args.rows,
          args.map.toNativeUtf8(allocator: arena).cast(),
          args.storageType.index,
          pixelsPtr,
        );
      },
    );

class _MagickDecipherImageParams {
  final int wandPtrAddress;
  final String passphrase;

  _MagickDecipherImageParams(this.wandPtrAddress, this.passphrase);
}

Future<bool> _magickDecipherImage(_MagickDecipherImageParams args) async =>
    using(
      (Arena arena) => _bindings.magickDecipherImage(
        Pointer<Void>.fromAddress(args.wandPtrAddress),
        args.passphrase.toNativeUtf8(allocator: arena).cast(),
      ),
    );

Future<int> _magickDeconstructImages(int wandPtrAddress) async => _bindings
    .magickDeconstructImages(Pointer<Void>.fromAddress(wandPtrAddress))
    .address;

class _MagickDeskewImageParams {
  final int wandPtrAddress;
  final double threshold;

  _MagickDeskewImageParams(this.wandPtrAddress, this.threshold);
}

Future<bool> _magickDeskewImage(_MagickDeskewImageParams args) async =>
    _bindings.magickDeskewImage(
      Pointer<Void>.fromAddress(args.wandPtrAddress),
      args.threshold,
    );

Future<bool> _magickDespeckleImage(int wandPtrAddress) async =>
    _bindings.magickDespeckleImage(Pointer<Void>.fromAddress(wandPtrAddress));

class _MagickDistortImageParams {
  final int wandPtrAddress;
  final DistortMethod method;
  final Float64List arguments;
  final bool bestFit;

  _MagickDistortImageParams(
      this.wandPtrAddress, this.method, this.arguments, this.bestFit);
}

Future<bool> _magickDistortImage(_MagickDistortImageParams args) async => using(
      (Arena arena) => _bindings.magickDistortImage(
        Pointer<Void>.fromAddress(args.wandPtrAddress),
        args.method.index,
        args.arguments.length,
        args.arguments.toDoubleArrayPointer(allocator: arena),
        args.bestFit,
      ),
    );

class _MagickDrawImageParams {
  final int wandPtrAddress;
  final int drawWandPtrAddress;

  _MagickDrawImageParams(this.wandPtrAddress, this.drawWandPtrAddress);
}

Future<bool> _magickDrawImage(_MagickDrawImageParams args) async =>
    _bindings.magickDrawImage(
      Pointer<Void>.fromAddress(args.wandPtrAddress),
      Pointer<Void>.fromAddress(args.drawWandPtrAddress),
    );

class _MagickEdgeImageParams {
  final int wandPtrAddress;
  final double radius;

  _MagickEdgeImageParams(this.wandPtrAddress, this.radius);
}

Future<bool> _magickEdgeImage(_MagickEdgeImageParams args) async =>
    _bindings.magickEdgeImage(
      Pointer<Void>.fromAddress(args.wandPtrAddress),
      args.radius,
    );

class _MagickEmbossImageParams {
  final int wandPtrAddress;
  final double radius;
  final double sigma;

  _MagickEmbossImageParams(this.wandPtrAddress, this.radius, this.sigma);
}

Future<bool> _magickEmbossImage(_MagickEmbossImageParams args) async =>
    _bindings.magickEmbossImage(
      Pointer<Void>.fromAddress(args.wandPtrAddress),
      args.radius,
      args.sigma,
    );

class _MagickEncipherImageParams {
  final int wandPtrAddress;
  final String passphrase;

  _MagickEncipherImageParams(this.wandPtrAddress, this.passphrase);
}

Future<bool> _magickEncipherImage(_MagickEncipherImageParams args) async =>
    using(
      (Arena arena) => _bindings.magickEncipherImage(
        Pointer<Void>.fromAddress(args.wandPtrAddress),
        args.passphrase.toNativeUtf8(allocator: arena).cast(),
      ),
    );

Future<bool> _magickEnhanceImage(int wandPtrAddress) async =>
    _bindings.magickEnhanceImage(Pointer<Void>.fromAddress(wandPtrAddress));

Future<bool> _magickEqualizeImage(int wandPtrAddress) async =>
    _bindings.magickEqualizeImage(Pointer<Void>.fromAddress(wandPtrAddress));

class _MagickEvaluateImageParams {
  final int wandPtrAddress;
  final MagickEvaluateOperator operator;
  final double value;

  _MagickEvaluateImageParams(this.wandPtrAddress, this.operator, this.value);
}

Future<bool> _magickEvaluateImage(_MagickEvaluateImageParams args) async =>
    _bindings.magickEvaluateImage(
      Pointer<Void>.fromAddress(args.wandPtrAddress),
      args.operator.index,
      args.value,
    );

// TODO: continue adding helper classes here

class _MagickReadImageParams {
  final int wandPtrAddress;
  final String imageFilePath;

  _MagickReadImageParams(this.wandPtrAddress, this.imageFilePath);
}

Future<bool> _magickReadImage(_MagickReadImageParams args) async => using(
      (Arena arena) => _bindings.magickReadImage(
        Pointer<Void>.fromAddress(args.wandPtrAddress),
        args.imageFilePath.toNativeUtf8(allocator: arena).cast(),
      ),
    );

class _MagickWriteImageParams {
  final int wandPtrAddress;
  final String imageFilePath;

  _MagickWriteImageParams(this.wandPtrAddress, this.imageFilePath);
}

Future<bool> _magickWriteImage(_MagickWriteImageParams args) async => using(
      (Arena arena) => _bindings.magickWriteImage(
        Pointer<Void>.fromAddress(args.wandPtrAddress),
        args.imageFilePath.toNativeUtf8(allocator: arena).cast(),
      ),
    );