import 'package:flutter/services.dart';
import 'package:spos_v2/extension/string_extension.dart';
import 'package:spos_v2/providers/cart_manager.dart';
import 'package:spos_v2/providers/customer.dart';
import 'package:spos_v2/theme/apollo_color.dart';

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
    ApolloColor.instance.getData();
  }

  Future<void> methodHandler(MethodCall call) async {
    switch (call.method) {
      case "refreshCart":
        CartManager.instance.refreshCart();
        break;
      case "selectCustomer":
        "Se3r".get_size();
        Customer.instance.setCustomer(call.arguments);
        break;
      default:
        print('no method handler for method ${call.method}');
    }
  }
}
