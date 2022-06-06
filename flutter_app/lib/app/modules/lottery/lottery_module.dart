import 'package:flutter_modular/flutter_modular.dart';
import 'package:lottery_flutter/app/modules/account/account_module.dart';
import 'package:lottery_flutter/app/modules/core/core_module.dart';
import 'package:lottery_flutter/app/modules/web3/web3_module.dart';

import 'api/lottery_api.dart';
import 'lottery_controller.dart';
import 'lottery_page.dart';
import 'stores/lottery_enter_store.dart';
import 'stores/lottery_pick_winner_store.dart';

class LotteryModule extends Module {
  @override
  List<Module> get imports => [CoreModule(), Web3Module(), AccountModule()];
  @override
  late final List<Bind> binds = [
    //Controllers
    Bind.lazySingleton((i) => LotteryController(i(), i(), i(), i(), i())),
    //Stores
    Bind.lazySingleton((i) => LotteryDataStore(i(), i())),
    Bind.lazySingleton((i) => LotteryEnterStore(i())),
    Bind.lazySingleton((i) => LotteryPickWinnerStore(i())),
    //Apis
    Bind.lazySingleton((i) => LotteryApi()),
  ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => LotteryPage()),
      ];
}
