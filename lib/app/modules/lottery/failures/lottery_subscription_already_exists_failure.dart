import 'package:lottery_flutter/app/modules/core/core_module.dart';

class LotterySubscriptionAlreadyExistsFailure extends Failure {
  LotterySubscriptionAlreadyExistsFailure()
      : super(code: 'lottery-subscription-already-exists', debugMessage: 'Already exists a subscription for lottery updates');
}
