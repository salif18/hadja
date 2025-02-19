import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/auth_api.dart';
import 'package:hadja_grish/constants/app_size.dart';
import 'package:hadja_grish/screens/auth/login_page.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ValidationReset extends StatefulWidget {
  const ValidationReset({super.key});

  @override
  State<ValidationReset> createState() => _ValidationResetState();
}

class _ValidationResetState extends State<ValidationReset> {

   ServicesApiAuth api = ServicesApiAuth();

final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();
  String resetTokenValue = "";

  @override
  void dispose() {
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }




// ENVOIE DES DONNEE VERS API SERVER
  Future<void> _sendToserver(BuildContext context) async {
  if (_globalKey.currentState!.validate()) {
    var data = {
        "resetToken": resetTokenValue,
        "new_password": _newPassword.text.trim(),
        "confirm_password": _confirmPassword.text.trim()
      };
  
    try {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
      final response = await api.postValidatePassword(data);
      final body = json.decode(response.body);
      // ignore: use_build_context_synchronously
      Navigator.pop(context); // Fermer le dialog

      if (response.statusCode == 200) {
          // ignore: use_build_context_synchronously
          api.showSnackBarSuccessPersonalized(context, body["message"]);
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginPage()));

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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.width * 50/360,
        elevation: 0,
        backgroundColor: Colors.grey[200],
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon:Icon(Icons.arrow_back_ios_new_rounded, size: MediaQuery.of(context).size.width * 16/360)),
      ),
      body: LayoutBuilder(
        builder: (context , constraints){
          return Container(
          padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 10)),
          child: SingleChildScrollView(
            child: Form(
              key: _globalKey,
              child: Column(
                children: [
                  _text(context, constraints),
                  _formNewPassword(context , constraints),
                  _formConfirmPassword(context, constraints),
                  _secondText(context, constraints),
                  _codes4Champs(context, constraints),
                  SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context, 100)),
                  _sendButton(context,constraints)
                ],
              ),
            ),
          ),
        );
        },
      ),
    );
  }

  Widget _text(BuildContext context,constraints) {
    return Padding(
      padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
            child: Text("Validation le mot de passe",
                style: GoogleFonts.roboto(
                    fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 20), fontWeight: FontWeight.w600)),
          ),
          Padding(
            padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
            child: Text(
                "Veuillez entrer les bonnes informations pour pouvoir valider le nouveau mot de passe",
                style: GoogleFonts.roboto(
                    fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 14), fontWeight: FontWeight.w300)),
          ),
        ],
      ),
    );
  }

  Widget _formNewPassword(BuildContext context, constraints) {
    return Padding(
      padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
      child: TextFormField(
         controller: _newPassword,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Veuillez entrer un nouveau mot de passe';
          }
          return null;
        },
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          prefixIcon:Icon(Icons.key_rounded, size: constraints.maxWidth * AppSizes.converValueToadapter(context, 24)),
          filled: true,
          fillColor: Colors.grey[100],
          labelText: "Nouveau mot de passe",
          labelStyle:
              GoogleFonts.aBeeZee(fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 12), fontWeight: FontWeight.w500),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context, 20))),
        ),
      ),
    );
  }

  Widget _formConfirmPassword(BuildContext context, constraints) {
    return Padding(
      padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
      child: TextFormField(
         controller: _confirmPassword,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Veuillez retaper le meme mot de passe';
          }
          return null;
        },
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock_outline, size: constraints.maxWidth * AppSizes.converValueToadapter(context, 24)),
          filled: true,
          fillColor: Colors.grey[100],
          labelText: "Confirmer",
          labelStyle:
              GoogleFonts.aBeeZee(fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 14), fontWeight: FontWeight.w500),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context, 20))),
        ),
      ),
    );
  }

  Widget _secondText(BuildContext context,constraints) {
    return Padding(
        padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
        child: Container(
            padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
            child: Text("Entrez les 4 chiffres envoyés sur votre e-mail",
                style: GoogleFonts.roboto(
                    fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 12), fontWeight: FontWeight.w400))));
  }

  Widget _codes4Champs(BuildContext context,constraints) {
    return Padding(
      padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 10)),
      child: Padding(
          padding:  EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
          child: PinCodeTextField(
            appContext: context,
            length: 4,
            pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context, 10)),
                fieldHeight: constraints.maxWidth * AppSizes.converValueToadapter(context, 80),
                fieldWidth: constraints.maxWidth * AppSizes.converValueToadapter(context, 75),
                activeColor: Colors.blue,
                inactiveColor: Colors.grey),
            onCompleted: (value) {
              setState(() {
                  resetTokenValue = value;
              });
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

  Widget _sendButton(BuildContext context,constraints) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1D1A30),
            minimumSize: Size(constraints.maxWidth * AppSizes.converValueToadapter(context, 350), constraints.maxWidth * AppSizes.converValueToadapter(context, 40))),
        onPressed: () {
          _sendToserver(context);
        },
        child: Text("Envoyer",
            style: GoogleFonts.aBeeZee(
                fontSize:constraints.maxWidth * AppSizes.converValueToadapter(context, 12),
                fontWeight: FontWeight.w500,
                color: Colors.white)));
  }
}
