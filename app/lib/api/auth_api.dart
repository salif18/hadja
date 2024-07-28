import "dart:convert";

import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:http/http.dart" as http;
import 'package:dio/dio.dart';
const String domaineApi = "http://10.0.2.2:8000/api";

class ServicesApiAuth{
  Dio dio = Dio();
  // fonction de connection
  postLoginUser(data)async{
    var url = "$domaineApi/login";
    return await http.post(Uri.parse(url), 
    body:jsonEncode(data), 
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br",
    });
  }

// fonction de creation de compte
  postRegistreUser(data)async{
     var url = "$domaineApi/registre";
      return await http.post(Uri.parse(url), 
    body:jsonEncode(data), 
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br",
    });
  
  }

  //fonction de deconnexion
  postLogoutTokenUser(token) async {
    var uri = "$domaineApi/logout";
    return await http.post(Uri.parse(uri), headers: {
      "Content-Type": "application/json; charset=UTF-8",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate, br",
      "Authorization": "Bearer $token"
    });
  }

  //fontion de mis a jour du profil
  postUpdateUserData(data, userId) async {
    var uri = "$domaineApi/update/$userId";
    return await http.post(
      Uri.parse(uri),
      body: jsonEncode(data),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br",
      },
    );
  }

  //fontion de modification de passeword
  postUpdatePassword(data, userId) async {
    var uri = "$domaineApi/update_password/$userId";
    return await http.post(
      Uri.parse(uri),
      body: jsonEncode(data),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br",
      },
    );
  }

  //fontion de reinitialisation de password
  postResetPassword(data) async {
    var uri = "$domaineApi/reset_password";
    return await http.post(
      Uri.parse(uri),
      body: jsonEncode(data),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br",
      },
    );
  }

  //fontion de validation de mot de password reinitialiser
  postValidatePassword(data) async {
    var uri = "$domaineApi/validate_password";
    return await http.post(
      Uri.parse(uri),
      body: jsonEncode(data),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br",
      },
    );
  }

  //suppression de votre compte
  deleteCompte(id) async {
    var uri = "$domaineApi/user/$id";
    return await http.delete(Uri.parse(uri), headers: {
      "Content-Type": "application/json; charset=UTF-8",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate, br",
      
    });
  }

  //message en cas de succès!
  void showSnackBarSuccessPersonalized(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message,
          style: GoogleFonts.roboto(fontSize: 18,)),
      backgroundColor: const Color.fromARGB(255, 109, 204, 112),
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