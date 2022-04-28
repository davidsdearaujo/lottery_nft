part of web3_api;

@JS('subscribeUpdates')
external void _subscribeUpdates(
  String type,
  void Function() updateCallback,
  void Function(JsError) errorCallback,
  void Function(void Function()) disposerCallback,
);

@JS('getAccountBalance')
external void _getAccountBalance(String accountHash, void Function(String) callback, void Function(JsError) errorCallback);

@JS('subscribeAccountBalance')
external void _subscribeAccountBalance(
  String account,
  void Function(String) callback,
  void Function(JsError) errorCallback,
  void Function(void Function()) disposerCallback,
);

@JS('getAccounts')
external void _getAccounts(void Function(List<String>) callback, void Function(JsError) errorCallback);
