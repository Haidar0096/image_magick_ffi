// ignore_for_file: constant_identifier_names

part of 'image_magick_ffi.dart';

/// Represents the type of an exception that occurred when using the ImageMagick
/// API.
enum ExceptionType {
  UndefinedException(0),
  WarningException(300),
  TypeWarning(305),
  OptionWarning(310),
  DelegateWarning(315),
  MissingDelegateWarning(320),
  CorruptImageWarning(325),
  FileOpenWarning(330),
  BlobWarning(335),
  StreamWarning(340),
  CacheWarning(345),
  CoderWarning(350),
  FilterWarning(352),
  ModuleWarning(355),
  DrawWarning(360),
  ImageWarning(365),
  WandWarning(370),
  RandomWarning(375),
  XServerWarning(380),
  MonitorWarning(385),
  RegistryWarning(390),
  ConfigureWarning(395),
  PolicyWarning(399),
  ErrorException(400),
  TypeError(405),
  OptionError(410),
  DelegateError(415),
  MissingDelegateError(420),
  CorruptImageError(425),
  FileOpenError(430),
  BlobError(435),
  StreamError(440),
  CacheError(445),
  CoderError(450),
  FilterError(452),
  ModuleError(455),
  DrawError(460),
  ImageError(465),
  WandError(470),
  RandomError(475),
  XServerError(480),
  MonitorError(485),
  RegistryError(490),
  ConfigureError(495),
  PolicyError(499),
  FatalErrorException(700),
  TypeFatalError(705),
  OptionFatalError(710),
  DelegateFatalError(715),
  MissingDelegateFatalError(720),
  CorruptImageFatalError(725),
  FileOpenFatalError(730),
  BlobFatalError(735),
  StreamFatalError(740),
  CacheFatalError(745),
  CoderFatalError(750),
  FilterFatalError(752),
  ModuleFatalError(755),
  DrawFatalError(760),
  ImageFatalError(765),
  WandFatalError(770),
  RandomFatalError(775),
  XServerFatalError(780),
  MonitorFatalError(785),
  RegistryFatalError(790),
  ConfigureFatalError(795),
  PolicyFatalError(799);

  static const ResourceLimitWarning = WarningException;

  static const ResourceLimitError = ErrorException;

  static const ResourceLimitFatalError = FatalErrorException;

  final int value;

  const ExceptionType(this.value);

  static ExceptionType fromValue(int value) =>
      ExceptionType.values.firstWhere((e) => e.value == value);
}

/// Represents a colorspace type.
enum ColorspaceType {
  UndefinedColorspace,
  CMYColorspace,
  CMYKColorspace,
  GRAYColorspace,
  HCLColorspace,
  HCLpColorspace,
  HSBColorspace,
  HSIColorspace,
  HSLColorspace,
  HSVColorspace,
  HWBColorspace,
  LabColorspace,
  LCHColorspace,
  LCHabColorspace,
  LCHuvColorspace,
  LogColorspace,
  LMSColorspace,
  LuvColorspace,
  OHTAColorspace,
  Rec601YCbCrColorspace,
  Rec709YCbCrColorspace,
  RGBColorspace,
  scRGBColorspace,
  sRGBColorspace,
  TransparentColorspace,
  xyYColorspace,
  XYZColorspace,
  YCbCrColorspace,
  YCCColorspace,
  YDbDrColorspace,
  YIQColorspace,
  YPbPrColorspace,
  YUVColorspace,
  LinearGRAYColorspace,
  JzazbzColorspace,
  DisplayP3Colorspace,
  Adobe98Colorspace,
  ProPhotoColorspace
}

/// Represents an image compression type.
enum CompressionType {
  UndefinedCompression,
  B44ACompression,
  B44Compression,
  BZipCompression,
  DXT1Compression,
  DXT3Compression,
  DXT5Compression,
  FaxCompression,
  Group4Compression,
  JBIG1Compression,
  JBIG2Compression,
  JPEG2000Compression,
  JPEGCompression,
  LosslessJPEGCompression,
  LZMACompression,
  LZWCompression,
  NoCompression,
  PizCompression,
  Pxr24Compression,
  RLECompression,
  ZipCompression,
  ZipSCompression,
  ZstdCompression,
  WebPCompression,
  DWAACompression,
  DWABCompression,
  BC7Compression
}

