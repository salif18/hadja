// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/auth_api.dart';
import 'package:hadja_grish/constants/app_size.dart';
import 'package:hadja_grish/models/user.dart';
import 'package:hadja_grish/providers/auth_provider.dart';
import 'package:hadja_grish/providers/user_provider.dart';
import 'package:hadja_grish/routes/roots.dart';
import 'package:hadja_grish/screens/auth/registre_page.dart';
import 'package:hadja_grish/screens/auth/reset_password.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

// CLE KEY POUR LE FORMULAIRE
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  // API SERVICE AUTHENTIFICATION
  ServicesApiAuth api = ServicesApiAuth();
  // CHAMPS FORMULAIRE
  final _contacts = TextEditingController();
  final _password = TextEditingController(); 
  bool isVisibility = true;

  @override 
  void dispose(){
    _contacts.dispose(); 
    _password.dispose();
    super.dispose();
  }

// ENVOIE DES DONNEES VERS API SERVER
  Future<void> _sendToserver(BuildContext context) async {
  if (_globalKey.currentState!.validate()) {
    final data = {
      "contacts": _contacts.text,
      "password": _password.text
    };
     final providerAuth = Provider.of<AuthProvider>(context, listen: false);
      final providerProfil =
          Provider.of<UserInfosProvider>(context, listen: false);
    try {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
      final response = await api.postLoginUser(data);
      final body = jsonDecode(response.body);
      print(body);
      Navigator.pop(context); // Fermer le dialog

      if (response.statusCode == 200) {
         ProfilModel user =  ProfilModel.fromJson(body['profil']);
         print(user);
         providerAuth.loginButton(body['token'], body["userId"].toString());
         providerProfil.saveToLocalStorage(user);
           Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const MyRoots()));
      } else{
         api.showSnackBarErrorPersonalized(context, body["message"]);
      }
    } catch (e) {
      Navigator.pop(context); // Fermer le dialog
      api.showSnackBarErrorPersonalized(context, e.toString());
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: LayoutBuilder(
        builder: (context , constraints){
          return  SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:  EdgeInsets.only(top: constraints.maxWidth * AppSizes.converValueToadapter(context, 50)),
                child: Image.asset(
                  "assets/logos/logo4.jpg",
                  width: constraints.maxWidth * AppSizes.converValueToadapter(context, 150),
                  height: constraints.maxWidth * AppSizes.converValueToadapter(context, 150),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: constraints.maxWidth * AppSizes.converValueToadapter(context, 8),
                  top: constraints.maxWidth * AppSizes.converValueToadapter(context,20),
                  // bottom: constraints.maxWidth * AppSizes.converValueToadapter(context, 20)
                  ),
                child: Text("Aw bissimilah",
                    style: GoogleFonts.aclonica(
                        fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 25),
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              Padding(
                padding: EdgeInsets.only(top: constraints.maxWidth * AppSizes.converValueToadapter(context, 15),),
                child: Container(
                  height: constraints.maxWidth * AppSizes.converValueToadapter(context, 620),
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: constraints.maxWidth * AppSizes.converValueToadapter(context, 50), 
                    left: constraints.maxWidth * AppSizes.converValueToadapter(context, 15), 
                    right: constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
                  decoration: BoxDecoration(
                      color: const Color(0xff1d1a30),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(constraints.maxWidth * AppSizes.converValueToadapter(context, 50), constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
                        topRight: Radius.elliptical(constraints.maxWidth * AppSizes.converValueToadapter(context, 50), constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
                      )),
                  child: Form(
                    key: _globalKey,
                    child: Column(children: [
                      Padding(
                        padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
                        child: TextFormField(
                          controller: _contacts,
                           validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer un numero ou un e-mail';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: "Numero ou e-mail",
                              hintStyle: GoogleFonts.roboto(fontSize:constraints.maxWidth * AppSizes.converValueToadapter(context, 12)),
                              filled: true,
                              fillColor: const Color(0xfff0fcf3),
                              prefixIcon: Icon(Icons.person_2_outlined, size: constraints.maxWidth * AppSizes.converValueToadapter(context, 24)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
                                  borderSide: BorderSide.none)),
                        ),
                      ),
                      SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context, 10)),
                      Padding(
                        padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
                        child: TextFormField(
                          controller: _password,
                          
                           validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer votre mot de passe';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: isVisibility,
                          decoration: InputDecoration(
                              hintText:"Mot de passe",
                              hintStyle: GoogleFonts.roboto(fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 12)),
                              filled: true,
                              fillColor: const Color(0xfff0fcf3),
                             suffixIcon: IconButton(
                        onPressed: (){
                             setState(() {
                        isVisibility = !isVisibility;
                      });
                        }, 
                        icon: Icon(isVisibility ? Icons.visibility_off:Icons.visibility)
                        ),
                        prefixIcon: Icon(Icons.lock_outline,size: constraints.maxWidth * AppSizes.converValueToadapter(context, 24)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
                                  borderSide: BorderSide.none)),
                        ),
                      ),
                      SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context, 5)),
                      Padding(
                        padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ResetToken()));
                                },
                                child: Text(
                                  "Mot de passe oublié ?",
                                  style: GoogleFonts.roboto(
                                      fontSize:constraints.maxWidth * AppSizes.converValueToadapter(context, 12), color: Colors.blueGrey,),
                                ))
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize:  Size(constraints.maxWidth * AppSizes.converValueToadapter(context, 400), constraints.maxWidth * AppSizes.converValueToadapter(context, 40)),
                              backgroundColor:
                                  Colors.blueGrey,
                            ),
                            onPressed: () {
                              _sendToserver(context);
                            },
                            child: Text("Se connecter",
                                style: GoogleFonts.roboto(
                                    fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 12), color: Colors.white))),
                      ),
                      Padding(
                        padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Vous n'avez pas de compte ?",
                              style: GoogleFonts.roboto(fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 14),color: Colors.white),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const RegistrePage()));
                                },
                                child: Text(
                                  "Créer",
                                  style: GoogleFonts.roboto(
                                      fontSize:constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey,),
                                ))
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              )
            ],
          ),
        );
        },
       
      ),
    );
  }
}
