import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:lottery_flutter/app/modules/core/core_module.dart';
import 'package:lottery_flutter/app/modules/web3/web3_module.dart';

// ignore: must_be_immutable
class AccountBalanceStore extends StreamStore<Failure, AccountBalanceState> with Disposable {
  final Web3Api _web3Api;
  AccountBalanceStore(this._web3Api) : super(AccountBalanceState.empty);

  VoidCallback? balanceSubscription;

  @override
  void dispose() {
    balanceSubscription?.call();
    destroy();
  }

  Future<void> loadAccountBalance(AddressValue accountAddress) async {
    try {
      setLoading(true);
      final accountBalance = await _web3Api.getAccountBalance(accountAddress.toString());
      update(state.copyWith(accountBalance: EtheriumValue(accountBalance)));
    } on Failure catch (failure) {
      setError(failure);
    } finally {
      setLoading(false);
    }
  }

  Future<void> subscribeAccountBalance(AddressValue accountAddress) async {
    try {
      setLoading(true);
      balanceSubscription = await _web3Api.listen(ListenTypeEnum.newBlockHeaders, () async {
        final accountBalance = await _web3Api.getAccountBalance(accountAddress.toString());
        update(state.copyWith(accountBalance: EtheriumValue(accountBalance)));
      });
    } on Failure catch (failure) {
      setError(failure);
    } finally {
      setLoading(false);
    }
  }
}

class AccountBalanceState {
  final EtheriumValue? accountBalance;

  AccountBalanceState({
    required this.accountBalance,
  });

  static AccountBalanceState empty = AccountBalanceState(
    accountBalance: null,
  );

  AccountBalanceState copyWith({
    EtheriumValue? accountBalance,
  }) {
    return AccountBalanceState(
      accountBalance: accountBalance ?? this.accountBalance,
    );
  }
}
