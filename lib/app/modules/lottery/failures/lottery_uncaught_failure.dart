import 'package:lottery_flutter/app/modules/core/core_module.dart';

class LotteryUncaughtFailure extends Failure {
  LotteryUncaughtFailure({
    required String message,
    required Object exception,
    required StackTrace stackTrace,
  }) : super(
            code: 'lottery-uncaught-failure',
            message: message,
            debugMessage: 'Uncaught error',
            exception: exception,
            stackTrace: stackTrace);
}