/// Represents a gravity type.
enum GravityType {
  UndefinedGravity(0),
  NorthWestGravity(1),
  NorthGravity(2),
  NorthEastGravity(3),
  WestGravity(4),
  CenterGravity(5),
  EastGravity(6),
  SouthWestGravity(7),
  SouthGravity(8),
  SouthEastGravity(9);

  static const ForgetGravity = UndefinedGravity;

  final int value;

  const GravityType(this.value);

  static GravityType fromValue(int value) =>
      GravityType.values.firstWhere((e) => e.value == value);
}

/// Represents an interlace type.
enum InterlaceType {
  UndefinedInterlace,
  NoInterlace,
  LineInterlace,
  PlaneInterlace,
  PartitionInterlace,
  GIFInterlace,
  JPEGInterlace,
  PNGInterlace;
}

/// Represents a pixel interpolation method.
enum PixelInterpolateMethod {
  UndefinedInterpolatePixel,
  /* Average 4 nearest neighbours */
  AverageInterpolatePixel,
  /* Average 9 nearest neighbours */
  Average9InterpolatePixel,
  /* Average 16 nearest neighbours */
  Average16InterpolatePixel,
  /* Just return background color */
  BackgroundInterpolatePixel,
  /* Triangular filter interpolation */
  BilinearInterpolatePixel,
  /* blend of nearest 1, 2 or 4 pixels */
  BlendInterpolatePixel,
  /* Catmull-Rom interpolation */
  CatromInterpolatePixel,
  /* Integer (floor) interpolation */
  IntegerInterpolatePixel,
  /* Triangular Mesh interpolation */
  MeshInterpolatePixel,
  /* Nearest Neighbour Only */
  NearestInterpolatePixel,
  /* Cubic Spline (blurred) interpolation */
  SplineInterpolatePixel
}

/// Represents an orientation type.
enum OrientationType {
  UndefinedOrientation,
  TopLeftOrientation,
  TopRightOrientation,
  BottomRightOrientation,
  BottomLeftOrientation,
  LeftTopOrientation,
  RightTopOrientation,
  RightBottomOrientation,
  LeftBottomOrientation
}

/// Represents a resource type.
enum ResourceType {
  UndefinedResource,
  AreaResource,
  DiskResource,
  FileResource,
  HeightResource,
  MapResource,
  MemoryResource,
  ThreadResource,
  ThrottleResource,
  TimeResource,
  WidthResource,
  ListLengthResource
}

/// Represents an image type.
enum ImageType {
  UndefinedType,
  BilevelType,
  GrayscaleType,
  GrayscaleAlphaType,
  PaletteType,
  PaletteAlphaType,
  TrueColorType,
  TrueColorAlphaType,
  ColorSeparationType,
  ColorSeparationAlphaType,
  OptimizeType,
  PaletteBilevelAlphaType
}

/// Represents a noise type.
enum NoiseType {
  UndefinedNoise,
  UniformNoise,
  GaussianNoise,
  MultiplicativeGaussianNoise,
  ImpulseNoise,
  LaplacianNoise,
  PoissonNoise,
  RandomNoise
}

/// Represents an auto-threshold method.
enum AutoThresholdMethod {
  UndefinedThresholdMethod,
  KapurThresholdMethod,
  OTSUThresholdMethod,
  TriangleThresholdMethod
}

