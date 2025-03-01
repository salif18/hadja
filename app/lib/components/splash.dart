import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/constants/app_size.dart';
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
      backgroundColor: Colors.grey[200],
      body: LayoutBuilder(
        builder: (context, constraints){
          return AnimatedSwitcher(
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          duration: const Duration(seconds: 5),
          child: Container(
            // padding: EdgeInsets.only(top: constraints.maxWidth * AppSizes.converValueToadapter(context, 50)),
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                key: UniqueKey(),
                children: [
                  SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context, 300)),
                  Container(
                    height: constraints.maxWidth * AppSizes.converValueToadapter(context, 100),
                    width: constraints.maxWidth * AppSizes.converValueToadapter(context, 100),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
                        image: const DecorationImage(
                          image: AssetImage("assets/logos/logo1.jpg"),
                          fit: BoxFit.fill,
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical:constraints.maxWidth * AppSizes.converValueToadapter(context, 10) ),
                    child: Text("Hadja Store",style:GoogleFonts.allison(
                      fontSize:constraints.maxWidth * AppSizes.converValueToadapter(context, 20),
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey
                      ))),
                  Expanded(
                    
                    child: Container(
                      width: constraints.maxWidth,
                      // height: constraints.maxWidth * AppSizes.converValueToadapter(context, 400),
                      padding: EdgeInsets.only(bottom:constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
                      decoration:BoxDecoration(
                          // color: Colors.black,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.elliptical(constraints.maxWidth * AppSizes.converValueToadapter(context, 160), constraints.maxWidth * AppSizes.converValueToadapter(context, 100)),
                              topRight: Radius.elliptical(160, constraints.maxWidth * AppSizes.converValueToadapter(context, 100)))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("from",
                              style: GoogleFonts.roboto(
                                  fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 12),
                                  color: Colors.blueGrey)),
                          SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context, 5)),
                          Text("(( KSoft ))",
                              style: GoogleFonts.aBeeZee(
                                  fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 10),
                                  fontWeight: FontWeight.bold,
                                  color:  Colors.blueGrey)),
                          SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context, 5)),
                          Text("Konaté Software",
                              style: GoogleFonts.aboreto(
                                  fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context,10),
                                  fontWeight: FontWeight.normal,
                                  color:  Colors.blueGrey)),
                        ],
                      ),
                    ),
                  )
                ]),
          ),
        );
        },
      ),
    );
  }
}
