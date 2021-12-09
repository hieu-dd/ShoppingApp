import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spos_v2/channel/flutter_method_channel.dart';
import 'package:spos_v2/data/apollo_config.dart';

class ApolloColor with ChangeNotifier {
  static ApolloColor instance = ApolloColor._init();
  dynamic colors = APOLLO_CONFIG['colorThemes'];

  Color get primaryColor500 {
    return Color(colors['primaryColor']['color500']);
  }

  ApolloColor._init();

  Future<void> getData() async {
    final result =
        await FlutterMethodChannel.platform.invokeMethod("getApolloTheme");
    colors = json.decode(result)['colorTheme'];
    notifyListeners();
  }
}