/// Represents a composite operator.
enum CompositeOperator {
  UndefinedCompositeOp,
  AlphaCompositeOp,
  AtopCompositeOp,
  BlendCompositeOp,
  BlurCompositeOp,
  BumpmapCompositeOp,
  ChangeMaskCompositeOp,
  ClearCompositeOp,
  ColorBurnCompositeOp,
  ColorDodgeCompositeOp,
  ColorizeCompositeOp,
  CopyBlackCompositeOp,
  CopyBlueCompositeOp,
  CopyCompositeOp,
  CopyCyanCompositeOp,
  CopyGreenCompositeOp,
  CopyMagentaCompositeOp,
  CopyAlphaCompositeOp,
  CopyRedCompositeOp,
  CopyYellowCompositeOp,
  DarkenCompositeOp,
  DarkenIntensityCompositeOp,
  DifferenceCompositeOp,
  DisplaceCompositeOp,
  DissolveCompositeOp,
  DistortCompositeOp,
  DivideDstCompositeOp,
  DivideSrcCompositeOp,
  DstAtopCompositeOp,
  DstCompositeOp,
  DstInCompositeOp,
  DstOutCompositeOp,
  DstOverCompositeOp,
  ExclusionCompositeOp,
  HardLightCompositeOp,
  HardMixCompositeOp,
  HueCompositeOp,
  InCompositeOp,
  IntensityCompositeOp,
  LightenCompositeOp,
  LightenIntensityCompositeOp,
  LinearBurnCompositeOp,
  LinearDodgeCompositeOp,
  LinearLightCompositeOp,
  LuminizeCompositeOp,
  MathematicsCompositeOp,
  MinusDstCompositeOp,
  MinusSrcCompositeOp,
  ModulateCompositeOp,
  ModulusAddCompositeOp,
  ModulusSubtractCompositeOp,
  MultiplyCompositeOp,
  NoCompositeOp,
  OutCompositeOp,
  OverCompositeOp,
  OverlayCompositeOp,
  PegtopLightCompositeOp,
  PinLightCompositeOp,
  PlusCompositeOp,
  ReplaceCompositeOp,
  SaturateCompositeOp,
  ScreenCompositeOp,
  SoftLightCompositeOp,
  SrcAtopCompositeOp,
  SrcCompositeOp,
  SrcInCompositeOp,
  SrcOutCompositeOp,
  SrcOverCompositeOp,
  ThresholdCompositeOp,
  VividLightCompositeOp,
  XorCompositeOp,
  StereoCompositeOp,
  FreezeCompositeOp,
  InterpolateCompositeOp,
  NegateCompositeOp,
  ReflectCompositeOp,
  SoftBurnCompositeOp,
  SoftDodgeCompositeOp,
  StampCompositeOp,
  RMSECompositeOp,
  SaliencyBlendCompositeOp,
  SeamlessBlendCompositeOp
}

/// Represents a layer method.
enum LayerMethod {
  UndefinedLayer,
  CoalesceLayer,
  CompareAnyLayer,
  CompareClearLayer,
  CompareOverlayLayer,
  DisposeLayer,
  OptimizeLayer,
  OptimizeImageLayer,
  OptimizePlusLayer,
  OptimizeTransLayer,
  RemoveDupsLayer,
  RemoveZeroLayer,
  CompositeLayer,
  MergeLayer,
  FlattenLayer,
  MosaicLayer,
  TrimBoundsLayer
}

/// Represents a metric type.
enum MetricType {
  UndefinedErrorMetric,
  AbsoluteErrorMetric,
  FuzzErrorMetric,
  MeanAbsoluteErrorMetric,
  MeanErrorPerPixelErrorMetric,
  MeanSquaredErrorMetric,
  NormalizedCrossCorrelationErrorMetric,
  PeakAbsoluteErrorMetric,
  PeakSignalToNoiseRatioErrorMetric,
  PerceptualHashErrorMetric,
  RootMeanSquaredErrorMetric,
  StructuralSimilarityErrorMetric,
  StructuralDissimilarityErrorMetric
}

/// Represents a complex operator.
enum ComplexOperator {
  UndefinedComplexOperator,
  AddComplexOperator,
  ConjugateComplexOperator,
  DivideComplexOperator,
  MagnitudePhaseComplexOperator,
  MultiplyComplexOperator,
  RealImaginaryComplexOperator,
  SubtractComplexOperator
}

