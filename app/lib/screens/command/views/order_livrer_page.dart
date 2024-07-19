import 'package:flutter/material.dart';
import 'package:hadja_grish/screens/command/widgets/card_orders_admin.dart';

class OrderLivrer extends StatefulWidget {
  const OrderLivrer({super.key});

  @override
  State<OrderLivrer> createState() => _OrderLivrerState();
}

class _OrderLivrerState extends State<OrderLivrer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body:const SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: CardOrder(),
              ),
          ],
        ),
      ),
    );
  }
}