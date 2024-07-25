import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

const String urlServer = "http://10.0.2.2:8000/api";

class ServicesAPiProducts {
  Dio dio = Dio();
  //ajouter depense
  postNewProduct(data) async {
    var uri = "$urlServer/articles";
    return await dio.post(
      uri,
      data: data,
      options: Options(headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br",
      },)
    );
  }

  //ajouter depense
  updateProduct(data, id) async {
    var uri = "$urlServer/articles/update/$id";
    return await dio.put(
      uri,
      data: data,
      options: Options(headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br",
      },)
    );
  }

  //obtenir depenses
  getAllProducts() async {
    var uri = "$urlServer/get_article_with_galeries";
    return await http.get(
      Uri.parse(uri),
     headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br",
      });
  }

   //obtenir depenses
  getProductByCategorie(String data) async {
    var uri = "$urlServer/articles_by_categories/$data";
    return await http.get(
      Uri.parse(uri),
     headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br",
      });
  }


  //delete
  deleteProduct(id) async {
    var uri = "$urlServer/articles/delete/$id";
    return await http.delete(
      Uri.parse(uri),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br",
      },
    );
  }

  //messade d'affichage de reponse de la requette recus
  void showSnackBarSuccessPersonalized(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message,
          style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w500)),
      backgroundColor: const Color(0xFF292D4E),
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
          style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w500)),
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
