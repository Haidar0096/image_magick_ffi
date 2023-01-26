part of 'image_magick_ffi.dart';

/// Represents an exception that occurred while using the ImageMagick API.
class MagickGetExceptionResult {
  /// The type of the exception.
  final ExceptionType severity;

  /// The description of the exception.
  final String description;

  const MagickGetExceptionResult(this.severity, this.description);

  @override
  String toString() =>
      'MagickException{severity: $severity, description: $description}';
}

/// Represents a result to a call to `magickGetPage()`.
class MagickGetPageResult {
  final int width;
  final int height;
  final int x;
  final int y;

  const MagickGetPageResult(this.width, this.height, this.x, this.y);

  @override
  String toString() =>
      'MagickGetPageResult{width: $width, height: $height, x: $x, y: $y}';
}

/// Represents a result to a call to `magickGetResolution()`.
class MagickGetResolutionResult {
  final double x;
  final double y;

  const MagickGetResolutionResult(this.x, this.y);

  @override
  String toString() => 'MagickGetResolutionResult{x: $x, y: $y}';
}

/// Represents a result to a call to `magickGetSize()`.
class MagickGetSizeResult {
  final int width;
  final int height;

  const MagickGetSizeResult(this.width, this.height);

  @override
  String toString() => 'MagickGetSizeResult{width: $width, height: $height}';
}

class _MagickAdaptiveBlurImageParams {
  final int wandPtrAddress;
  final double radius;
  final double sigma;

  _MagickAdaptiveBlurImageParams(this.wandPtrAddress, this.radius, this.sigma);
}

Future<bool> _magickAdaptiveBlurImage(
        _MagickAdaptiveBlurImageParams params) async =>
    _magickWandBindings.MagickAdaptiveBlurImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      params.radius,
      params.sigma,
    ) ==
    1;

class _MagickAdaptiveResizeImageParams {
  final int wandPtrAddress;
  final int columns;
  final int rows;

  _MagickAdaptiveResizeImageParams(
      this.wandPtrAddress, this.columns, this.rows);
}

Future<bool> _magickAdaptiveResizeImage(
        _MagickAdaptiveResizeImageParams params) async =>
    _magickWandBindings.MagickAdaptiveResizeImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      params.columns,
      params.rows,
    ) ==
    1;

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
    _magickWandBindings.MagickAdaptiveSharpenImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      params.radius,
      params.sigma,
    ) ==
    1;

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
    _magickWandBindings.MagickAdaptiveThresholdImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      params.width,
      params.height,
      params.bias,
    ) ==
    1;

class _MagickAddImageParams {
  final int wandPtrAddress;
  final int otherWandPtrAddress;

  _MagickAddImageParams(this.wandPtrAddress, this.otherWandPtrAddress);
}

Future<bool> _magickAddImage(_MagickAddImageParams params) async =>
    _magickWandBindings.MagickAddImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      Pointer<mwbg.MagickWand>.fromAddress(params.otherWandPtrAddress),
    ) ==
    1;

class _MagickAddNoiseImageParams {
  final int wandPtrAddress;
  final int noiseTypeIndex;
  final double attenuate;

  _MagickAddNoiseImageParams(
      this.wandPtrAddress, this.noiseTypeIndex, this.attenuate);
}

Future<bool> _magickAddNoiseImage(_MagickAddNoiseImageParams params) async =>
    _magickWandBindings.MagickAddNoiseImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      params.noiseTypeIndex,
      params.attenuate,
    ) ==
    1;

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
    _magickWandBindings.MagickAffineTransformImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      Pointer<mwbg.DrawingWand>.fromAddress(params.drawingWandPtrAddress),
    ) ==
    1;

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
      (Arena arena) => _magickWandBindings.MagickAnnotateImage(
        Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
        Pointer<mwbg.DrawingWand>.fromAddress(params.drawingWandPtrAddress),
        params.x,
        params.y,
        params.angle,
        params.text.toNativeUtf8(allocator: arena).cast(),
      ),
    ) ==
    1;

class _MagickAppendImagesParams {
  final int wandPtrAddress;
  final bool stack;

  _MagickAppendImagesParams(this.wandPtrAddress, this.stack);
}

Future<int> _magickAppendImages(_MagickAppendImagesParams params) async =>
    _magickWandBindings.MagickAppendImages(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      params.stack ? 1 : 0,
    ).address;

Future<bool> _magickAutoGammaImage(int wandPtrAddress) async =>
    _magickWandBindings.MagickAutoGammaImage(
        Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress)) ==
    1;

Future<bool> _magickAutoLevelImage(int wandPtrAddress) async =>
    _magickWandBindings.MagickAutoLevelImage(
        Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress)) ==
    1;

Future<bool> _magickAutoOrientImage(int wandPtrAddress) async =>
    _magickWandBindings.MagickAutoOrientImage(
        Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress)) ==
    1;

class _MagickAutoThresholdImageParams {
  final int wandPtrAddress;
  final int thresholdMethodIndex;

  _MagickAutoThresholdImageParams(
      this.wandPtrAddress, this.thresholdMethodIndex);
}

