import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        const Duration(seconds: 5),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const MyRoots())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedSwitcher(
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        duration: const Duration(seconds: 5),
        child: Container(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              key: UniqueKey(),
              children: [
                Container(
                  height: 400,
                  width: 400,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: AssetImage("assets/logos/logo3.jpg"),
                        fit: BoxFit.contain,
                      )),
                ),
                Container(
                  width: double.infinity,
                  height: 300,
                  padding: const EdgeInsets.only(bottom:20),
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.elliptical(160, 100),
                          topRight: Radius.elliptical(160, 100))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("from",
                          style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: const Color.fromARGB(255, 160, 105, 23))),
                      const SizedBox(height: 5),
                      Text("(( KSoft ))",
                          style: GoogleFonts.aBeeZee(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 160, 105, 23))),
                      const SizedBox(height: 5),
                      Text("Konaté Software",
                          style: GoogleFonts.aboreto(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: const Color.fromARGB(255, 160, 105, 23))),
                    ],
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
