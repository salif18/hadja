
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/http/domaine.dart';
import 'package:http/http.dart' as http;

   const String domaineName = AppDomaine.domaine;

class ServicesAPiProducts {
  Dio dio = Dio();
  //ajouter depense
  postNewProduct(data) async {
    var uri = "$domaineName/articles";
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
    var uri = "$domaineName/articles/update/$id";
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

  //obtenir depenses
  getAllProducts() async {
    var uri = "$domaineName/get_article_with_galeries";
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
    var uri = "$domaineName/articles_by_categories/$data";
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
    var uri = "$domaineName/articles/delete/$id";
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
          style: GoogleFonts.roboto(fontSize: 16,fontWeight: FontWeight.w400)),
      backgroundColor:const Color.fromARGB(255, 101, 255, 122),
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
