class Failure {
  final String code;
  final String? message;
  final String? debugMessage;
  final Object? exception;
  final StackTrace? stackTrace;
  Failure({
    required this.code,
    this.message,
    this.debugMessage,
    this.exception,
    this.stackTrace,
  });
}
