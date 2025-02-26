import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hadja_grish/http/domaine.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
const String domaineName = AppDomaine.domaine;
class ServicesApiOrders{

  Dio dio = Dio();
  //AJOUTER DES COMMANDES
  postOrders(data)async{
    var uri = "$domaineName/orders";
    return await http.post(Uri.parse(uri),
    body: jsonEncode(data),
     headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer "
          },
    );
  }

  //OBTENIR COMMANDES PAR USER
  getUserOrders(userId)async{
    var uri = "$domaineName/orders/$userId";
    return await http.get(Uri.parse(uri),
     headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer "
          },
    );
  }

  //OBTENIR TOUS LES COMMANDES
  getAllOrders() async {
    var uri = "$domaineName/orders";
    return await http.get(
      Uri.parse(uri),
      headers: {
       "Content-Type": "application/json",
            "Authorization": "Bearer "
      },
    );
  }

   //OBTENIR TOUS LES COMMANDES LIVRER
  getAllOrdersyDelivery() async {
    var uri = "$domaineName/orders/delibery";
    return await http.get(
      Uri.parse(uri),
      headers: {
        "Content-Type": "application/json",
            "Authorization": "Bearer "
      },
    );
  }

//OBTENIR UN SEUL ARTICLE
  getOneOrder(id) async {
    var uri = "$domaineName/orders/one/$id";
    return await http.get(
      Uri.parse(uri),
      headers: {
       "Content-Type": "application/json",
            "Authorization": "Bearer "
      },
    );
  }

  //MIS A JOURS DU STATUT DE LIVRAISON
  updateStatutOrders(data) async {
    var uri = "$domaineName/orders/statut/{}";
    return await http.put(
      Uri.parse(uri),
      headers: {
       "Content-Type": "application/json",
            "Authorization": "Bearer "
      },
    );
  }

  //SUPPRIMER UNE COMMANDE
  deleteOrder(data) async {
    var uri = "$domaineName/orders/{}";
    return await http.delete(
      Uri.parse(uri),
      headers: {
        "Content-Type": "application/json",
            "Authorization": "Bearer "
      },
    );
  }

//OBTENIR LES COORDONNEES DE LOCALISATION DUNE COMMANDE
  getOneOrderPositions(id)async{
    var uri = "$domaineName/orders/positions/$id";
    return await http.get(Uri.parse(uri),
     headers: {
           "Content-Type": "application/json",
            "Authorization": "Bearer "
          },
    );
  }

//AJOUTER UN LIVREUR AU COMMANDES
  postLiveryIdToOrders(data,id)async{
    var uri = "$domaineName/orders/livreurId/$id";
    return await http.put(Uri.parse(uri),
    body: jsonEncode(data),
     headers: {
           "Content-Type": "application/json",
            "Authorization": "Bearer "
          },
    );
  }

  //OBTENIR COMMANDES PAR USER
  updateOrderPositions(data,id)async{
    var uri = "$domaineName/orders/positions/$id";
    return await http.put(Uri.parse(uri),
    body:jsonEncode(data),
     headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer "
          },
    );
  }

   //OBTENIR COMMANDES LIVRER PAR LIVREUR
  getDeliveryOrdersLivrer(userId)async{
    var uri = "$domaineName/orders/livrer/for/$userId";
    return await http.get(Uri.parse(uri),
     headers: {
           "Content-Type": "application/json",
            "Authorization": "Bearer "
          },
    );
  }

   //OBTENIR COMMANDES EN ATTENTE
  getAllOrdersEnCours()async{
    var uri = "$domaineName/orders/status/${"En attente"}";
    return await http.get(Uri.parse(uri),
     headers: {
           "Content-Type": "application/json",
            "Authorization": "Bearer "
          },
    );
  }

   //OBTENIR COMMANDES LIVRER
  getAllOrdersLivrer()async{
    var uri = "$domaineName/orders/status/${"Livrer"}";
    return await http.get(Uri.parse(uri),
     headers: {
           "Content-Type": "application/json",
            "Authorization": "Bearer "
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
      
    ));
  }

   //message en cas d'erreur!
  void showSnackBarErrorPersonalized(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message,
          style: GoogleFonts.roboto(fontSize: 16,fontWeight: FontWeight.w400)),
      backgroundColor: const Color.fromARGB(255, 255, 35, 19),
      duration: const Duration(seconds: 5),
     
    ));
  }
}