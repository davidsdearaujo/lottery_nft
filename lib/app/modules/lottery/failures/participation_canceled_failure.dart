import 'package:lottery_flutter/app/modules/core/core_module.dart';

class ParticipationCanceledByUserFailure extends Failure {
  ParticipationCanceledByUserFailure({Object? exception, StackTrace? stackTrace})
      : super(
            code: 'participation-canceled-by-user',
            message: 'Participation canceled!',
            debugMessage: 'Operation canceled by User',
            exception: exception,
            stackTrace: stackTrace);
}
