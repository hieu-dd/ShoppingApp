import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spos_v2/providers/cart_manager.dart';
import 'package:spos_v2/widgets/cart/cart_line_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("Cart"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete),
          )
        ],
      ),
      body: FutureBuilder<void>(
        initialData: null,
        future: Provider.of<CartManager>(context, listen: false).refreshCart(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Consumer<CartManager>(
            builder: (ctx, cartManager, _) {
              final cart = cartManager.cart;
              if (cart == null) {
                return const Center();
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final item = cart.orderLines[index];
                        return ChangeNotifierProvider.value(
                          value: item,
                          child: CartLineItemView(key: ValueKey(item.id)),
                        );
                      },
                      itemCount: cart.orderLines.length,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            top: BorderSide(color: Colors.grey.shade300))),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "10.300.000 đ",
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text("Tiếp tục"),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
