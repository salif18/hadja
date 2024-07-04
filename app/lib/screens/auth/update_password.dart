import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/screens/auth/reset_password.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_rounded, size: 20)),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Form(
              child: Column(
                children: [_formulaires(context)],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _formulaires(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Changer de mot de passe",
                  style: GoogleFonts.roboto(
                      fontSize: 23, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Votre mot de passe doit contenir au moins 6 caractères",
                  style: GoogleFonts.roboto(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Veuillez entrer un mot de passe actuel';
              }
              return null;
            },
            keyboardType: TextInputType.visiblePassword,
            obscureText: false,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              hintText: "Mot de passe actuel",
              hintStyle: GoogleFonts.aBeeZee(
                  fontSize: 18, fontWeight: FontWeight.w400),
              // prefixIcon: const Icon(Icons.lock_outline_rounded, size: 33),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Veuillez rentrer un nouveau mot de passe';
              }
              return null;
            },
            keyboardType: TextInputType.visiblePassword,
            obscureText: false,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              hintText: "Nouveau mot de passe",
              hintStyle: GoogleFonts.aBeeZee(
                  fontSize: 18, fontWeight: FontWeight.w400),
              // prefixIcon: const Icon(Icons.lock_outline_rounded, size: 33),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Veuillez retaper le meme mot de passe';
              }
              return null;
            },
            keyboardType: TextInputType.visiblePassword,
            obscureText: false,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              hintText: "Retapez le nouveau mot de passe",
              hintStyle: GoogleFonts.aBeeZee(
                  fontSize: 18, fontWeight: FontWeight.w400),
              // prefixIcon: const Icon(Icons.lock_outline_rounded, size: 33),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ResetToken()));
                },
                child: Text("Mot de passe oublié ?",
                    style: GoogleFonts.roboto(fontSize: 16)))
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4caf50),
              elevation: 5,
              fixedSize: const Size(400, 50),
            ),
            onPressed: () {},
            child: Text(
              "Changer le mot de passe",
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.grey[100],
              ),
            ),
          ),
        )
      ],
    );
  }
}
