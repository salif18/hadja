import 'package:flutter/material.dart';

class OrderNoPaid extends StatefulWidget {
  const OrderNoPaid({super.key});

  @override
  State<OrderNoPaid> createState() => _OrderNoPaidState();
}

class _OrderNoPaidState extends State<OrderNoPaid> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color:Colors.red
    );
  }
}