Future<bool> _magickAutoThresholdImage(
        _MagickAutoThresholdImageParams params) async =>
    _magickWandBindings.MagickAutoThresholdImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      params.thresholdMethodIndex,
    ) ==
    1;

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
    _magickWandBindings.MagickBilateralBlurImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      params.radius,
      params.sigma,
      params.intensitySigma,
      params.spatialSigma,
    ) ==
    1;

class _MagickBlackThresholdImageParams {
  final int wandPtrAddress;
  final int thresholdWandPtrAddress;

  _MagickBlackThresholdImageParams(
      this.wandPtrAddress, this.thresholdWandPtrAddress);
}

Future<bool> _magickBlackThresholdImage(
        _MagickBlackThresholdImageParams params) async =>
    _magickWandBindings.MagickBlackThresholdImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      Pointer<mwbg.PixelWand>.fromAddress(params.thresholdWandPtrAddress),
    ) ==
    1;

class _MagickBlueShiftImageParams {
  final int wandPtrAddress;
  final double factor;

  _MagickBlueShiftImageParams(this.wandPtrAddress, this.factor);
}

Future<bool> _magickBlueShiftImage(_MagickBlueShiftImageParams params) async =>
    _magickWandBindings.MagickBlueShiftImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      params.factor,
    ) ==
    1;

class _MagickBlurImageParams {
  final int wandPtrAddress;
  final double radius;
  final double sigma;

  _MagickBlurImageParams(this.wandPtrAddress, this.radius, this.sigma);
}

Future<bool> _magickBlurImage(_MagickBlurImageParams params) async =>
    _magickWandBindings.MagickBlurImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      params.radius,
      params.sigma,
    ) ==
    1;

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
    _magickWandBindings.MagickBorderImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      Pointer<mwbg.PixelWand>.fromAddress(params.borderWandPtrAddress),
      params.width,
      params.height,
      params.composeIndex,
    ) ==
    1;

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
    _magickWandBindings.MagickBrightnessContrastImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      params.brightness,
      params.contrast,
    ) ==
    1;

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
    _magickWandBindings.MagickCannyEdgeImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      params.radius,
      params.sigma,
      params.lowerPercent,
      params.upperPercent,
    ) ==
    1;

class _MagickChannelFxImageParams {
  final int wandPtrAddress;
  final String expression;

  _MagickChannelFxImageParams(this.wandPtrAddress, this.expression);
}

Future<int> _magickChannelFxImage(_MagickChannelFxImageParams params) async =>
    using(
      (Arena arena) => _magickWandBindings.MagickChannelFxImage(
        Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
        params.expression.toNativeUtf8(allocator: arena).cast(),
      ).address,
    );

class _MagickCharcoalImageParams {
  final int wandPtrAddress;
  final double radius;
  final double sigma;

  _MagickCharcoalImageParams(this.wandPtrAddress, this.radius, this.sigma);
}

Future<bool> _magickCharcoalImage(_MagickCharcoalImageParams params) async =>
    _magickWandBindings.MagickCharcoalImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      params.radius,
      params.sigma,
    ) ==
    1;

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
    _magickWandBindings.MagickChopImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      params.width,
      params.height,
      params.x,
      params.y,
    ) ==
    1;

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
    _magickWandBindings.MagickCLAHEImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      params.width,
      params.height,
      params.numberBins,
      params.clipLimit,
    ) ==
    1;

Future<bool> _magickClampImage(int wandPtrAddress) async =>
    _magickWandBindings.MagickClampImage(
      Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
    ) ==
    1;

Future<bool> _magickClipImage(int wandPtrAddress) async =>
    _magickWandBindings.MagickClipImage(
      Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
    ) ==
    1;

class _MagickClipImagePathParams {
  final int wandPtrAddress;
  final String pathname;
  final bool inside;

  _MagickClipImagePathParams(this.wandPtrAddress, this.pathname, this.inside);
}

Future<bool> _magickClipImagePath(_MagickClipImagePathParams params) async =>
    using(
      (Arena arena) => _magickWandBindings.MagickClipImagePath(
        Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
        params.pathname.toNativeUtf8(allocator: arena).cast(),
        params.inside ? 1 : 0,
      ),
    ) ==
    1;

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
    _magickWandBindings.MagickClutImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      Pointer<mwbg.MagickWand>.fromAddress(params.clutWandPtrAddress),
      params.interpolateMethod,
    ) ==
    1;

Future<int> _magickCoalesceImages(int wandPtrAddress) async =>
    _magickWandBindings.MagickCoalesceImages(
            Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress))
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
      (Arena arena) => _magickWandBindings.MagickColorDecisionListImage(
        Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
        params.colorCorrectionCollection.toNativeUtf8(allocator: arena).cast(),
      ),
    ) ==
    1;

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
    _magickWandBindings.MagickColorizeImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      Pointer<mwbg.PixelWand>.fromAddress(params.colorizePixelWandPtrAddress),
      Pointer<mwbg.PixelWand>.fromAddress(params.blendPixelWandPtrAddress),
    ) ==
    1;

