import 'package:flutter/material.dart';

class QuantityInput extends StatelessWidget {
  final int quantity;

  const QuantityInput({
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          border: Border.all(color: Colors.grey.shade300),
        ),
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                iconSize: 16,
                onPressed: () {},
                icon: const Icon(
                  Icons.remove,
                )),
            Text(quantity.toString()),
            IconButton(
                iconSize: 16,
                onPressed: () {},
                icon: const Icon(
                  Icons.add,
                ))
          ],
        ));
  }
}
