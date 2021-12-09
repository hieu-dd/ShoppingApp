import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spos_v2/channel/flutter_method_channel.dart';
import 'package:spos_v2/providers/cart_entity.dart';

class CartManager with ChangeNotifier {
  static CartManager? _instance;

  static CartManager get instance {
    return _instance ??= CartManager();
  }

  CartEntity? _cart;

  CartEntity? get cart {
    if (_cart == null) refreshCart();
    return _cart;
  }

  Future<void> updateItem(
    String lineId,
    int? quantity,
    bool? selected,
  ) async {
    if (_cart != null) {
      try {
        final item =
            _cart!.orderLines.firstWhere((element) => element.id == lineId);
        item.updateItem(quantity: quantity, selected: selected);
      } catch (error) {
        throw Exception("Missing item");
      }
    }
  }

  Future<void> updateSeller(int sellerId, bool selected) async {
    _cart!.orderLines.forEach((element) {
      if (element.sellerId == sellerId) {
        element.updateItem(
          selected: selected,
          needApi: false,
        );
      }
    });
    notifyListeners();
    await FlutterMethodChannel.platform.invokeMethod('updateSeller', {
      'id': sellerId,
      'selected': selected,
    });
  }

  Future<void> refreshCart() async {
    final String jsonResult =
        await FlutterMethodChannel.platform.invokeMethod('getCart');
    final cart = CartEntity.fromJson(json.decode(jsonResult));
    _cart = cart;
    notifyListeners();
  }
}
