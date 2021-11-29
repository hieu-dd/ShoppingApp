import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spos_v2/providers/cart_manager.dart';
import 'package:spos_v2/screens/cart_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartManager()),
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel("course.flutter.dev/products");
  List<dynamic> _producs = [];

  Future<void> _getProducts() async {
    final String jsonResult = await platform.invokeMethod('getProducts');
    try {
      setState(() {
        _producs = json.decode(jsonResult);
      });
    } catch (error) {
      setState(() {
        print(error);
        print(jsonResult);

        _producs = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          InkWell(
            onTap: _getProducts,
            child: Text("Click"),
          ),
          ..._producs
              .map((e) => Text(
                    e.toString(),
                  ))
              .toList()
        ]),
      ),
    );
  }
}
