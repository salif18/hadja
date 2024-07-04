import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hadja_grish/routes/roots.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 8),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const MyRoots())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 5, 191, 100),
      body: AnimatedSwitcher(
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        duration: const Duration(seconds: 5),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Center(
            key: UniqueKey(),
            child: Column(
              mainAxisAlignment:MainAxisAlignment.center,
              children: [
                Container(
                  height: 300, 
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image:const DecorationImage(
                      image: AssetImage("assets/logos/logo5.jpg"),
                      fit: BoxFit.contain,
                      )
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
