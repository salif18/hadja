import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/http/domaine.dart';
import "package:http/http.dart" as http;

String urlServer = Domaine().domaine();

class ServicesApiDelibery{
  
   //obtenir categorie pour formulaire
  getAllDelibery()async{
    var uri = "$urlServer/livreurs";
    return await http.get(Uri.parse(uri),
     headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "Accept":"*/*",
            "Accept-Encoding":"gzip, deflate, br",
          },
    );
  }


  //delete
  deleteDelibery(id)async{
     var uri = "$urlServer/livreurs/delete/$id";
     return await http.delete(Uri.parse(uri),
     headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "Accept":"*/*",
            "Accept-Encoding":"gzip, deflate, br",
          },
     );
  }

  //delete
  updateDelibery(data,id)async{
     var uri = "$urlServer/livreurs/update/$id";
     return await http.put(Uri.parse(uri),
     body:jsonEncode(data),
     headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "Accept":"*/*",
            "Accept-Encoding":"gzip, deflate, br",
          },
     );
  }

  //messade d'affichage de reponse de la requette recus
  void showSnackBarSuccessPersonalized(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message,
          style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w400)),
      backgroundColor: const Color.fromARGB(255, 108, 255, 133),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
          label: "",
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }),
    ));
  }

//messade d'affichage des reponse de la requette en cas dechec
  void showSnackBarErrorPersonalized(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message,
          style: GoogleFonts.roboto(fontSize: 16,fontWeight: FontWeight.w400)),
      backgroundColor: const Color.fromARGB(255, 255, 35, 19),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: "",
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ));
  }
}