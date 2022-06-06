class EtheriumValue {
  final double value;

  EtheriumValue(this.value);
  EtheriumValue.fromString(String value) : value = double.parse(value);

  @override
  String toString() => '${toStringWithFractionDigits(4)} ETH';
  String toStringWithFractionDigits(int fractionDigits) => value.toStringAsFixed(fractionDigits);
  double toDouble() => value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EtheriumValue && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
