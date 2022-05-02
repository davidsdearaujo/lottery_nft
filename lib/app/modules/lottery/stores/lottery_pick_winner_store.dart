import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import 'package:lottery_flutter/app/modules/core/core_module.dart';

import '../api/lottery_api.dart';

class LotteryPickWinnerStore extends StreamStore<Failure, LotteryPickWinnerState> with Disposable {
  final LotteryApi _lotteryApi;
  LotteryPickWinnerStore(this._lotteryApi) : super(LotteryPickWinnerState.empty);

  Future<void> init() async {
    await _lotteryApi.configure();
  }

  @override
  void dispose() async {
    destroy();
  }

  Future<void> pickWinner() async {
    try {
      setLoading(true);
      if (state.winnerAddress == null) await _lotteryApi.pickWinner();
    } on Failure catch (failure) {
      setError(failure);
      rethrow;
    } finally {
      setLoading(false);
    }
  }
}

class LotteryPickWinnerState {
  final AddressValue? winnerAddress;

  const LotteryPickWinnerState({
    required this.winnerAddress,
  });

  static LotteryPickWinnerState empty = const LotteryPickWinnerState(
    winnerAddress: null,
  );

  LotteryPickWinnerState copyWith({
    AddressValue? winnerAddress,
  }) {
    return LotteryPickWinnerState(
      winnerAddress: winnerAddress ?? this.winnerAddress,
    );
  }
}
