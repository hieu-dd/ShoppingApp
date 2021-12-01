import 'package:flutter/material.dart';
import 'package:spos_v2/providers/cart_line_entity.dart';

class CartEntity with ChangeNotifier {
  final String id;
  final List<CartLineEntity> orderLines;
  final int grandTotal;

  CartEntity(this.id, this.orderLines, this.grandTotal);

  static CartEntity fromJson(dynamic jsonString) {
    try {
      final orderLinesJson = jsonString['items'] as List<dynamic>;
      final orderLines =
          orderLinesJson.map((e) => CartLineEntity.fromJson(e)).toList();
      return CartEntity(
        jsonString['id'],
        orderLines,
        jsonString['grandTotal'],
      );
    } catch (error) {
      rethrow;
    }
  }
}
