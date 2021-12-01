import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spos_v2/models/ui/cart/seller_item.dart';
import 'package:spos_v2/providers/cart_entity.dart';
import 'package:spos_v2/providers/cart_line_entity.dart';
import 'package:spos_v2/widgets/cart/cart_line_item.dart';
import 'package:spos_v2/widgets/cart/seller_line_item.dart';

class ListItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartEntity>(context);
    final sellerIds = cart.orderLines.map((e) => e.sellerId).toSet().toList();
    final List<dynamic> items = [];
    sellerIds.forEach((sellerId) {
      final sellerItems = cart.orderLines
          .where((element) => element.sellerId == sellerId)
          .toList();
      items.add(
        SellerItem(
          sellerId,
          !sellerItems.any((element) => !element.selected),
        ),
      );
      items.addAll(sellerItems);
    });

    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) {
          final item = items[index];
          if (item is SellerItem) {
            return SellerLineItem(
              id: item.id,
              selected: item.selected,
              key: ValueKey(item.id),
            );
          } else {
            return ChangeNotifierProvider.value(
              value: item as CartLineEntity,
              child: CartLineItemView(key: ValueKey(item.id)),
            );
          }
        },
        itemCount: items.length,
      ),
    );
  }
}
