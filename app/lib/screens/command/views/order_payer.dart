import 'package:flutter/material.dart';
import 'package:hadja_grish/screens/command/widgets/card_orders_admin.dart';

class OrderPaid extends StatefulWidget {
  const OrderPaid({super.key});

  @override
  State<OrderPaid> createState() => _OrderPaidState();
}

class _OrderPaidState extends State<OrderPaid> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body:const SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: CardOrder(),
              ),
          ],
        ),
      ),
    );
  }
}