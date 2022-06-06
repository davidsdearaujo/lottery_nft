import 'package:lottery_flutter/app/modules/core/core_module.dart';

class ManagerAccountRequiredFailure extends Failure {
  ManagerAccountRequiredFailure({Object? exception, StackTrace? stackTrace})
      : super(
            code: 'manager-account-required',
            message: 'You are not a manager. Try again with another account.',
            exception: exception,
            stackTrace: stackTrace);
}
