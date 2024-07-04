import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeliveryList extends StatelessWidget {
  const DeliveryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle:true ,
        actions: [
          IconButton(onPressed: (){
            _addLivreurs(context);
          }, icon: const Icon(Icons.add, size:28)),
          const SizedBox(width: 20,)
        ],
        title: Text("Livreurs",style:GoogleFonts.roboto(fontSize:20,fontWeight:FontWeight.w500)),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back_ios_rounded, size:24)),
      ),
      body: SingleChildScrollView( 
        child:Column( 
          children: [
            Container()
          ],
        )
      ),
    );
  }

  _addLivreurs(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(15),
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: const BoxDecoration(),
            child: Column(
              children: [
                SizedBox(
                  height: 80,
                  child: Center(
                    child: Text("Ajouter livreurs",
                        style: GoogleFonts.roboto(
                            fontSize: 20, fontWeight: FontWeight.w400)),
                  ),
                ),
                _formulaires(context),
                const SizedBox(height: 15),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 5, 191, 100),
                        minimumSize: const Size(400,50)
                        ),
                    onPressed: () {},
                    child: Text("Enregistrer",
                        style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.white)))
              ],
            ),
          );
        });
  }

    _formulaires(BuildContext context) {
    return Form(
        child: Column(
      children: [
       
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: InputDecoration(
                hintText: "Nom ",
                hintStyle: GoogleFonts.roboto(fontSize: 18, color: Colors.grey),
                prefixIcon: const Icon(Icons.person_add, size: 20),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: InputDecoration(
                hintText: "Numero",
                hintStyle: GoogleFonts.roboto(fontSize: 18, color: Colors.grey),
                prefixIcon: const Icon(Icons.phone, size: 20),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: InputDecoration(
                hintText: "Email",
                hintStyle: GoogleFonts.roboto(fontSize: 18, color: Colors.grey),
                prefixIcon: const Icon(Icons.mail_rounded, size: 20),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: InputDecoration(
                hintText: "Password",
                hintStyle: GoogleFonts.roboto(fontSize: 18, color: Colors.grey),
                prefixIcon: const Icon(Icons.key, size: 20),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
        ),
       
      ],
    ));
  }
}