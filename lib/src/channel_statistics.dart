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
      Pointer<mwbg.ChannelStatistics> ptr) {
    return ptr == nullptr
        ? null
        : ChannelStatistics(
            depth: ptr.ref.depth,
            area: ptr.ref.area,
            minima: ptr.ref.minima,
            maxima: ptr.ref.maxima,
            sum: ptr.ref.sum,
            sumSquared: ptr.ref.sum_squared,
            sumCubed: ptr.ref.sum_cubed,
            sumFourthPower: ptr.ref.sum_fourth_power,
            mean: ptr.ref.mean,
            variance: ptr.ref.variance,
            standardDeviation: ptr.ref.standard_deviation,
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
