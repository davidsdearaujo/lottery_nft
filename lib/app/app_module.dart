import 'package:flutter_modular/flutter_modular.dart';

import 'modules/core/core_module.dart';
import 'modules/lottery/lottery_module.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];
  @override
  late final List<Bind> binds = [];

  @override
  List<ModularRoute> get routes => [
        ModuleRoute('/', module: LotteryModule()),
      ];
}
