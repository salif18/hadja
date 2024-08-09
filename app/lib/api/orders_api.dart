import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hadja_grish/http/domaine.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
String domaineApi = Domaine().domaine();
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

  //OBTENIR TOUS LES COMMANDES
  getAllOrders() async {
    var uri = "$domaineApi/orders";
    return await http.get(
      Uri.parse(uri),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br",
      },
    );
  }

   //OBTENIR TOUS LES COMMANDES LIVRER
  getAllOrdersyDelivery() async {
    var uri = "$domaineApi/orders/delibery";
    return await http.get(
      Uri.parse(uri),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br",
      },
    );
  }

//OBTENIR UN SEUL ARTICLE
  getOneProduct(data) async {
    var uri = "$domaineApi/orders/{}";
    return await http.get(
      Uri.parse(uri),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br",
      },
    );
  }

  //MIS A JOURS DU STATUT DE LIVRAISON
  updateStatutOrders(data) async {
    var uri = "$domaineApi/orders/statut/{}";
    return await http.put(
      Uri.parse(uri),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br",
      },
    );
  }

  //SUPPRIMER UNE COMMANDE
  deleteOrder(data) async {
    var uri = "$domaineApi/orders/{}";
    return await http.delete(
      Uri.parse(uri),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br",
      },
    );
  }

//OBTENIR LES COORDONNEES DE LOCALISATION DUNE COMMANDE
  getOneOrderPositions(id)async{
    var uri = "$domaineApi/orders/positions/$id";
    return await http.get(Uri.parse(uri),
     headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "Accept":"*/*",
            "Accept-Encoding":"gzip, deflate, br",
          },
    );
  }

//AJOUTER UN LIVREUR AU COMMANDES
  postLiveryIdToOrders(data,id)async{
    var uri = "$domaineApi/orders/livreurId/$id";
    return await http.put(Uri.parse(uri),
    body: jsonEncode(data),
     headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "Accept":"*/*",
            "Accept-Encoding":"gzip, deflate, br",
          },
    );
  }

  //OBTENIR COMMANDES PAR USER
  updateOrderPositions(data,id)async{
    var uri = "$domaineApi/orders/positions/$id";
    return await http.put(Uri.parse(uri),
    body:jsonEncode(data),
     headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "Accept":"*/*",
            "Accept-Encoding":"gzip, deflate, br",
          },
    );
  }

   //OBTENIR COMMANDES LIVRER PAR LIVREUR
  getDeliveryOrdersLivrer(userId)async{
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
          style: GoogleFonts.roboto(fontSize: 16,fontWeight: FontWeight.w400)),
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