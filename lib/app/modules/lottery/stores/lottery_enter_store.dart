import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:lottery_flutter/app/modules/core/core_module.dart';

import '../api/lottery_api.dart';

class LotteryEnterStore extends StreamStore<Failure, LotteryEnterState> with Disposable {
  final LotteryApi _lotteryApi;
  LotteryEnterStore(this._lotteryApi) : super(LotteryEnterState.empty);

  Future<void> init() async {
    await _lotteryApi.configure();
  }

  @override
  void dispose() async {
    destroy();
  }

  void changeAmount(EtheriumValue amount) => update(state.copyWith(amount: amount));

  Future<void> enter(AddressValue accountAddress) async {
    try {
      setLoading(true);
      if (state.amount != null) await _lotteryApi.enter(accountAddress.toString(), state.amount!.toDouble());
    } on Failure catch (failure) {
      setError(failure);
      rethrow;
    } finally {
      setLoading(false);
    }
  }
}

class LotteryEnterState {
  final EtheriumValue? amount;

  const LotteryEnterState({
    required this.amount,
  });

  static LotteryEnterState empty = const LotteryEnterState(
    amount: null,
  );

  LotteryEnterState copyWith({
    EtheriumValue? amount,
  }) {
    return LotteryEnterState(
      amount: amount ?? this.amount,
    );
  }
}
