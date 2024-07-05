import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/screens/auth/login_page.dart';

class RegistrePage extends StatefulWidget {
  const RegistrePage({super.key});

  @override
  State<RegistrePage> createState() => _RegistrePageState();
}

class _RegistrePageState extends State<RegistrePage> {
 
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _nom = TextEditingController(); 
  final _email = TextEditingController();
  final _password = TextEditingController(); 

  @override 
  void dispose(){
    _nom.dispose();
    _email.dispose(); 
    _password.dispose();
    super.dispose();
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
              padding: const EdgeInsets.only(top:50.0),
              child: Image.asset(
                "assets/logos/logo4.jpg",
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
                        controller: _nom,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            hintText: "Nom",
                            hintStyle: GoogleFonts.roboto(fontSize: 20),
                            filled: true,
                            fillColor: const Color(0xfff0fcf3),
                            prefixIcon: const Icon(Icons.person_3_outlined, size: 28),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none)),
                      ),
                    ),
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
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(400, 50),
                            backgroundColor:
                                const Color(0xff1d1a30),
                          ),
                          onPressed: () {},
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
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginPage()));
                              },
                              child: Text(
                                "Se connecter",
                                style: GoogleFonts.roboto(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[400],),
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