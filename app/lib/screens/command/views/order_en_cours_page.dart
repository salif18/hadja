import 'package:flutter/material.dart';
import 'package:hadja_grish/screens/command/widgets/card_orders_admin.dart';

class OrderEnCours extends StatefulWidget {
  const OrderEnCours({super.key});

  @override
  State<OrderEnCours> createState() => _OrderEnCoursState();
}

class _OrderEnCoursState extends State<OrderEnCours> {
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