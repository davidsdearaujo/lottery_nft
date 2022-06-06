import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';

import 'error_mixin.dart';

mixin ErrorListMixin<T extends StatefulWidget> on State<T> {
  final _observableDisposers = <VoidCallback>[];
  List<Store> get shouldListenError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      for (var store in shouldListenError) {
        final disposer = store.observer(onError: (error) => ErrorMixin.showDialogOnError(error, context));
        _observableDisposers.add(disposer);
      }
    });
  }

  @override
  void dispose() {
    for (var disposer in _observableDisposers) {
      disposer.call();
    }
    super.dispose();
  }
}
