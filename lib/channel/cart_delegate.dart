import 'FlutterMethodChannel.dart';

class CartDelegate {
  static void goToCustomer() {
    FlutterMethodChannel.platform.invokeMethod("goToCustomer");
  }
}
