import 'package:flutter_modular/flutter_modular.dart';

import 'api/web3_api.dart';

export 'api/web3_api.dart';
export 'models/js_error.dart';
export 'models/listen_type_enum.dart';

class Web3Module extends Module {
  @override
  late final List<Bind> binds = [
    Bind.lazySingleton((i) => Web3Api(), export: true),
  ];
}
