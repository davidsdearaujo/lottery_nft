class AddressValue {
  final String value;
  AddressValue(this.value);

  String toShortString() {
    return value.substring(0, 5) + '...' + value.substring(value.length - 4, value.length);
  }

  @override
  String toString() => value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddressValue && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
