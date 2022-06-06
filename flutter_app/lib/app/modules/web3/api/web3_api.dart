library web3_api;

import 'dart:async';
import 'dart:ui';

import 'package:js/js.dart';

import '../models/js_error.dart';
import '../models/listen_type_enum.dart';

export '../models/listen_type_enum.dart';
export '../models/listen_type_enum.dart';

part 'web3_api_interop.dart';

class Web3Api {
  Future<double> getAccountBalance(String accountAddress) async {
    final completer = Completer<String>();
    _getAccountBalance(accountAddress, allowInterop(completer.complete), allowInterop(completer.completeError));
    final stringBalance = await completer.future;
    final balance = double.parse(stringBalance);

    return balance;
  }

  Future<List<String>> getAccounts() async {
    final completer = Completer<List>();
    _getAccounts(allowInterop(completer.complete), allowInterop(completer.completeError));
    final accounts = await completer.future;
    return accounts.cast<String>().toList();
  }

  Future<VoidCallback> listen(ListenTypeEnum type, void Function() onUpdate) async {
    final completer = Completer<VoidCallback>();
    _subscribeUpdates(
      type.name,
      allowInterop(onUpdate),
      allowInterop(completer.completeError),
      allowInterop(completer.complete),
    );
    final disposer = await completer.future;
    return disposer;
  }
}
