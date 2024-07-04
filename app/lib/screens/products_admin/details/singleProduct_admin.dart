import 'package:flutter/material.dart';

class SingleProductAdmin extends StatefulWidget {
  const SingleProductAdmin({super.key});

  @override
  State<SingleProductAdmin> createState() => _SingleProductAdminState();
}

class _SingleProductAdminState extends State<SingleProductAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(),
    );
  }
}