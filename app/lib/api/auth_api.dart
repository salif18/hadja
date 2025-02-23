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
    var url = "$domaineName/auth/login";
    return await http.post(Uri.parse(url), 
    body:jsonEncode(data), 
      headers: {
        "Content-Type": "application/json",
       "Authorization": "Bearer "
        
    });
  }

// fonction de creation de compte
  postRegistreUser(data)async{
     var url = "$domaineName/auth/registre";
      return await http.post(Uri.parse(url), 
    body:jsonEncode(data), 
      headers: {
        "Content-Type": "application/json",
         "Authorization": "Bearer "
    });
  
  }

  //fonction de deconnexion
  postLogoutTokenUser(token) async {
    var uri = "$domaineName/logout";
    return await http.post(Uri.parse(uri), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });
  }

  //fontion de mis a jour du profil
  postUpdateUserData(data, userId) async {
    var uri = "$domaineName/auth/update/$userId";
    return await http.post(
      Uri.parse(uri),
      body: jsonEncode(data),
      headers: {
        "Content-Type": "application/json",
       "Authorization": "Bearer "
      },
    );
  }

   //fontion de mis a jour du profil
  postUpdateUserProfil(data, id) async {
    var uri = "$domaineName/auth/profil/update/$id";
    return await http.post(
      Uri.parse(uri),
      body: jsonEncode(data),
      headers: {
       "Content-Type": "application/json",
       "Authorization": "Bearer "
      },
    );
  }

  //fontion de modification de passeword
  postUpdatePassword(data, userId) async {
    var uri = "$domaineName/auth/update_password/$userId";
    return await http.post(
      Uri.parse(uri),
      body: jsonEncode(data),
      headers: {
       "Content-Type": "application/json",
       "Authorization": "Bearer "
      },
    );
  }

  //fontion de reinitialisation de password
  postResetPassword(data) async {
    var uri = "$domaineName/reset/reset_password";
    return await http.post(
      Uri.parse(uri),
      body: jsonEncode(data),
      headers: {
        "Content-Type": "application/json",
       "Authorization": "Bearer "
      },
    );
  }

  //fontion de validation de mot de password reinitialiser
  postValidatePassword(data) async {
    var uri = "$domaineName/reset/validate_password";
    return await http.post(
      Uri.parse(uri),
      body: jsonEncode(data),
      headers: {
       "Content-Type": "application/json",
       "Authorization": "Bearer "
      },
    );
  }


   //suppression compte
  deleteUserTokenUserId(token) async {
    var uri = "$domaineName/auth/delete";
    return await http.post(Uri.parse(uri), headers: {
      "Content-Type": "application/json",
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
    ));
  }

   //message en cas d'erreur!
  void showSnackBarErrorPersonalized(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message,
          style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w400)),
      backgroundColor: Color.fromARGB(255, 32, 19, 54),
      duration: const Duration(seconds: 5),
    ));
  }
}