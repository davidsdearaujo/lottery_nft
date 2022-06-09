library web3_api;

import 'dart:async';
import 'dart:js' as js;
import 'dart:ui';

import '../models/listen_type_enum.dart';

export '../models/listen_type_enum.dart';
export '../models/listen_type_enum.dart';

class Web3Api {
  Future<double> getAccountBalance(String accountAddress) async {
    final completer = Completer<String>();
    js.context.callMethod('getAccountBalance', [
      accountAddress,
      completer.complete,
      completer.completeError,
    ]);
    final stringBalance = await completer.future;
    final balance = double.parse(stringBalance);

    return balance;
  }

  Future<List<String>> getAccounts() async {
    final completer = Completer<List>();
    js.context.callMethod('getAccounts', [
      completer.complete,
      completer.completeError,
    ]);
    final accounts = await completer.future;
    return accounts.cast<String>().toList();
  }

  Future<VoidCallback> listen(ListenTypeEnum type, void Function() onUpdate) async {
    final completer = Completer<VoidCallback>();
    js.context.callMethod('subscribeUpdates', [
      type.name,
      onUpdate,
      completer.complete,
      completer.completeError,
    ]);
    final disposer = await completer.future;
    return disposer;
  }
}
