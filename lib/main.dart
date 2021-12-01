import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spos_v2/providers/cart_manager.dart';
import 'package:spos_v2/screens/cart_screen.dart';

import 'channel/FlutterMethodChannel.dart';

void main() {
  runApp(const MyApp());
  FlutterMethodChannel.instance.configureChannel();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartManager.getInstance()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: const CartScreen(),
      ),
    );
  }
}