class _MagickColorMatrixImageParams {
  final int wandPtrAddress;
  final KernelInfo colorMatrix;

  _MagickColorMatrixImageParams(this.wandPtrAddress, this.colorMatrix);
}

Future<bool> _magickColorMatrixImage(
        _MagickColorMatrixImageParams params) async =>
    using(
      (Arena arena) => _magickWandBindings.MagickColorMatrixImage(
        Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
        params.colorMatrix._toKernelInfoStructPointer(allocator: arena).cast(),
      ),
    ) ==
    1;

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
    _magickWandBindings.MagickColorThresholdImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      Pointer<mwbg.PixelWand>.fromAddress(params.startColorPixelWandPtrAddress),
      Pointer<mwbg.PixelWand>.fromAddress(params.endColorPixelWandPtrAddress),
    ) ==
    1;

class _MagickCombineImagesParams {
  final int wandPtrAddress;
  final int colorSpaceType;

  _MagickCombineImagesParams(this.wandPtrAddress, this.colorSpaceType);
}

Future<int> _magickCombineImages(_MagickCombineImagesParams params) async =>
    _magickWandBindings.MagickCombineImages(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      params.colorSpaceType,
    ).address;

class _MagickCommentImageParams {
  final int wandPtrAddress;
  final String comment;

  _MagickCommentImageParams(this.wandPtrAddress, this.comment);
}

Future<bool> _magickCommentImage(_MagickCommentImageParams args) async =>
    using(
      (Arena arena) => _magickWandBindings.MagickCommentImage(
        Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
        args.comment.toNativeUtf8(allocator: arena).cast(),
      ),
    ) ==
    1;

class _MagickCompareImagesLayersParams {
  final int wandPtrAddress;
  final int compareLayerMethod;

  _MagickCompareImagesLayersParams(
      this.wandPtrAddress, this.compareLayerMethod);
}

Future<int> _magickCompareImagesLayers(
        _MagickCompareImagesLayersParams args) async =>
    _magickWandBindings.MagickCompareImagesLayers(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.compareLayerMethod,
    ).address;

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
      (Arena arena) => _magickWandBindings.MagickCompareImages(
        Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
        Pointer<mwbg.MagickWand>.fromAddress(args.referenceWandPtrAddress),
        args.metricType,
        args.distortion.toDoubleArrayPointer(allocator: arena),
      ).address,
    );

class _MagickComplexImagesParams {
  final int wandPtrAddress;
  final int complexOperator;

  _MagickComplexImagesParams(this.wandPtrAddress, this.complexOperator);
}

Future<int> _magickComplexImages(_MagickComplexImagesParams args) async =>
    _magickWandBindings.MagickComplexImages(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.complexOperator,
    ).address;

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
    _magickWandBindings.MagickCompositeImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      Pointer<mwbg.MagickWand>.fromAddress(args.sourceWandPtrAddress),
      args.compositeOperator,
      args.clipToSelf ? 1 : 0,
      args.x,
      args.y,
    ) ==
    1;

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
    _magickWandBindings.MagickCompositeImageGravity(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      Pointer<mwbg.MagickWand>.fromAddress(args.sourceWandPtrAddress),
      args.compositeOperator,
      args.gravityType,
    ) ==
    1;

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
    _magickWandBindings.MagickCompositeLayers(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      Pointer<mwbg.MagickWand>.fromAddress(args.sourceWandPtrAddress),
      args.compositeOperator,
      args.x,
      args.y,
    ) ==
    1;

class _MagickContrastImageParams {
  final int wandPtrAddress;
  final bool sharpen;

  _MagickContrastImageParams(this.wandPtrAddress, this.sharpen);
}

Future<bool> _magickContrastImage(_MagickContrastImageParams args) async =>
    _magickWandBindings.MagickContrastImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.sharpen ? 1 : 0,
    ) ==
    1;

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
    _magickWandBindings.MagickContrastStretchImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.blackPoint,
      args.whitePoint,
    ) ==
    1;

class _MagickConvolveImageParams {
  final int wandPtrAddress;
  final KernelInfo kernel;

  _MagickConvolveImageParams(this.wandPtrAddress, this.kernel);
}

Future<bool> _magickConvolveImage(_MagickConvolveImageParams args) async =>
    using(
      (Arena arena) => _magickWandBindings.MagickConvolveImage(
        Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
        args.kernel._toKernelInfoStructPointer(allocator: arena).cast(),
      ),
    ) ==
    1;

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

Future<bool> _magickCropImage(_MagickCropImageParams args) async =>
    using(
      (Arena arena) => _magickWandBindings.MagickCropImage(
        Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
        args.width,
        args.height,
        args.x,
        args.y,
      ),
    ) ==
    1;

class _MagickCycleColormapImageParams {
  final int wandPtrAddress;
  final int displace;

  _MagickCycleColormapImageParams(this.wandPtrAddress, this.displace);
}

Future<bool> _magickCycleColormapImage(
        _MagickCycleColormapImageParams args) async =>
    _magickWandBindings.MagickCycleColormapImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.displace,
    ) ==
    1;

