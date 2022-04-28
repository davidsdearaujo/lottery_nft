part of lottery_api;

@JS('lotteryConfigure')
external void _configure(void Function() callback, void Function(JsError) errorCallback);

@JS('lotteryGetPlayers')
external void _getPlayers(void Function(List) callback, void Function(JsError) errorCallback);

@JS('lotteryEnter')
external void _enter(String accountHash, String etherAmmount, void Function() callback, void Function(JsError) errorCallback);

@JS('lotteryGetManagerHash')
external void _getManagerHash(void Function(String) callback, void Function(JsError) errorCallback);

@JS('lotteryGetTotalAmount')
external void _getTotalAmount(void Function(String) callback, void Function(JsError) errorCallback);
