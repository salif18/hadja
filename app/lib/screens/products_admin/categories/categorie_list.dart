import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyCategoriList extends StatelessWidget {
  const MyCategoriList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 28)),
        title: Text("Categories",
            style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [Container()],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: const Color(0xFF4caf50),
            onPressed: () {
              _addCateShow(context);
            },
            child: const Icon(Icons.add, size: 28, color:  Colors.white,),
          ),
          const SizedBox(
            height: 80,
          )
        ],
      ),
    );
  }

  void _addCateShow(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Text("Ajouter categories",
                    style: GoogleFonts.roboto(
                        fontSize: 20, fontWeight: FontWeight.w400))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: "Nom de la categorie",
                            hintStyle: GoogleFonts.roboto(fontSize: 18),
                            prefixIcon: const Icon(Icons.category_rounded,
                                size: 20, color: Colors.purpleAccent)),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4caf50),
                              minimumSize: const Size(400,50)
                              ),
                          child: Text("Enregistrer",
                              style: GoogleFonts.roboto(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white)))
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
