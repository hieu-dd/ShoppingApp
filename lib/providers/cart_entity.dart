import 'package:flutter/material.dart';
import 'package:spos_v2/providers/cart_line_entity.dart';
import 'package:uuid/uuid.dart';

class CartEntity with ChangeNotifier {
  final String id;
  final List<CartLineEntity> orderLines;

  CartEntity(this.id, this.orderLines);

  static CartEntity fromJson(dynamic jsonString) {
    final orderLinesJson = jsonString['orderLines'] as List<dynamic>;
    final orderLines =
        orderLinesJson.map((e) => CartLineEntity.fromJson(e)).toList();
    return CartEntity(jsonString['id'], orderLines);
  }

  static CartEntity fake(int size) {
    final List<CartLineEntity> orderLines = [];
    for (int i = 0; i < size; i++) {
      orderLines.add(CartLineEntity.fake(index: i));
    }
    return CartEntity(Uuid().v1(), orderLines);
  }
}
