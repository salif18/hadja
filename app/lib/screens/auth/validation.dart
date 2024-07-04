import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ValidationReset extends StatefulWidget {
  const ValidationReset({super.key});

  @override
  State<ValidationReset> createState() => _ValidationResetState();
}

class _ValidationResetState extends State<ValidationReset> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.grey[200],
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 24)),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                _text(context),
                _formNewPassword(context),
                _formConfirmPassword(context),
                _secondText(context),
                _codes4Champs(context),
                const SizedBox(height: 100),
                _sendButton(context)
              ],
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Validation le mot de passe",
                style: GoogleFonts.roboto(
                    fontSize: 23, fontWeight: FontWeight.w600)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                "Veuillez entrer les bonnes informations pour pouvoir valider le nouveau mot de passe",
                style: GoogleFonts.roboto(
                    fontSize: 16, fontWeight: FontWeight.w300)),
          ),
        ],
      ),
    );
  }

  Widget _formNewPassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Veuillez entrer un nouveau mot de passe';
          }
          return null;
        },
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.key_rounded, size: 24),
          filled: true,
          fillColor: Colors.grey[100],
          labelText: "Nouveau mot de passe",
          labelStyle:
              GoogleFonts.aBeeZee(fontSize: 18, fontWeight: FontWeight.w500),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _formConfirmPassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Veuillez retaper le meme mot de passe';
          }
          return null;
        },
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock_outline, size: 24),
          filled: true,
          fillColor: Colors.grey[100],
          labelText: "Confirmer",
          labelStyle:
              GoogleFonts.aBeeZee(fontSize: 18, fontWeight: FontWeight.w500),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _secondText(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Text("Entrez les 4 chiffres envoyés sur votre e-mail",
                style: GoogleFonts.roboto(
                    fontSize: 18, fontWeight: FontWeight.w400))));
  }

  Widget _codes4Champs(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PinCodeTextField(
            appContext: context,
            length: 4,
            pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(10),
                fieldHeight: 80,
                fieldWidth: 75,
                activeColor: Colors.blue,
                inactiveColor: Colors.grey),
            onCompleted: (value) {
              setState(() {});
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Veuillez entrer les 4 chiffres de validation';
              }
              return null;
            },
          )),
    );
  }

  Widget _sendButton(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4caf50),
            minimumSize: const Size(350, 50)),
        onPressed: () {},
        child: Text("Envoyer",
            style: GoogleFonts.aBeeZee(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white)));
  }
}
