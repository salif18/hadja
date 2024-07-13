import "package:flutter/material.dart";
import "package:hadja_grish/components/splash.dart";
import "package:hadja_grish/providers/auth_provider.dart";
import "package:hadja_grish/providers/cart_provider.dart";
import "package:hadja_grish/providers/favorite_provider.dart";
import "package:hadja_grish/screens/auth/login_page.dart";
import 'package:provider/provider.dart';

void main() async {
  runApp(
    MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AuthProvider()),
      ChangeNotifierProvider(create: (context) => CartProvider()),
      ChangeNotifierProvider(create: (context) => FavoriteProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Longrish",
      home: MySplashScreen(),
    );
  }
}
