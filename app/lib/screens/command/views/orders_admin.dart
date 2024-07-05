import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/screens/command/views/order_delivery.dart';
import 'package:hadja_grish/screens/command/views/order_en_cours.dart';
import 'package:hadja_grish/screens/command/views/order_non_payer.dart';
import 'package:hadja_grish/screens/command/views/order_payer.dart';

class AdminOders extends StatefulWidget {
  const AdminOders({super.key});

  @override
  State<AdminOders> createState() => _AdminOdersState();
}

class _AdminOdersState extends State<AdminOders> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Commandes",
                style: GoogleFonts.roboto(
                    fontSize: 20, fontWeight: FontWeight.w400)),
            centerTitle: true,
            toolbarHeight: 80,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 24)),
            bottom: TabBar(
                isScrollable: true,
                indicatorColor: const Color.fromARGB(255, 5, 191, 100),
                indicatorWeight: 2.3,
                tabs: [
                  Tab(
                    child: Text("Payé",
                        style: GoogleFonts.roboto(
                            fontSize: 20, fontWeight: FontWeight.w400)),
                  ),
                  Tab(
                    child: Text("Non payé",
                        style: GoogleFonts.roboto(
                            fontSize: 20, fontWeight: FontWeight.w400)),
                  ),
                  Tab(
                    child: Text("En cours",
                        style: GoogleFonts.roboto(
                            fontSize: 20, fontWeight: FontWeight.w400)),
                  ),
                  Tab(
                    child: Text("Livré",
                        style: GoogleFonts.roboto(
                            fontSize: 20, fontWeight: FontWeight.w400)),
                  ),
                ]),
          ),
          body: const TabBarView(
            children: [
              Tab(child: OrderPaid()),
              Tab(child: OrderNoPaid()),
              Tab(child: OrderWait()),
              Tab(child: OrderDelivery()),
            ],
          )),
    );
  }
}
