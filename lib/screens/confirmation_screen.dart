import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spos_v2/providers/cart_manager.dart';
import 'package:spos_v2/providers/customer.dart';
import 'package:spos_v2/theme/apollo_text.dart';
import 'package:spos_v2/widgets/confirmation/confirmation_line_item_view.dart';
import 'package:spos_v2/widgets/confirmation/customer_view.dart';

class ConfirmationScreen extends StatelessWidget {
  static const routeName = "/confirmation-screen";

  const ConfirmationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartManager = Provider.of<CartManager>(context);
    final customer = Provider.of<Customer>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirmation screen"),
      ),
      body: Column(
        children: [
          if (customer.hasCustomer) CustomerView(),
          if (cartManager.cart?.hasSelectItems ?? false)
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: const Text(
                        "DANH SÁCH SẢN PHẨM",
                        style: ApolloText.subtitle4,
                      ),
                    );
                  }
                  final item = cartManager.cart!.selectOrderLines[index - 1];
                  return ConfirmationLineItemView(
                    item: item,
                    key: ValueKey(item.id),
                  );
                },
                itemCount: cartManager.cart!.selectOrderLines.length + 1,
              ),
            )
        ],
      ),
    );
  }
}
