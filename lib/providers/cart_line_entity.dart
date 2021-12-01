import 'package:flutter/material.dart';
import 'package:spos_v2/channel/FlutterMethodChannel.dart';

class CartLineEntity with ChangeNotifier {
  final String id;
  final String name;
  final String sku;
  final String imageUrl;
  final int? totalAvailable;
  final int price;
  final int supplierPrice;
  final int sellerId;
  var selected = true;
  var quantity = 1;

  CartLineEntity({
    required this.id,
    required this.name,
    required this.sku,
    required this.sellerId,
    required this.imageUrl,
    required this.totalAvailable,
    required this.price,
    required this.supplierPrice,
  });

  Future<void> updateItem({
    int? quantity,
    bool? selected,
    bool needApi = true,
  }) async {
    if (quantity != null) {
      this.quantity = quantity;
    }
    if (selected != null) {
      this.selected = selected;
    }
    notifyListeners();
    if (needApi) {
      await FlutterMethodChannel.platform.invokeMethod('updateItem', {
        'id': id,
        'quantity': quantity,
        'selected': selected,
      });
    }
  }

  static CartLineEntity fromJson(dynamic jsonString) {
    var item = CartLineEntity(
      id: jsonString['id'],
      name: jsonString['name'],
      sku: jsonString['sku'],
      sellerId: jsonString['sellerId'],
      imageUrl: jsonString['product']['productInfo']['imageUrl'],
      totalAvailable: jsonString['totalAvailable'],
      price: jsonString['price'],
      supplierPrice: jsonString['price'],
    );
    item.quantity = jsonString['quantity'];
    item.selected = jsonString['isSelected'];
    return item;
  }
}
