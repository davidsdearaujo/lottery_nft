library lottery_api;

import 'dart:async';

import 'package:js/js.dart';

import '../value_objects/hash_value.dart';
import 'models/js_error.dart';

part 'interop/lottery_api_interop.dart';

class LotteryApi {
  Future<void> configure() async {
    final completer = Completer<void>();
    _configure(allowInterop(completer.complete), allowInterop(completer.completeError));
    await completer.future;
  }

  Future<HashValue> getManagerHash() async {
    final completer = Completer<String>();
    _getManagerHash(allowInterop(completer.complete), allowInterop(completer.completeError));
    final managerHash = await completer.future;
    return HashValue(managerHash);
  }

  Future<double> getTotalAmount() async {
    final completer = Completer<String>();
    _getTotalAmount(allowInterop(completer.complete), allowInterop(completer.completeError));
    final stringBalance = await completer.future;
    return double.parse(stringBalance);
  }

  Future<void> enter(HashValue accountHash, double etherAmmount) async {
    final completer = Completer<void>();
    _enter(accountHash.toString(), etherAmmount.toString(), allowInterop(completer.complete), allowInterop(completer.completeError));
    await completer.future;
  }

  Future<List<HashValue>> getPlayers() async {
    final completer = Completer<List>();
    _getPlayers(allowInterop(completer.complete), allowInterop(completer.completeError));
    final players = await completer.future;
    return players.cast<String>().map((hash) => HashValue(hash)).toList();
  }
}