class _MagickConstituteImageParams {
  final int wandPtrAddress;
  final int columns;
  final int rows;
  final String map;
  final _StorageType storageType;
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
          case _StorageType.UndefinedPixel:
            return false;
          case _StorageType.CharPixel:
            pixelsPtr = (args.pixels as Uint8List)
                .toUnsignedCharArrayPointer(allocator: arena)
                .cast();
            break;
          case _StorageType.DoublePixel:
            pixelsPtr = (args.pixels as Float64List)
                .toDoubleArrayPointer(allocator: arena)
                .cast();
            break;
          case _StorageType.FloatPixel:
            pixelsPtr = (args.pixels as Float32List)
                .toFloatArrayPointer(allocator: arena)
                .cast();
            break;
          case _StorageType.LongPixel:
            pixelsPtr = (args.pixels as Uint32List)
                .toUint32ArrayPointer(allocator: arena)
                .cast();
            break;
          case _StorageType.LongLongPixel:
            pixelsPtr = (args.pixels as Uint64List)
                .toUint64ArrayPointer(allocator: arena)
                .cast();
            break;
          case _StorageType.QuantumPixel:
            // TODO: support this when it becomes clear how to map the `Quantum`
            // C type to dart
            return false;
          case _StorageType.ShortPixel:
            pixelsPtr = (args.pixels as Uint16List)
                .toUint16ArrayPointer(allocator: arena)
                .cast();
            break;
        }
        return _magickWandBindings.MagickConstituteImage(
              Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
              args.columns,
              args.rows,
              args.map.toNativeUtf8(allocator: arena).cast(),
              args.storageType.index,
              pixelsPtr,
            ) ==
            1;
      },
    );

class _MagickDecipherImageParams {
  final int wandPtrAddress;
  final String passphrase;

  _MagickDecipherImageParams(this.wandPtrAddress, this.passphrase);
}

Future<bool> _magickDecipherImage(_MagickDecipherImageParams args) async =>
    using(
      (Arena arena) => _magickWandBindings.MagickDecipherImage(
        Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
        args.passphrase.toNativeUtf8(allocator: arena).cast(),
      ),
    ) ==
    1;

Future<int> _magickDeconstructImages(int wandPtrAddress) async =>
    _magickWandBindings.MagickDeconstructImages(
            Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress))
        .address;

class _MagickDeskewImageParams {
  final int wandPtrAddress;
  final double threshold;

  _MagickDeskewImageParams(this.wandPtrAddress, this.threshold);
}

Future<bool> _magickDeskewImage(_MagickDeskewImageParams args) async =>
    _magickWandBindings.MagickDeskewImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.threshold,
    ) ==
    1;

Future<bool> _magickDespeckleImage(int wandPtrAddress) async =>
    _magickWandBindings.MagickDespeckleImage(
        Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress)) ==
    1;

class _MagickDistortImageParams {
  final int wandPtrAddress;
  final DistortMethod method;
  final Float64List arguments;
  final bool bestFit;

  _MagickDistortImageParams(
      this.wandPtrAddress, this.method, this.arguments, this.bestFit);
}

Future<bool> _magickDistortImage(_MagickDistortImageParams args) async =>
    using(
      (Arena arena) => _magickWandBindings.MagickDistortImage(
        Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
        args.method.index,
        args.arguments.length,
        args.arguments.toDoubleArrayPointer(allocator: arena),
        args.bestFit ? 1 : 0,
      ),
    ) ==
    1;

class _MagickDrawImageParams {
  final int wandPtrAddress;
  final int drawWandPtrAddress;

  _MagickDrawImageParams(this.wandPtrAddress, this.drawWandPtrAddress);
}

Future<bool> _magickDrawImage(_MagickDrawImageParams args) async =>
    _magickWandBindings.MagickDrawImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      Pointer<mwbg.DrawingWand>.fromAddress(args.drawWandPtrAddress),
    ) ==
    1;

class _MagickEdgeImageParams {
  final int wandPtrAddress;
  final double radius;

  _MagickEdgeImageParams(this.wandPtrAddress, this.radius);
}

Future<bool> _magickEdgeImage(_MagickEdgeImageParams args) async =>
    _magickWandBindings.MagickEdgeImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.radius,
    ) ==
    1;

class _MagickEmbossImageParams {
  final int wandPtrAddress;
  final double radius;
  final double sigma;

  _MagickEmbossImageParams(this.wandPtrAddress, this.radius, this.sigma);
}

Future<bool> _magickEmbossImage(_MagickEmbossImageParams args) async =>
    _magickWandBindings.MagickEmbossImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.radius,
      args.sigma,
    ) ==
    1;

class _MagickEncipherImageParams {
  final int wandPtrAddress;
  final String passphrase;

  _MagickEncipherImageParams(this.wandPtrAddress, this.passphrase);
}

Future<bool> _magickEncipherImage(_MagickEncipherImageParams args) async =>
    using(
      (Arena arena) => _magickWandBindings.MagickEncipherImage(
        Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
        args.passphrase.toNativeUtf8(allocator: arena).cast(),
      ),
    ) ==
    1;

