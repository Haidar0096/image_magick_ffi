part of 'image_magick_ffi.dart';

class ChannelStatistics {
  final int depth;
  final double area;
  final double minima;
  final double maxima;
  final double sum;
  final double sumSquared;
  final double sumCubed;
  final double sumFourthPower;
  final double mean;
  final double variance;
  final double standardDeviation;
  final double kurtosis;
  final double skewness;
  final double entropy;
  final double median;

  const ChannelStatistics({
    required this.depth,
    required this.area,
    required this.minima,
    required this.maxima,
    required this.sum,
    required this.sumSquared,
    required this.sumCubed,
    required this.sumFourthPower,
    required this.mean,
    required this.variance,
    required this.standardDeviation,
    required this.kurtosis,
    required this.skewness,
    required this.entropy,
    required this.median,
  });

  static ChannelStatistics? _fromChannelStatisticsStructPointer(
      Pointer<_ChannelStatisticsStruct> ptr) {
    return ptr == nullptr
        ? null
        : ChannelStatistics(
            depth: ptr.ref.depth,
            area: ptr.ref.area,
            minima: ptr.ref.minima,
            maxima: ptr.ref.maxima,
            sum: ptr.ref.sum,
            sumSquared: ptr.ref.sumSquared,
            sumCubed: ptr.ref.sumCubed,
            sumFourthPower: ptr.ref.sumFourthPower,
            mean: ptr.ref.mean,
            variance: ptr.ref.variance,
            standardDeviation: ptr.ref.standardDeviation,
            kurtosis: ptr.ref.kurtosis,
            skewness: ptr.ref.skewness,
            entropy: ptr.ref.entropy,
            median: ptr.ref.median,
          );
  }

  @override
  String toString() =>
      'ChannelStatistics(depth: $depth, area: $area, minima: $minima, maxima: $maxima, sum: $sum, sumSquared: $sumSquared, sumCubed: $sumCubed, sumFourthPower: $sumFourthPower, mean: $mean, variance: $variance, standardDeviation: $standardDeviation, kurtosis: $kurtosis, skewness: $skewness, entropy: $entropy, median: $median)';
}

class _ChannelStatisticsStruct extends Struct {
  @Size()
  external int depth;

  @Double()
  external double area;

  @Double()
  external double minima;

  @Double()
  external double maxima;

  @Double()
  external double sum;

  @Double()
  external double sumSquared;

  @Double()
  external double sumCubed;

  @Double()
  external double sumFourthPower;

  @Double()
  external double mean;

  @Double()
  external double variance;

  @Double()
  external double standardDeviation;

  @Double()
  external double kurtosis;

  @Double()
  external double skewness;

  @Double()
  external double entropy;

  @Double()
  external double median;
}
