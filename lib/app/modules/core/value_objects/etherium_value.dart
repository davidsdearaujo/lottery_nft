class EtheriumValue {
  final double value;

  EtheriumValue(this.value);
  EtheriumValue.fromString(String value) : value = double.parse(value);

  @override
  String toString() => '${toStringWithFractionDigits(4)} ETH';
  String toStringWithFractionDigits(int fractionDigits) => value.toStringAsFixed(fractionDigits);
  double toDouble() => value;
}
