import 'package:flutter_modular/flutter_modular.dart';

export 'exports/failures.dart';
export 'exports/mixins.dart';
export 'exports/value_objects.dart';

class CoreModule extends Module {
  @override
  late final List<Bind> binds = [];
}
