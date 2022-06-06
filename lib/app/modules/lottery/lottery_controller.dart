import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottery_flutter/app/modules/account/account_module.dart';
import 'package:lottery_flutter/app/modules/core/core_module.dart';

import 'stores/lottery_data_store.dart';
import 'stores/lottery_enter_store.dart';
import 'stores/lottery_pick_winner_store.dart';

export '../account/stores/account_balance_store.dart';
export 'stores/lottery_data_store.dart';

class LotteryController {
  final LotteryDataStore lotteryDataStore;
  final LotteryEnterStore lotteryEnterStore;
  final LotteryPickWinnerStore lotteryPickWinnerStore;
  final SelectAccountStore selectAccountStore;
  final AccountBalanceStore accountBalanceStore;
  LotteryController(
      this.lotteryDataStore, this.selectAccountStore, this.accountBalanceStore, this.lotteryEnterStore, this.lotteryPickWinnerStore);

  bool get isCurrentAccountManager =>
      selectAccountStore.state.selectedAccountAddress != null &&
      selectAccountStore.state.selectedAccountAddress == lotteryDataStore.state.managerAddress;

  Future<void> init() async {
    await Future.wait([
      lotteryDataStore.init(),
      lotteryDataStore.init(),
      selectAccountStore.init().then((_) {
        if (selectAccountStore.state.selectedAccountAddress != null) {
          accountBalanceStore.loadAccountBalance(selectAccountStore.state.selectedAccountAddress!);
          accountBalanceStore.subscribeAccountBalance(selectAccountStore.state.selectedAccountAddress!);
        }
      }),
    ]);
  }

  void onAmountToEnterChanged(String value) {
    final doubleAmount = double.parse(value);
    final etherAmount = EtheriumValue(doubleAmount);
    lotteryEnterStore.changeAmount(etherAmount);
  }

  Future<void> onEnterButtonPressed(BuildContext context) async {
    final selectedAccountAddress = selectAccountStore.state.selectedAccountAddress;
    if (selectedAccountAddress != null) {
      await lotteryEnterStore.enter(selectedAccountAddress);
      await lotteryDataStore.loadTotalAmount();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('You entered!'),
          content: Text('You are competing for the accumulated value of ${lotteryDataStore.state.totalAmount.toString()}. \nGood luck!'),
        ),
      );
    }
  }

  Future<void> onPickWinnerButtonPressed(BuildContext context) async {
    final selectedAccountAddress = selectAccountStore.state.selectedAccountAddress;
    await lotteryPickWinnerStore.pickWinner(selectedAccountAddress);
    final winnerAddress = lotteryPickWinnerStore.state.winnerAddress;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('There is a winner!'),
        content: Text('The winner of this lottery is $winnerAddress'),
      ),
    );
  }
}