Future<bool> _magickEnhanceImage(int wandPtrAddress) async =>
    _magickWandBindings.MagickEnhanceImage(
      Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
    ) ==
    1;

Future<bool> _magickEqualizeImage(int wandPtrAddress) async =>
    _magickWandBindings.MagickEqualizeImage(
      Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
    ) ==
    1;

class _MagickEvaluateImageParams {
  final int wandPtrAddress;
  final MagickEvaluateOperator operator;
  final double value;

  _MagickEvaluateImageParams(this.wandPtrAddress, this.operator, this.value);
}

Future<bool> _magickEvaluateImage(_MagickEvaluateImageParams args) async =>
    _magickWandBindings.MagickEvaluateImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.operator.index,
      args.value,
    ) ==
    1;

class _MagickExportImagePixelsParams {
  final int wandPtrAddress;
  final int x;
  final int y;
  final int columns;
  final int rows;
  final String map;

  _MagickExportImagePixelsParams(
    this.wandPtrAddress,
    this.x,
    this.y,
    this.columns,
    this.rows,
    this.map,
  );
}

Future<Uint8List?> _magickExportImageCharPixels(
        _MagickExportImagePixelsParams args) async =>
    using(
      (Arena arena) {
        int pixelsArraySize =
            args.columns * args.rows * args.map.length * sizeOf<UnsignedChar>();
        final Pointer<UnsignedChar> pixelsPtr = arena(pixelsArraySize);
        bool result = _magickWandBindings.MagickExportImagePixels(
              Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
              args.x,
              args.y,
              args.columns,
              args.rows,
              args.map.toNativeUtf8(allocator: arena).cast(),
              _StorageType.CharPixel.index,
              pixelsPtr.cast(),
            ) ==
            1;
        if (result) {
          return pixelsPtr.cast<UnsignedChar>().toUint8List(pixelsArraySize);
        }
        return null;
      },
    );

Future<Float64List?> _magickExportImageDoublePixels(
        _MagickExportImagePixelsParams args) async =>
    using(
      (Arena arena) {
        int pixelsArraySize =
            args.columns * args.rows * args.map.length * sizeOf<Double>();
        final Pointer<Double> pixelsPtr = arena(pixelsArraySize);
        bool result = _magickWandBindings.MagickExportImagePixels(
              Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
              args.x,
              args.y,
              args.columns,
              args.rows,
              args.map.toNativeUtf8(allocator: arena).cast(),
              _StorageType.DoublePixel.index,
              pixelsPtr.cast(),
            ) ==
            1;
        if (result) {
          // TODO: see if we can return the list using `asTypedData` instead
          // of copying, while still freeing the pointer automatically when the
          // list is garbage collected.
          return pixelsPtr.cast<Double>().toFloat64List(pixelsArraySize);
        }
        return null;
      },
    );

Future<Float32List?> _magickExportImageFloatPixels(
        _MagickExportImagePixelsParams args) async =>
    using(
      (Arena arena) {
        int pixelsArraySize =
            args.columns * args.rows * args.map.length * sizeOf<Float>();
        final Pointer<Float> pixelsPtr = arena(pixelsArraySize);
        bool result = _magickWandBindings.MagickExportImagePixels(
              Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
              args.x,
              args.y,
              args.columns,
              args.rows,
              args.map.toNativeUtf8(allocator: arena).cast(),
              _StorageType.FloatPixel.index,
              pixelsPtr.cast(),
            ) ==
            1;
        if (result) {
          // TODO: see if we can return the list using `asTypedData` instead
          // of copying, while still freeing the pointer automatically when the
          // list is garbage collected.
          return pixelsPtr.cast<Float>().toFloat32List(pixelsArraySize);
        }
        return null;
      },
    );

Future<Uint32List?> _magickExportImageLongPixels(
        _MagickExportImagePixelsParams args) async =>
    using(
      (Arena arena) {
        int pixelsArraySize =
            args.columns * args.rows * args.map.length * sizeOf<Uint32>();
        final Pointer<Uint32> pixelsPtr = arena(pixelsArraySize);
        bool result = _magickWandBindings.MagickExportImagePixels(
              Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
              args.x,
              args.y,
              args.columns,
              args.rows,
              args.map.toNativeUtf8(allocator: arena).cast(),
              _StorageType.LongPixel.index,
              pixelsPtr.cast(),
            ) ==
            1;
        if (result) {
          // TODO: see if we can return the list using `asTypedData` instead
          // of copying, while still freeing the pointer automatically when the
          // list is garbage collected.
          return pixelsPtr.cast<Uint32>().toUint32List(pixelsArraySize);
        }
        return null;
      },
    );

