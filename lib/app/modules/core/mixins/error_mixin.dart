import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../failures/failure.dart';

mixin ErrorMixin<T extends StatefulWidget> on State<T> {
  VoidCallback? _observableDisposer;
  Store<Failure, Object> get store;

  static void showDialogOnError(Object? error, BuildContext context) {
    String? title;
    String? message;

    if (error is Failure) {
      title = 'Oops';
      message = '${error.message}';
      if (kDebugMode && error.debugMessage != null) message += '\n\nDebug Message: ${error.debugMessage}';
    }

    if (title != null && message != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title!),
          content: Text(message!),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _observableDisposer = store.observer(onError: (error) => showDialogOnError(error, context));
    });
  }

  @override
  void dispose() {
    _observableDisposer?.call();
    super.dispose();
  }
}
