import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/constants/app_size.dart';
import 'package:hadja_grish/screens/admin/order_en_cours_page.dart';
import 'package:hadja_grish/screens/admin/order_livrer_page.dart';

class AdminOders extends StatefulWidget {
  const AdminOders({super.key});

  @override
  State<AdminOders> createState() => _AdminOdersState();
}

class _AdminOdersState extends State<AdminOders> {
 

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: LayoutBuilder(
        builder:(context,constraints){
          return Scaffold(
            appBar: AppBar(
              title: Text("Commandes",
                  style: GoogleFonts.roboto(
                      fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 16), fontWeight: FontWeight.w400)),
              centerTitle: true,
              toolbarHeight: constraints.maxWidth * AppSizes.converValueToadapter(context, 50),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios_new_rounded, size: constraints.maxWidth * AppSizes.converValueToadapter(context, 24))),
              bottom: TabBar(
                  isScrollable: true,
                  indicatorColor: const Color.fromARGB(255, 5, 191, 100),
                  indicatorWeight: 4.3,
                  labelPadding: EdgeInsets.only(
                    left: constraints.maxWidth * AppSizes.converValueToadapter(context, 50), 
                    right: constraints.maxWidth * AppSizes.converValueToadapter(context, 50)),
                  tabs: [
                    Tab(
                      child: Text("En attente",
                          style: GoogleFonts.roboto(
                              fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 14), fontWeight: FontWeight.w400)),
                    ),
                    Tab(
                      child: Text("Livré",
                          style: GoogleFonts.roboto(
                              fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 14), fontWeight: FontWeight.w400)),
                    ),
                  ]),
            ),
            body:  TabBarView(
              children: [
                Tab(child: OrderEnCours(constraints:constraints)),
                Tab(child: OrderLivrer(constraints:constraints)),
              ],
            ));
        }
      ),
    );
  }
}
