import 'package:js/js.dart';

@JS()
@anonymous
class JsError {
  external factory JsError({code, message, stack});
  external int get code;
  external String get message;
  external String? get stack;
}
