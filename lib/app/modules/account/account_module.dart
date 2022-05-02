import 'package:flutter_modular/flutter_modular.dart';
import 'package:lottery_flutter/app/modules/core/core_module.dart';
import 'package:lottery_flutter/app/modules/web3/web3_module.dart';

import 'stores/account_balance_store.dart';
import 'stores/select_account_store.dart';

export 'stores/account_balance_store.dart';
export 'stores/select_account_store.dart';
export 'widgets/account_dropdown.dart';

class AccountModule extends Module {
  @override
  List<Module> get imports => [CoreModule(), Web3Module()];
  @override
  late final List<Bind> binds = [
    Bind.lazySingleton((i) => SelectAccountStore(i()), export: true),
    Bind.lazySingleton((i) => AccountBalanceStore(i()), export: true),
  ];
}
