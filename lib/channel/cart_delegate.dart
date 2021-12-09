import 'flutter_method_channel.dart';

class CartDelegate {
  static void goToCustomer() {
    FlutterMethodChannel.platform.invokeMethod("goToCustomer");
  }
}
