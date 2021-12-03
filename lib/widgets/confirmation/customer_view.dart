import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spos_v2/channel/cart_delegate.dart';
import 'package:spos_v2/providers/customer.dart';
import 'package:spos_v2/theme/apollo_text.dart';

class CustomerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final customer = Provider.of<Customer>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          color: Colors.grey.shade200,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: const Text(
            "THÔNG TIN KHÁCH HÀNG",
            style: ApolloText.subtitle4,
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        customer.name!,
                        style: ApolloText.subtitle4,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        customer.phone!,
                        style: ApolloText.body1,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        customer.fullAddress!,
                        style: ApolloText.body1,
                      ),
                    ),
                  ],
                ),
                height: 64,
              ),
              IconButton(
                  onPressed: () {
                    CartDelegate.goToCustomer();
                  },
                  icon: const Icon(Icons.navigate_next))
            ],
          ),
        )
      ],
    );
  }
}