Future<Uint64List?> _magickExportImageLongLongPixels(
        _MagickExportImagePixelsParams args) async =>
    using(
      (Arena arena) {
        int pixelsArraySize =
            args.columns * args.rows * args.map.length * sizeOf<Uint64>();
        final Pointer<Uint64> pixelsPtr = arena(pixelsArraySize);
        bool result = _magickWandBindings.MagickExportImagePixels(
              Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
              args.x,
              args.y,
              args.columns,
              args.rows,
              args.map.toNativeUtf8(allocator: arena).cast(),
              _StorageType.LongLongPixel.index,
              pixelsPtr.cast(),
            ) ==
            1;
        if (result) {
          // TODO: see if we can return the list using `asTypedData` instead
          // of copying, while still freeing the pointer automatically when the
          // list is garbage collected.
          return pixelsPtr.cast<Uint64>().toUint64List(pixelsArraySize);
        }
        return null;
      },
    );

// TODO: support _magickExportImageQuantumPixels when it becomes clear how to
// map the `Quantum` type to Dart.

Future<Uint16List?> _magickExportImageShortPixels(
        _MagickExportImagePixelsParams args) async =>
    using(
      (Arena arena) {
        int pixelsArraySize =
            args.columns * args.rows * args.map.length * sizeOf<Uint16>();
        final Pointer<Uint16> pixelsPtr = arena(pixelsArraySize);
        bool result = _magickWandBindings.MagickExportImagePixels(
              Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
              args.x,
              args.y,
              args.columns,
              args.rows,
              args.map.toNativeUtf8(allocator: arena).cast(),
              _StorageType.ShortPixel.index,
              pixelsPtr.cast(),
            ) ==
            1;
        if (result) {
          // TODO: see if we can return the list using `asTypedData` instead
          // of copying, while still freeing the pointer automatically when the
          // list is garbage collected.
          return pixelsPtr.cast<Uint16>().toUint16List(pixelsArraySize);
        }
        return null;
      },
    );

class _MagickExtentImageParams {
  final int wandPtrAddress;
  final int width;
  final int height;
  final int x;
  final int y;

  _MagickExtentImageParams(
    this.wandPtrAddress,
    this.width,
    this.height,
    this.x,
    this.y,
  );
}

Future<bool> _magickExtentImage(_MagickExtentImageParams args) async =>
    _magickWandBindings.MagickExtentImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.width,
      args.height,
      args.x,
      args.y,
    ) ==
    1;

Future<bool> _magickFlipImage(int wandPtrAddress) async =>
    _magickWandBindings.MagickFlipImage(
      Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
    ) ==
    1;

class _MagickFloodfillPaintImageParams {
  final int wandPtrAddress;
  final int fillPixelWandAddress;
  final double fuzz;
  final int bordercolorPixelWandAddress;
  final int x;
  final int y;
  final bool invert;

  _MagickFloodfillPaintImageParams(
    this.wandPtrAddress,
    this.fillPixelWandAddress,
    this.fuzz,
    this.bordercolorPixelWandAddress,
    this.x,
    this.y,
    this.invert,
  );
}

Future<bool> _magickFloodfillPaintImage(
        _MagickFloodfillPaintImageParams args) async =>
    _magickWandBindings.MagickFloodfillPaintImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      Pointer<mwbg.PixelWand>.fromAddress(args.fillPixelWandAddress),
      args.fuzz,
      Pointer<mwbg.PixelWand>.fromAddress(args.bordercolorPixelWandAddress),
      args.x,
      args.y,
      args.invert ? 1 : 0,
    ) ==
    1;

Future<bool> _magickFlopImage(int wandPtrAddress) async =>
    _magickWandBindings.MagickFlopImage(
      Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
    ) ==
    1;

class _MagickFrameImageParams {
  final int wandPtrAddress;
  final int matteColorPixelWandAddress;
  final int width;
  final int height;
  final int innerBevel;
  final int outerBevel;
  final CompositeOperator compose;

  _MagickFrameImageParams(
    this.wandPtrAddress,
    this.matteColorPixelWandAddress,
    this.width,
    this.height,
    this.innerBevel,
    this.outerBevel,
    this.compose,
  );
}

Future<bool> _magickFrameImage(_MagickFrameImageParams args) async =>
    _magickWandBindings.MagickFrameImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      Pointer<mwbg.PixelWand>.fromAddress(args.matteColorPixelWandAddress),
      args.width,
      args.height,
      args.innerBevel,
      args.outerBevel,
      args.compose.index,
    ) ==
    1;

class _MagickFunctionImageParams {
  final int wandPtrAddress;
  final MagickFunctionType function;
  final Float64List arguments;

  _MagickFunctionImageParams(
    this.wandPtrAddress,
    this.function,
    this.arguments,
  );
}

Future<bool> _magickFunctionImage(_MagickFunctionImageParams args) async =>
    using(
      (Arena arena) {
        final Pointer<Double> argumentsPtr =
            args.arguments.toDoubleArrayPointer(allocator: arena);
        return _magickWandBindings.MagickFunctionImage(
          Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
          args.function.index,
          args.arguments.length,
          argumentsPtr,
        );
      },
    ) ==
    1;

class _MagickFxImageParams {
  final int wandPtrAddress;
  final String expression;

  _MagickFxImageParams(
    this.wandPtrAddress,
    this.expression,
  );
}