/// Represents a kernel type.
enum KernelInfoType {
  /* equivalent to UnityKernel */
  UndefinedKernel,
  /* The no-op or 'original image' kernel */
  UnityKernel,
  /* Convolution Kernels, Gaussian Based */
  GaussianKernel,
  DoGKernel,
  LoGKernel,
  BlurKernel,
  CometKernel,
  BinomialKernel,
  /* Convolution Kernels, by Name */
  LaplacianKernel,
  SobelKernel,
  FreiChenKernel,
  RobertsKernel,
  PrewittKernel,
  CompassKernel,
  KirschKernel,
  /* Shape Kernels */
  DiamondKernel,
  SquareKernel,
  RectangleKernel,
  OctagonKernel,
  DiskKernel,
  PlusKernel,
  CrossKernel,
  RingKernel,
  /* Hit And Miss Kernels */
  PeaksKernel,
  EdgesKernel,
  CornersKernel,
  DiagonalsKernel,
  LineEndsKernel,
  LineJunctionsKernel,
  RidgesKernel,
  ConvexHullKernel,
  ThinSEKernel,
  SkeletonKernel,
  /* Distance Measuring Kernels */
  ChebyshevKernel,
  ManhattanKernel,
  OctagonalKernel,
  EuclideanKernel,
  /* User Specified Kernel Array */
  UserDefinedKernel
}

/// Represents a storage type.
enum _StorageType {
  UndefinedPixel,
  CharPixel,
  DoublePixel,
  FloatPixel,
  LongPixel,
  LongLongPixel,
  QuantumPixel,
  ShortPixel
}

/// Represent an image distortion method.
enum DistortMethod {
  UndefinedDistortion,
  AffineDistortion,
  AffineProjectionDistortion,
  ScaleRotateTranslateDistortion,
  PerspectiveDistortion,
  PerspectiveProjectionDistortion,
  BilinearForwardDistortion,
  BilinearReverseDistortion,
  PolynomialDistortion,
  ArcDistortion,
  PolarDistortion,
  DePolarDistortion,
  Cylinder2PlaneDistortion,
  Plane2CylinderDistortion,
  BarrelDistortion,
  BarrelInverseDistortion,
  ShepardsDistortion,
  ResizeDistortion,
  SentinelDistortion,
  RigidAffineDistortion;

  static const DistortMethod BilinearDistortion = BilinearForwardDistortion;
}

/// Represents an evaluation operator.
enum MagickEvaluateOperator {
  UndefinedEvaluateOperator,
  AbsEvaluateOperator,
  AddEvaluateOperator,
  AddModulusEvaluateOperator,
  AndEvaluateOperator,
  CosineEvaluateOperator,
  DivideEvaluateOperator,
  ExponentialEvaluateOperator,
  GaussianNoiseEvaluateOperator,
  ImpulseNoiseEvaluateOperator,
  LaplacianNoiseEvaluateOperator,
  LeftShiftEvaluateOperator,
  LogEvaluateOperator,
  MaxEvaluateOperator,
  MeanEvaluateOperator,
  MedianEvaluateOperator,
  MinEvaluateOperator,
  MultiplicativeNoiseEvaluateOperator,
  MultiplyEvaluateOperator,
  OrEvaluateOperator,
  PoissonNoiseEvaluateOperator,
  PowEvaluateOperator,
  RightShiftEvaluateOperator,
  RootMeanSquareEvaluateOperator,
  SetEvaluateOperator,
  SineEvaluateOperator,
  SubtractEvaluateOperator,
  SumEvaluateOperator,
  ThresholdBlackEvaluateOperator,
  ThresholdEvaluateOperator,
  ThresholdWhiteEvaluateOperator,
  UniformNoiseEvaluateOperator,
  XorEvaluateOperator,
  InverseLogEvaluateOperator
}

/// Represents a magick function
enum MagickFunctionType {
  UndefinedFunction,
  ArcsinFunction,
  ArctanFunction,
  PolynomialFunction,
  SinusoidFunction
}
