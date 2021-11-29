import 'package:flutter/material.dart';
import 'package:spos_v2/providers/cart_entity.dart';

class CartManager with ChangeNotifier {
  CartEntity? _cart;

  CartEntity? get cart {
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
        item.updateItem(quantity, selected);
      } catch (error) {
        throw Exception("Missing item");
      }
    }
  }

  Future<void> refreshCart() async {
    Future.delayed(Duration(seconds: 2));
    final cart = CartEntity.fake(10);
    _cart = cart;
    notifyListeners();
  }
}
