import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spos_v2/providers/cart_manager.dart';

class SellerLineItem extends StatelessWidget {
  final int id;
  final bool selected;

  const SellerLineItem({
    required this.id,
    required this.selected,
    key,
  });

  @override
  Widget build(BuildContext context) {
    final cartManager = Provider.of<CartManager>(context);
    void _toggleSeller(int sellerId, bool selected) {
      cartManager.updateSeller(sellerId, selected);
    }

    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8, right: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            value: selected,
            onChanged: (_) {
              _toggleSeller(id, !selected);
            },
          ),
          Text("Seller $id"),
        ],
      ),
    );
  }
}
