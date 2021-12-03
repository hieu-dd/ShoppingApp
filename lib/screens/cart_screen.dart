import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spos_v2/channel/cart_delegate.dart';
import 'package:spos_v2/providers/cart_manager.dart';
import 'package:spos_v2/screens/confirmation_screen.dart';
import 'package:spos_v2/theme/apollo_color.dart';
import 'package:spos_v2/widgets/cart/list_items.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartManager = Provider.of<CartManager>(context, listen: false);
    final apolloColor = Provider.of<ApolloColor>(context);

    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("Cart"),
        actions: [
          IconButton(
            onPressed: () {
              CartDelegate.goToCustomer();
            },
            icon: const Icon(Icons.delete),
          )
        ],
      ),
      body: FutureBuilder<void>(
        initialData: null,
        future: cartManager.refreshCart(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Consumer<CartManager>(
            builder: (ctx, cartManager, _) {
              final formatter = NumberFormat.decimalPattern();
              final cart = cartManager.cart;
              if (cart == null || cart.orderLines.isEmpty) {
                return const Center();
              }
              return Column(
                children: [
                  ChangeNotifierProvider.value(
                    value: cart,
                    child: ListItems(),
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
                          formatter.format(cart.grandTotal),
                          style: TextStyle(
                            color: apolloColor.primaryColor500,
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(ConfirmationScreen.routeName);
                            },
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
