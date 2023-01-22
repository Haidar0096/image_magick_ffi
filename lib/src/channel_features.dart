part of 'image_magick_ffi.dart';

/// Represents features of a channel in an image.
class ChannelFeatures {
  final Float64List? angularSecondMoment;
  final Float64List? contrast;
  final Float64List? correlation;
  final Float64List? varianceSumOfSquares;
  final Float64List? inverseDifferenceMoment;
  final Float64List? sumAverage;
  final Float64List? sumVariance;
  final Float64List? sumEntropy;
  final Float64List? entropy;
  final Float64List? differenceVariance;
  final Float64List? differenceEntropy;
  final Float64List? measureOfCorrelation1;
  final Float64List? measureOfCorrelation2;
  final Float64List? maximumCorrelationCoefficient;

  ChannelFeatures({
    required this.angularSecondMoment,
    required this.contrast,
    required this.correlation,
    required this.varianceSumOfSquares,
    required this.inverseDifferenceMoment,
    required this.sumAverage,
    required this.sumVariance,
    required this.sumEntropy,
    required this.entropy,
    required this.differenceVariance,
    required this.differenceEntropy,
    required this.measureOfCorrelation1,
    required this.measureOfCorrelation2,
    required this.maximumCorrelationCoefficient,
  });

  static ChannelFeatures? _fromChannelFeaturesStructPointer(
      Pointer<_ChannelFeaturesStruct> ptr) {
    return ptr == nullptr
        ? null
        : ChannelFeatures(
            angularSecondMoment: ptr.ref.angularSecondMoment.toFloat64List(4),
            contrast: ptr.ref.contrast.toFloat64List(4),
            correlation: ptr.ref.correlation.toFloat64List(4),
            varianceSumOfSquares: ptr.ref.varianceSumOfSquares.toFloat64List(4),
            inverseDifferenceMoment:
                ptr.ref.inverseDifferenceMoment.toFloat64List(4),
            sumAverage: ptr.ref.sumAverage.toFloat64List(4),
            sumVariance: ptr.ref.sumVariance.toFloat64List(4),
            sumEntropy: ptr.ref.sumEntropy.toFloat64List(4),
            entropy: ptr.ref.entropy.toFloat64List(4),
            differenceVariance: ptr.ref.differenceVariance.toFloat64List(4),
            differenceEntropy: ptr.ref.differenceEntropy.toFloat64List(4),
            measureOfCorrelation1:
                ptr.ref.measureOfCorrelation1.toFloat64List(4),
            measureOfCorrelation2:
                ptr.ref.measureOfCorrelation2.toFloat64List(4),
            maximumCorrelationCoefficient:
                ptr.ref.maximumCorrelationCoefficient.toFloat64List(4),
          );
  }
}

class _ChannelFeaturesStruct extends Struct {
  @Array(4)
  external Array<Double> angularSecondMoment;
  @Array(4)
  external Array<Double> contrast;
  @Array(4)
  external Array<Double> correlation;
  @Array(4)
  external Array<Double> varianceSumOfSquares;
  @Array(4)
  external Array<Double> inverseDifferenceMoment;
  @Array(4)
  external Array<Double> sumAverage;
  @Array(4)
  external Array<Double> sumVariance;
  @Array(4)
  external Array<Double> sumEntropy;
  @Array(4)
  external Array<Double> entropy;
  @Array(4)
  external Array<Double> differenceVariance;
  @Array(4)
  external Array<Double> differenceEntropy;
  @Array(4)
  external Array<Double> measureOfCorrelation1;
  @Array(4)
  external Array<Double> measureOfCorrelation2;
  @Array(4)
  external Array<Double> maximumCorrelationCoefficient;
}
