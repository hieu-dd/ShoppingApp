import 'package:flutter/services.dart';
import 'package:spos_v2/providers/cart_manager.dart';

class FlutterMethodChannel {
  static const platform = MethodChannel(FlutterMethodChannel.CHANNEL_FLUTTER);
  static const CHANNEL_FLUTTER = "channel.flutter";
  MethodChannel? methodChannel;

  static final FlutterMethodChannel instance = FlutterMethodChannel._init();

  FlutterMethodChannel._init();

  void configureChannel() {
    methodChannel = MethodChannel(CHANNEL_FLUTTER);
    methodChannel!
        .setMethodCallHandler(this.methodHandler); // set method handler
  }

  Future<void> methodHandler(MethodCall call) async {
    switch (call.method) {
      case "refreshCart":
        CartManager.getInstance().refreshCart();
        break;
      default:
        print('no method handler for method ${call.method}');
    }
  }
}
