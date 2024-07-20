
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/auth_api.dart';
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
      "user_statut":"isClient",
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
      final res = await api.postRegistreUser(data);
      final body = res.data;
      // ignore: use_build_context_synchronously
      Navigator.pop(context); // Fermer le dialog

      if (res.statusCode == 201) {
        // ignore: use_build_context_synchronously
        provider.loginButton(body['token'], body["userId"].toString());
        ModelUser user = ModelUser.fromJson(body['profil']);
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
      Navigator.pop(context); // Fermer le dialog
      // ignore: use_build_context_synchronously
      api.showSnackBarErrorPersonalized(context, e.toString());
    
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Image.asset(
                "assets/logos/logo4.jpg",
                width: 200,
                height: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("Aw bissimilah",
                  style: GoogleFonts.aclonica(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 29.0),
              child: Container(
                height: 700,
                width: double.infinity,
                padding: const EdgeInsets.only(top: 50, left: 15, right: 15),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.elliptical(50, 20),
                      topRight: Radius.elliptical(50, 20),
                    )),
                child: Form(
                  key: _globalKey,
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                            hintStyle: GoogleFonts.roboto(fontSize: 20),
                            filled: true,
                            fillColor: const Color(0xfff0fcf3),
                            prefixIcon:
                                const Icon(Icons.person_3_outlined, size: 28),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                            hintStyle: GoogleFonts.roboto(fontSize: 20),
                            filled: true,
                            fillColor: const Color(0xfff0fcf3),
                            prefixIcon: const Icon(Icons.phone_android_outlined,
                                size: 28),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                            hintStyle: GoogleFonts.roboto(fontSize: 20),
                            filled: true,
                            fillColor: const Color(0xfff0fcf3),
                            prefixIcon:
                                const Icon(Icons.mail_outline, size: 28),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                            hintStyle: GoogleFonts.roboto(fontSize: 20),
                            filled: true,
                            fillColor: const Color(0xfff0fcf3),
                            prefixIcon:
                                const Icon(Icons.lock_outline, size: 28),
                               suffixIcon: IconButton(
                      onPressed: (){
                           setState(() {
                      isVisibility = !isVisibility;
                    });
                      }, 
                      icon: Icon(isVisibility ? Icons.visibility_off:Icons.visibility)
                      ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none)),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(400, 50),
                            backgroundColor: const Color(0xff1d1a30),
                          ),
                          onPressed: () {
                            _sendToserver(context);
                          },
                          child: Text("Creer compte",
                              style: GoogleFonts.roboto(
                                  fontSize: 20, color: Colors.white))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Vous avez déjà un compte ?",
                            style: GoogleFonts.roboto(fontSize: 16),
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
                                "Se connecter",
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[400],
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
      ),
    );
  }
}
