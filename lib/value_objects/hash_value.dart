class HashValue {
  final String value;
  HashValue(this.value);

  String toShortString() {
    return value.substring(0, 5) + '...' + value.substring(value.length - 4, value.length);
  }

  @override
  String toString() => value;
}
