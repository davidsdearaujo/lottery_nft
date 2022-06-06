library lottery_api;

import 'dart:async';

import 'package:js/js.dart';
import 'package:lottery_flutter/app/modules/core/core_module.dart';
import 'package:lottery_flutter/app/modules/web3/web3_module.dart';

import '../failures/lottery_uncaught_failure.dart';
import '../failures/manager_account_required_failure.dart';
import '../failures/participation_canceled_failure.dart';

part 'lottery_api_interop.dart';

class LotteryApi {
  bool _isConfigured = false;
  Future<void> configure() async {
    if (_isConfigured) return;

    final completer = Completer<void>();
    _configure(allowInterop(completer.complete), allowInterop(completer.completeError));
    await completer.future;
    _isConfigured = true;
  }

  Future<String> getManagerAccountAddress() async {
    final completer = Completer<String>();
    _getManagerAddress(allowInterop(completer.complete), allowInterop(completer.completeError));
    return await completer.future;
  }

  Future<String> getContractAccountAddress() async {
    final completer = Completer<String>();
    _getAccountAddress(allowInterop(completer.complete));
    return await completer.future;
  }

  Future<void> enter(String accountAddress, double etherAmmount) async {
    await _uncaughtFailureValidate(
      defaultMessage: 'You are not participating of the lottery. Please try again.',
      callback: () async {
        try {
          final completer = Completer<void>();
          _enter(accountAddress, etherAmmount.toString(), allowInterop(completer.complete), allowInterop(completer.completeError));
          await completer.future;
        } on JsError catch (error, stackTrace) {
          if (error.code == 4001) throw ParticipationCanceledByUserFailure(exception: error, stackTrace: stackTrace);
          rethrow;
        }
      },
    );
  }

  Future<List<String>> getPlayers() async {
    final completer = Completer<List>();
    _getPlayers(allowInterop(completer.complete), allowInterop(completer.completeError));
    final players = await completer.future;
    return players.cast<String>().toList();
  }

  Future<void> pickWinner(String accountAddress) async {
    await _uncaughtFailureValidate(
      defaultMessage: 'Winner not catched. Please try again.',
      callback: () async {
        try {
          final completer = Completer<void>();
          _pickWinner(accountAddress, allowInterop(completer.complete), allowInterop(completer.completeError));
          await completer.future;
        } on JsError catch (error, stackTrace) {
          if (error.code == -32000) throw ManagerAccountRequiredFailure(exception: error, stackTrace: stackTrace);
          rethrow;
        }
      },
    );
  }

  Future<void> _uncaughtFailureValidate({required String defaultMessage, required FutureOr<void> Function() callback}) async {
    try {
      await callback.call();
    } on Failure catch (_) {
      rethrow;
    } catch (exception, stackTrace) {
      throw LotteryUncaughtFailure(
        message: defaultMessage,
        exception: exception,
        stackTrace: stackTrace,
      );
    }
  }
}
