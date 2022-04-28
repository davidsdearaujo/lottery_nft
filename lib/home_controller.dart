import 'dart:async';

import 'package:flutter/material.dart';

import 'api/lottery_api.dart';
import 'api/web3_api.dart';
import 'value_objects/hash_value.dart';

mixin HomeController<T extends StatefulWidget> on State<T> {
  HashValue? managerHash;
  int? numberOfParticipants = 0;
  double? totalAmount = 0;
  HashValue? selectedAccountHash;
  double? accountBalance;
  var accountsList = <HashValue>[];
  final controller = TextEditingController();
  final lotteryApiCompleter = Completer<LotteryApi>();
  final web3Api = Web3Api();

  bool get isCurrentAccountManager => selectedAccountHash == managerHash;

  VoidCallback? subscriptionDisposer;

  @override
  void dispose() {
    subscriptionDisposer?.call();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final _lotteryApi = LotteryApi();
    lotteryApiCompleter.complete(_lotteryApi.configure().then((_) => _lotteryApi));

    loadManagerId();
    loadPlayers();
    loadTotalAmount();
    loadAccounts().then((_) {
      setState(() => selectedAccountHash = accountsList.first);
      loadAccountBalance();
    });
    subscribeUpdates();
  }

  Future<void> subscribeUpdates() async {
    subscriptionDisposer = await web3Api.listen(ListenTypeEnum.newBlockHeaders, () async {
      loadAccountBalance();
      loadTotalAmount();
      loadPlayers();
    });
  }

  Future<void> loadManagerId() async {
    final lotteryApi = await lotteryApiCompleter.future;
    final managerHash = await lotteryApi.getManagerHash();
    setState(() => this.managerHash = managerHash);
  }

  Future<void> loadPlayers() async {
    final lotteryApi = await lotteryApiCompleter.future;
    final players = await lotteryApi.getPlayers();
    setState(() => numberOfParticipants = players.length);
  }

  Future<void> loadAccounts() async {
    await lotteryApiCompleter.future;
    final accountsList = await web3Api.getAccounts();
    setState(() => this.accountsList = accountsList);
  }

  Future<void> loadTotalAmount() async {
    final lotteryApi = await lotteryApiCompleter.future;
    final amount = await lotteryApi.getTotalAmount();
    setState(() => totalAmount = amount);
  }

  Future<void> loadAccountBalance() async {
    if (selectedAccountHash != null) {
      final accountBalance = await web3Api.getAccountBalance(selectedAccountHash!);
      setState(() => this.accountBalance = accountBalance);
    }
  }
}
