import 'dart:math';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CartLineEntity with ChangeNotifier {
  final String id;
  final String name;
  final String sku;
  final String imageUrl;
  final int totalAvailable;
  final double price;
  final double supplierPrice;
  var selected = true;
  var quantity = 1;

  CartLineEntity({
    required this.id,
    required this.name,
    required this.sku,
    required this.imageUrl,
    required this.totalAvailable,
    required this.price,
    required this.supplierPrice,
  });

  void updateItem(int? quantity, bool? selected) {
    if (quantity != null) {
      this.quantity = quantity;
    }
    if (selected != null) {
      this.selected = selected;
    }
    notifyListeners();
  }

  static CartLineEntity fromJson(dynamic jsonString) {
    return CartLineEntity(
      id: jsonString['id'],
      name: jsonString['name'],
      sku: jsonString['sku'],
      imageUrl: jsonString['imageUrl'],
      totalAvailable: jsonString['totalAvailable'],
      price: jsonString['price'],
      supplierPrice: jsonString['supplierPrice'],
    );
  }

  static CartLineEntity fake({int index = 0}) {
    return CartLineEntity(
      id: Uuid().v1(),
      name: "San pham ${index}",
      sku: "Sku ${index}",
      imageUrl: "https://vsi.gov.vn/Content/Publishing/Images/product-img.png",
      totalAvailable: Random().nextInt(100),
      price: Random().nextInt(1000000).toDouble(),
      supplierPrice: Random().nextInt(10000000).toDouble(),
    );
  }
}