Future<int> _magickFxImage(_MagickFxImageParams args) async => using(
      (Arena arena) => _magickWandBindings.MagickFxImage(
        Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
        args.expression.toNativeUtf8(allocator: arena).cast(),
      ).address,
    );

class _MagickGammaImageParams {
  final int wandPtrAddress;
  final double gamma;

  _MagickGammaImageParams(this.wandPtrAddress, this.gamma);
}

Future<bool> _magickGammaImage(_MagickGammaImageParams args) async =>
    _magickWandBindings.MagickGammaImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.gamma,
    ) ==
    1;

class _MagickGaussianBlurImageParams {
  final int wandPtrAddress;
  final double radius;
  final double sigma;

  _MagickGaussianBlurImageParams(this.wandPtrAddress, this.radius, this.sigma);
}

Future<bool> _magickGaussianBlurImage(
        _MagickGaussianBlurImageParams args) async =>
    _magickWandBindings.MagickGaussianBlurImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.radius,
      args.sigma,
    ) ==
    1;

Future<int> _magickGetImage(int wandPtrAddress) async =>
    _magickWandBindings.MagickGetImage(
            Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress))
        .address;

Future<bool> _magickGetImageAlphaChannel(int wandPtrAddress) async =>
    _magickWandBindings.MagickGetImageAlphaChannel(
      Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
    ) ==
    1;

class _MagickGetImageMaskParams {
  final int wandPtrAddress;
  final PixelMask type;

  _MagickGetImageMaskParams(this.wandPtrAddress, this.type);
}

Future<int> _magickGetImageMask(_MagickGetImageMaskParams args) async =>
    _magickWandBindings.MagickGetImageMask(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.type.value,
    ).address;

class _MagickGetImageBackgroundColorParams {
  final int wandPtrAddress;
  final int pixelWandPtrAddress;

  _MagickGetImageBackgroundColorParams(
      this.wandPtrAddress, this.pixelWandPtrAddress);
}

Future<bool> _magickGetImageBackgroundColor(
        _MagickGetImageBackgroundColorParams args) async =>
    _magickWandBindings.MagickGetImageBackgroundColor(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      Pointer<mwbg.PixelWand>.fromAddress(args.pixelWandPtrAddress),
    ) ==
    1;

Future<Uint8List?> _magickGetImageBlob(int wandPtrAddress) async => using(
      (Arena arena) async {
        final Pointer<Size> lengthPtr = arena();
        final Pointer<UnsignedChar> blobPtr =
            _magickWandBindings.MagickGetImageBlob(
          Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
          lengthPtr,
        );
        final Uint8List? result =
            Pointer<UnsignedChar>.fromAddress(blobPtr.address)
                .toUint8List(lengthPtr.value);
        _magickRelinquishMemory(blobPtr.cast());
        return result;
      },
    );

Future<Uint8List?> _magickGetImagesBlob(int wandPtrAddress) async => using(
      (Arena arena) async {
        final Pointer<Size> lengthPtr = arena();
        final Pointer<UnsignedChar> blobPtr =
            _magickWandBindings.MagickGetImagesBlob(
          Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
          lengthPtr,
        );
        final Uint8List? result =
            Pointer<UnsignedChar>.fromAddress(blobPtr.address)
                .toUint8List(lengthPtr.value);
        _magickRelinquishMemory(blobPtr.cast());
        return result;
      },
    );

class MagickGetImageBluePrimaryResult {
  /// The chromaticity blue primary x-point
  final double x;

  /// The chromaticity blue primary y-point
  final double y;

  /// The chromaticity blue primary z-point
  final double z;

  const MagickGetImageBluePrimaryResult(this.x, this.y, this.z);

  @override
  String toString() => 'MagickGetImageBluePrimaryResult{x: $x, y: $y, z: $z}';
}

Future<MagickGetImageBluePrimaryResult?> _magickGetImageBluePrimary(
        int wandPtrAddress) async =>
    using(
      (Arena arena) {
        final Pointer<Double> xPtr = arena();
        final Pointer<Double> yPtr = arena();
        final Pointer<Double> zPtr = arena();
        bool result = _magickWandBindings.MagickGetImageBluePrimary(
              Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
              xPtr,
              yPtr,
              zPtr,
            ) ==
            1;
        if (!result) {
          return null;
        }
        return MagickGetImageBluePrimaryResult(
          xPtr.value,
          yPtr.value,
          zPtr.value,
        );
      },
    );

class _MagickGetImageBorderColorParams {
  final int wandPtrAddress;
  final int pixelWandPtrAddress;

  _MagickGetImageBorderColorParams(
    this.wandPtrAddress,
    this.pixelWandPtrAddress,
  );
}

Future<bool> _magickGetImageBorderColor(
        _MagickGetImageBorderColorParams args) async =>
    _magickWandBindings.MagickGetImageBorderColor(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      Pointer<mwbg.PixelWand>.fromAddress(args.pixelWandPtrAddress),
    ) ==
    1;

class _MagickGetImageFeaturesParams {
  final int wandPtrAddress;
  final int distance;

  _MagickGetImageFeaturesParams(this.wandPtrAddress, this.distance);
}

