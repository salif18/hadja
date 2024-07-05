import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/screens/auth/validation.dart';

class ResetToken extends StatefulWidget {
  const ResetToken({super.key});

  @override
  State<ResetToken> createState() => _ResetTokenState();
}

class _ResetTokenState extends State<ResetToken> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.grey[200],
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 24)),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Form(
              child: Column(
                children: [
                  _text(context),
                  _formNumberField(context),
                  _formEmailField(context),
                  const SizedBox(height: 100),
                  _sendButton(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _text(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Réinitialiser le mot de passe",
                style: GoogleFonts.roboto(
                    fontSize: 23, fontWeight: FontWeight.w600)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                "Veuillez entrer les bonnes informations pour pouvoir nous aider à réinitialiser votre mot de passe",
                style: GoogleFonts.roboto(
                    fontSize: 16, fontWeight: FontWeight.w300)),
          ),
        ],
      ),
    );
  }

  Widget _formNumberField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Veuillez entrer votre numero ';
          }
          return null;
        },
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.phone_android_rounded, size: 24),
          filled: true,
          fillColor: Colors.grey[100],
          hintText: "Numéro",
          hintStyle:
              GoogleFonts.aBeeZee(fontSize: 16, fontWeight: FontWeight.w500),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _formEmailField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Veuillez entrer votre email';
          }
          return null;
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail_outline, size: 24),
          filled: true,
          fillColor: Colors.grey[100],
          hintText: "Email",
          hintStyle:
              GoogleFonts.aBeeZee(fontSize: 16, fontWeight: FontWeight.w500),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _sendButton(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor:const Color(0xFF1D1A30),
            minimumSize: const Size(350, 50)),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ValidationReset()));
        },
        child: Text("Envoyer",
            style: GoogleFonts.aBeeZee(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white)));
  }
}
