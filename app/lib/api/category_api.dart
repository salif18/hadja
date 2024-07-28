
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
const String urlServer = "http://10.0.2.2:8000/api";

class ServicesApiCategory{
  
Dio dio = Dio();
   //ajouter de categorie pour formulaire
 postCategories(data)async{
  
    var uri = "$urlServer/categories";
    return await dio.post(uri,
    data:data,
     options:Options(headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "Accept":"*/*",
            "Accept-Encoding":"gzip, deflate, br",
          },
    ));
  }
   //obtenir categorie pour formulaire
  getCategories()async{
    var uri = "$urlServer/categories";
    return await dio.get(uri,
     options:Options(headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "Accept":"*/*",
            "Accept-Encoding":"gzip, deflate, br",
          },
    ));
  }

  //modifier la categorie pour formulaire
 updateCategories(data, id)async{
    var uri = "$urlServer/categories/update/$id";
    return await dio.put(uri,
    data:data,
     options:Options(headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "Accept":"*/*",
            "Accept-Encoding":"gzip, deflate, br",
          },
    ));
  }

   //supprimer categorie 
  deleteCategories(id)async{
    var uri = "$urlServer/categories/delete/$id";
    return await dio.delete(uri,
     options:Options(headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "Accept":"*/*",
            "Accept-Encoding":"gzip, deflate, br",
          },
    ));
  }

  //messade d'affichage de reponse de la requette recus
  void showSnackBarSuccessPersonalized(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message,
          style: GoogleFonts.roboto(fontSize: 18)),
      backgroundColor: Colors.blue,
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
          style: GoogleFonts.roboto(fontSize: 18)),
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