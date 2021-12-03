import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spos_v2/providers/cart_line_entity.dart';

class ConfirmationLineItemView extends StatelessWidget {
  final CartLineEntity item;

  ConfirmationLineItemView({required this.item, key});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.decimalPattern();

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.only(
            top: 12,
            bottom: 12,
            right: 12,
            left: 12,
          ),
          color: Colors.white,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    Column(
                      children: [
                        Text(
                          formatter.format(item.price),
                        )
                      ],
                    ),
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
