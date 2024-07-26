import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
const String domaineApi = "http://10.0.2.2:8000/api";
class ServicesApiOrders{

  Dio dio = Dio();
  //AJOUTER DES COMMANDES
  postOrders(data)async{
    var uri = "$domaineApi/orders";
    return await http.post(Uri.parse(uri),
    body: jsonEncode(data),
     headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "Accept":"*/*",
            "Accept-Encoding":"gzip, deflate, br",
          },
    );
  }

  //OBTENIR COMMANDES PAR USER
  getUserOrders(userId)async{
    var uri = "$domaineApi/orders/$userId";
    return await http.get(Uri.parse(uri),
     headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "Accept":"*/*",
            "Accept-Encoding":"gzip, deflate, br",
          },
    );
  }

   //OBTENIR COMMANDES LIVRER PAR LIVREUR
  getDeliveryOrdersLivery(userId)async{
    var uri = "$domaineApi/orders/livrer/$userId";
    return await http.get(Uri.parse(uri),
     headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "Accept":"*/*",
            "Accept-Encoding":"gzip, deflate, br",
          },
    );
  }

   //OBTENIR COMMANDES EN ATTENTE
  getAllOrdersEnCours()async{
    var uri = "$domaineApi/orders/status/En attente";
    return await http.get(Uri.parse(uri),
     headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "Accept":"*/*",
            "Accept-Encoding":"gzip, deflate, br",
          },
    );
  }

   //OBTENIR COMMANDES LIVRER
  getAllOrdersLivrer()async{
    var uri = "$domaineApi/orders/status/Livrer";
    return await http.get(Uri.parse(uri),
     headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "Accept":"*/*",
            "Accept-Encoding":"gzip, deflate, br",
          },
    );
  }


  //message en cas de succès!
  void showSnackBarSuccessPersonalized(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message,
          style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w500)),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: "",
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ));
  }

   //message en cas d'erreur!
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