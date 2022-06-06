part of lottery_api;

@JS('lotteryConfigure')
external void _configure(void Function() callback, void Function(JsError) errorCallback);

@JS('lotteryGetPlayers')
external void _getPlayers(void Function(List) callback, void Function(JsError) errorCallback);

@JS('lotteryEnter')
external void _enter(String accountAddress, String etherAmmount, void Function() callback, void Function(JsError) errorCallback);

@JS('lotteryGetManagerAddress')
external void _getManagerAddress(void Function(String) callback, void Function(JsError) errorCallback);

@JS('lotteryGetAccountAddress')
external void _getAccountAddress(void Function(String) responseCallback);

@JS('lotteryPickWinner')
external void _pickWinner(String accountAddress, void Function() callback, void Function(JsError) errorCallback);
