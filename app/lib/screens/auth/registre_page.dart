
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/auth_api.dart';
import 'package:hadja_grish/constants/app_size.dart';
import 'package:hadja_grish/models/user.dart';
import 'package:hadja_grish/providers/auth_provider.dart';
import 'package:hadja_grish/providers/user_provider.dart';
import 'package:hadja_grish/routes/roots.dart';
import 'package:hadja_grish/screens/auth/login_page.dart';
import 'package:provider/provider.dart';

class RegistrePage extends StatefulWidget {
  const RegistrePage({super.key});

  @override
  State<RegistrePage> createState() => _RegistrePageState();
}

class _RegistrePageState extends State<RegistrePage> {
  // CLE KEY FORMULAIRE
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  // API SERVICE AUTHENTIFICATION
  ServicesApiAuth api = ServicesApiAuth();

  //CHAMPS FORMULAIRES
  final _nom = TextEditingController();
  final _numero = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool isVisibility = true;

  @override
  void dispose() {
    _nom.dispose();
    _numero.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

// ENVOIE DES DONNEE VERS API SERVER
  Future<void> _sendToserver(BuildContext context) async {
  if (_globalKey.currentState!.validate()) {
    final data = {
      "name": _nom.text,
      "phone_number": _numero.text,
      "email": _email.text,
      "user_statut":"client",
      "password": _password.text
    };
    final provider = Provider.of<AuthProvider>(context, listen: false);
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
      final response = await api.postRegistreUser(data);
      final body = json.decode(response.body);
      // ignore: use_build_context_synchronously
      Navigator.pop(context); // Fermer le dialog

      if (response.statusCode == 201) {
        // ignore: use_build_context_synchronously
        provider.loginButton(body['token'], body["userId"].toString());
         ProfilModel user =  ProfilModel.fromJson(body['profil']);
         providerProfil.saveToLocalStorage(user);
           // ignore: use_build_context_synchronously
           Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const MyRoots()));
      } else {
        // ignore: use_build_context_synchronously
        api.showSnackBarErrorPersonalized(context, body["message"]);
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context); // Fermer le dialogue
      // ignore: use_build_context_synchronously
      api.showSnackBarErrorPersonalized(context, "Erreur: ${e.toString()}");
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: LayoutBuilder(
        builder: (context, constraints){
          return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: constraints.maxWidth * AppSizes.converValueToadapter(context,20)),
                child: Image.asset(
                  "assets/logos/logo1.jpg",
                  width: constraints.maxWidth * AppSizes.converValueToadapter(context,150),
                  height: constraints.maxWidth * AppSizes.converValueToadapter(context,150),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: constraints.maxWidth * AppSizes.converValueToadapter(context,8),top: constraints.maxWidth * AppSizes.converValueToadapter(context,20)),
                child: Text("Aw bissimilah",
                    style: GoogleFonts.aclonica(
                        fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context,25),
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              Padding(
                padding: EdgeInsets.only(top: constraints.maxWidth * AppSizes.converValueToadapter(context,15)),
                child: Container(
                  height: constraints.maxWidth * AppSizes.converValueToadapter(context,700),
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: constraints.maxWidth * AppSizes.converValueToadapter(context,50), 
                    left: constraints.maxWidth * AppSizes.converValueToadapter(context,15), 
                    right: constraints.maxWidth * AppSizes.converValueToadapter(context,15)),
                  decoration: BoxDecoration(
                      color: const Color(0xff1d1a30),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(constraints.maxWidth * AppSizes.converValueToadapter(context,50), constraints.maxWidth * AppSizes.converValueToadapter(context,20)),
                        topRight: Radius.elliptical(constraints.maxWidth * AppSizes.converValueToadapter(context,50), constraints.maxWidth * AppSizes.converValueToadapter(context,20)),
                      )),
                  child: Form(
                    key: _globalKey,
                    child: Column(children: [
                      Padding(
                        padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context,8)),
                        child: TextFormField(
                          controller: _nom,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer un nom';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              hintText: "Nom",
                              hintStyle: GoogleFonts.roboto(fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context,12)),
                              filled: true,
                              fillColor: const Color(0xfff0fcf3),
                              prefixIcon:
                                   Icon(Icons.person_3_outlined, size: constraints.maxWidth * AppSizes.converValueToadapter(context,24)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context,20)),
                                  borderSide: BorderSide.none)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context,8)),
                        child: TextFormField(
                          controller: _numero,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer un numero';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "Numero",
                              hintStyle: GoogleFonts.roboto(fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context,12)),
                              filled: true,
                              fillColor: const Color(0xfff0fcf3),
                              prefixIcon: Icon(Icons.phone_android_outlined,
                                  size: constraints.maxWidth * AppSizes.converValueToadapter(context,24)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context,20)),
                                  borderSide: BorderSide.none)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context,8)),
                        child: TextFormField(
                          controller: _email,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer un e-mail';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: "Email",
                              hintStyle: GoogleFonts.roboto(fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context,12)),
                              filled: true,
                              fillColor: const Color(0xfff0fcf3),
                              prefixIcon:
                                  Icon(Icons.mail_outline, size: constraints.maxWidth * AppSizes.converValueToadapter(context,24)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context,20)),
                                  borderSide: BorderSide.none)),
                        ),
                      ),
                      SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context,10)),
                      Padding(
                        padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context,8)),
                        child: TextFormField(
                          controller: _password,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer un mot de passe';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: isVisibility,
                          decoration: InputDecoration(
                              hintText: "Mot de passe",
                              hintStyle: GoogleFonts.roboto(fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context,12)),
                              filled: true,
                              fillColor: const Color(0xfff0fcf3),
                              prefixIcon:
                                  Icon(Icons.lock_outline, size: constraints.maxWidth * AppSizes.converValueToadapter(context,24)),
                                 suffixIcon: IconButton(
                        onPressed: (){
                             setState(() {
                        isVisibility = !isVisibility;
                      });
                        }, 
                        icon: Icon(isVisibility ? Icons.visibility_off:Icons.visibility)
                        ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context,20)),
                                  borderSide: BorderSide.none)),
                        ),
                      ),
                      SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context,25)),
                      Padding(
                        padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context,8)),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(constraints.maxWidth * AppSizes.converValueToadapter(context,400), constraints.maxWidth * AppSizes.converValueToadapter(context,40)),
                              backgroundColor: Colors.blueGrey,
                            ),
                            onPressed: () {
                              _sendToserver(context);
                            },
                            child: Text("Créer compte",
                                style: GoogleFonts.roboto(
                                    fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context,12), color: Colors.white))),
                      ),
                      Padding(
                        padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context,15)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Vous avez déjà un compte ?",
                              style: GoogleFonts.roboto(color: Colors.white,fontSize:constraints.maxWidth * AppSizes.converValueToadapter(context,14)),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()));
                                },
                                child: Text(
                                  "Login",
                                  style: GoogleFonts.roboto(
                                    fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context,14),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey,
                                  ),
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