Future<ChannelFeatures?> _magickGetImageFeatures(
    _MagickGetImageFeaturesParams args) async {
  final Pointer<mwbg.ChannelFeatures> featuresPtr =
      _magickWandBindings.MagickGetImageFeatures(
    Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
    args.distance,
  ).cast();
  ChannelFeatures? result =
      ChannelFeatures._fromChannelFeaturesStructPointer(featuresPtr);
  _magickRelinquishMemory(featuresPtr.cast());
  return result;
}

/// Represents the result of a call to [magickGetImageKurtosis].
class MagickGetImageKurtosisResult {
  /// The kurtosis of the corresponding image channel.
  final double kurtosis;

  /// The skewness of the corresponding image channel.
  final double skewness;

  const MagickGetImageKurtosisResult(this.kurtosis, this.skewness);

  @override
  String toString() =>
      'MagickGetImageKurtosisResult{kurtosis: $kurtosis, skewness: $skewness}';
}

Future<MagickGetImageKurtosisResult?> _magickGetImageKurtosis(
        int wandPtrAddress) async =>
    using(
      (Arena arena) {
        final Pointer<Double> kurtosisPtr = arena();
        final Pointer<Double> skewnessPtr = arena();
        bool result = _magickWandBindings.MagickGetImageKurtosis(
              Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
              kurtosisPtr,
              skewnessPtr,
            ) ==
            1;
        if (!result) {
          return null;
        }
        return MagickGetImageKurtosisResult(
          kurtosisPtr.value,
          skewnessPtr.value,
        );
      },
    );

/// Represents the result of a call to [magickGetImageMean].
class MagickGetImageMeanResult {
  /// The mean of the image.
  final double mean;

  /// The standard deviation of the image.
  final double standardDeviation;

  const MagickGetImageMeanResult(this.mean, this.standardDeviation);

  @override
  String toString() =>
      'MagickGetMeanResult{mean: $mean, standardDeviation: $standardDeviation}';
}

Future<MagickGetImageMeanResult?> _magickGetImageMean(
        int wandPtrAddress) async =>
    using(
      (Arena arena) {
        final Pointer<Double> meanPtr = arena();
        final Pointer<Double> standardDeviationPtr = arena();
        bool result = _magickWandBindings.MagickGetImageMean(
              Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
              meanPtr,
              standardDeviationPtr,
            ) ==
            1;
        if (!result) {
          return null;
        }
        return MagickGetImageMeanResult(
          meanPtr.value,
          standardDeviationPtr.value,
        );
      },
    );

/// Represents the result of a call to [magickGetImageRange].
class MagickGetImageRangeResult {
  /// The minimum pixel value for the specified channel(s).
  final double minima;

  /// The maximum pixel value for the specified channel(s).
  final double maxima;

  const MagickGetImageRangeResult(this.minima, this.maxima);

  @override
  String toString() =>
      'MagickGetImageRangeResult{minima: $minima, maxima: $maxima}';
}

Future<MagickGetImageRangeResult?> _magickGetImageRange(
        int wandPtrAddress) async =>
    using(
      (Arena arena) {
        final Pointer<Double> minimaPtr = arena();
        final Pointer<Double> maximaPtr = arena();
        bool result = _magickWandBindings.MagickGetImageRange(
              Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
              minimaPtr,
              maximaPtr,
            ) ==
            1;
        if (!result) {
          return null;
        }
        return MagickGetImageRangeResult(
          minimaPtr.value,
          maximaPtr.value,
        );
      },
    );

Future<ChannelStatistics?> _magickGetImageStatistics(int wandPtrAddress) async {
  final Pointer<mwbg.ChannelStatistics> statisticsPtr =
      _magickWandBindings.MagickGetImageStatistics(
    Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
  ).cast();
  ChannelStatistics? result =
      ChannelStatistics._fromChannelStatisticsStructPointer(statisticsPtr);
  _magickRelinquishMemory(statisticsPtr.cast());
  return result;
}

Future<int> _magickGetImageColors(int wandPtrAddress) async =>
    _magickWandBindings.MagickGetImageColors(
      Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
    );

// TODO: continue adding helper classes here

class _MagickReadImageParams {
  final int wandPtrAddress;
  final String imageFilePath;

  _MagickReadImageParams(this.wandPtrAddress, this.imageFilePath);
}

Future<bool> _magickReadImage(_MagickReadImageParams args) async =>
    using(
      (Arena arena) => _magickWandBindings.MagickReadImage(
        Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
        args.imageFilePath.toNativeUtf8(allocator: arena).cast(),
      ),
    ) ==
    1;

class _MagickWriteImageParams {
  final int wandPtrAddress;
  final String imageFilePath;

  _MagickWriteImageParams(this.wandPtrAddress, this.imageFilePath);
}

Future<bool> _magickWriteImage(_MagickWriteImageParams args) async =>
    using(
      (Arena arena) => _magickWandBindings.MagickWriteImage(
        Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
        args.imageFilePath.toNativeUtf8(allocator: arena).cast(),
      ),
    ) ==
    1;
