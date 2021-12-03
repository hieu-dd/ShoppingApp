import 'package:flutter/material.dart';
import 'package:spos_v2/providers/cart_line_entity.dart';

class CartEntity with ChangeNotifier {
  final String id;
  final List<CartLineEntity> orderLines;
  final int grandTotal;

  CartEntity(this.id, this.orderLines, this.grandTotal);

  List<CartLineEntity> get selectOrderLines {
    return orderLines.where((element) => element.selected).toList();
  }

  bool get hasItems {
    return orderLines.isNotEmpty;
  }

  bool get hasSelectItems {
    return orderLines.where((element) => element.selected).isNotEmpty;
  }

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
