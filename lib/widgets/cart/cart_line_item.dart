import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spos_v2/providers/cart_line_entity.dart';
import 'package:spos_v2/providers/cart_manager.dart';
import 'package:spos_v2/widgets/quantity_input.dart';

class CartLineItemView extends StatelessWidget {
  CartLineItemView({key});

  @override
  Widget build(BuildContext context) {
    final item = Provider.of<CartLineEntity>(context);
    final cartManager = Provider.of<CartManager>(context);
    final formatter = NumberFormat.decimalPattern();

    void _toggleSelectItem(bool? isSelect) {
      cartManager.updateItem(item.id, null, isSelect);
    }

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.only(
            top: 12,
            bottom: 12,
            right: 12,
          ),
          color: Colors.white,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(value: item.selected, onChanged: _toggleSelectItem),
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                child: Image.network(
                  item.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name),
                    Text("Chỉ còn ${item.totalAvailable} sản phẩm"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              formatter.format(item.price),
                            )
                          ],
                        ),
                        QuantityInput(
                          quantity: item.quantity,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
