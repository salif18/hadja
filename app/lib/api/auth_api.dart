import "dart:convert";

import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hadja_grish/http/domaine.dart";
import "package:http/http.dart" as http;
import 'package:dio/dio.dart';


 const String domaineName = AppDomaine.domaine;

class ServicesApiAuth{
  Dio dio = Dio();
  // fonction de connection
  postLoginUser(data)async{
    var url = "$domaineName/login";
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
     var url = "$domaineName/registre";
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
    var uri = "$domaineName/logout";
    return await http.post(Uri.parse(uri), headers: {
      "Content-Type": "application/json; charset=UTF-8",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate, br",
      "Authorization": "Bearer $token"
    });
  }

  //fontion de mis a jour du profil
  postUpdateUserData(data, userId) async {
    var uri = "$domaineName/update/$userId";
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

   //fontion de mis a jour du profil
  postUpdateUserProfil(data, id) async {
    var uri = "$domaineName/profil/update/$id";
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
    var uri = "$domaineName/update_password/$userId";
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
    var uri = "$domaineName/reset_password";
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
    var uri = "$domaineName/validate_password";
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


   //suppression compte
  deleteUserTokenUserId(token) async {
    var uri = "$domaineName/delete";
    return await http.post(Uri.parse(uri), headers: {
      "Content-Type": "application/json; charset=UTF-8",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate, br",
      "Authorization": "Bearer $token"
    });
  }


  //message en cas de succès!
  void showSnackBarSuccessPersonalized(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message,
          style: GoogleFonts.roboto(fontSize: 16,fontWeight: FontWeight.w400)),
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
          style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w400)),
      backgroundColor: Color.fromARGB(255, 32, 19, 54),
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