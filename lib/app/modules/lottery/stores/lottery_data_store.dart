import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:lottery_flutter/app/modules/core/core_module.dart';
import 'package:lottery_flutter/app/modules/web3/web3_module.dart';

import '../api/lottery_api.dart';
import '../failures/lottery_subscription_already_exists_failure.dart';

// ignore: must_be_immutable
class LotteryDataStore extends StreamStore<Failure, LotteryDataState> with Disposable {
  final LotteryApi _lotteryApi;
  final Web3Api _web3Api;
  LotteryDataStore(this._lotteryApi, this._web3Api) : super(LotteryDataState.empty);

  VoidCallback? _subscriptionDisposer;

  Future<void> init() async {
    await _lotteryApi.configure();
    await Future.wait([
      loadManagerAddress(),
      loadTotalAmount(),
      loadPlayers(),
    ]);
    subscribeUpdates();
  }

  @override
  void dispose() async {
    _subscriptionDisposer?.call();
    destroy();
  }

  Future<void> loadTotalAmount() async {
    try {
      setLoading(true);
      final contractAccountAddress = await _lotteryApi.getContractAccountAddress();
      final totalAmount = await _web3Api.getAccountBalance(contractAccountAddress);
      update(state.copyWith(totalAmount: EtheriumValue(totalAmount)));
    } on Failure catch (failure) {
      setError(failure);
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadManagerAddress() async {
    try {
      setLoading(true);
      final managerAddress = await _lotteryApi.getManagerAccountAddress();
      update(state.copyWith(managerAddress: AddressValue(managerAddress)));
    } on Failure catch (failure) {
      setError(failure);
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadPlayers() async {
    try {
      setLoading(true);
      final playersStringList = await _lotteryApi.getPlayers();
      final playersAddressList = playersStringList.map((stringAddress) => AddressValue(stringAddress)).toList();
      update(state.copyWith(players: playersAddressList));
    } on Failure catch (failure) {
      setError(failure);
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  void subscribeUpdates() async {
    if (_subscriptionDisposer != null) throw LotterySubscriptionAlreadyExistsFailure();
    _subscriptionDisposer = await _web3Api.listen(ListenTypeEnum.newBlockHeaders, () {
      loadTotalAmount();
      loadPlayers();
    });
  }
}

class LotteryDataState {
  final EtheriumValue? totalAmount;
  final AddressValue? managerAddress;
  final List<AddressValue> players;
  int get numberOfParticipants => players.length;

  const LotteryDataState({
    required this.totalAmount,
    required this.managerAddress,
    required this.players,
  });

  static LotteryDataState empty = const LotteryDataState(
    players: [],
    managerAddress: null,
    totalAmount: null,
  );

  LotteryDataState copyWith({
    EtheriumValue? totalAmount,
    AddressValue? managerAddress,
    List<AddressValue>? players,
  }) {
    return LotteryDataState(
      totalAmount: totalAmount ?? this.totalAmount,
      managerAddress: managerAddress ?? this.managerAddress,
      players: players ?? this.players,
    );
  }

  @override
  String toString() => 'LotteryDataState(totalAmount: $totalAmount, managerAddress: $managerAddress, players: $players)';
}
