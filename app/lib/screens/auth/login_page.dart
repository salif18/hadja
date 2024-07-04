import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/screens/auth/registre_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController(); 

  @override 
  void dispose(){
    _email.dispose(); 
    _password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 5, 191, 100),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top:50.0),
              child: Image.asset(
                "assets/logos/logo5.jpg",
                width: 200,
                height: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 20),
              child: Text("Aw bissimilah",
                  style: GoogleFonts.aclonica(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 29.0),
              child: Container(
                height: 500,
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
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: GoogleFonts.roboto(fontSize: 20),
                            filled: true,
                            fillColor: const Color(0xfff0fcf3),
                            prefixIcon: const Icon(Icons.mail_outline, size: 28),
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
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: "Mot de passe",
                            hintStyle: GoogleFonts.roboto(fontSize: 20),
                            filled: true,
                            fillColor: const Color(0xfff0fcf3),
                            prefixIcon: const Icon(Icons.lock_outline, size: 28),
                            suffixIcon: const Icon(Icons.visibility, size: 28),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none)),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {},
                              child: Text(
                                "Mot de passe oublié ?",
                                style: GoogleFonts.roboto(
                                    fontSize: 18, color: const Color.fromARGB(255, 5, 191, 100),),
                              ))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(400, 50),
                            backgroundColor:
                                const Color.fromARGB(255, 5, 191, 100),
                          ),
                          onPressed: () {},
                          child: Text("Se connecter",
                              style: GoogleFonts.roboto(
                                  fontSize: 20, color: Colors.white))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Vous n'avez pas de compte ?",
                            style: GoogleFonts.roboto(fontSize: 18),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>const RegistrePage()));
                              },
                              child: Text(
                                "Créer",
                                style: GoogleFonts.roboto(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(255, 5, 191, 100),),
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
