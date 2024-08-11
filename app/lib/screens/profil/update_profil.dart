// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/auth_api.dart';
import 'package:hadja_grish/constants/app_size.dart';
import 'package:hadja_grish/models/user.dart';
import 'package:hadja_grish/providers/auth_provider.dart';
import 'package:hadja_grish/providers/user_provider.dart';
import 'package:provider/provider.dart';

class UpdateProfil extends StatefulWidget {
  const UpdateProfil({super.key});

  @override
  State<UpdateProfil> createState() => _UpdateProfilState();
}

class _UpdateProfilState extends State<UpdateProfil> {
  ServicesApiAuth api = ServicesApiAuth();
  // CLE KEY POUR LE FORMULAIRE
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
   
  final _name = TextEditingController();
  final _numero = TextEditingController();
  final _email = TextEditingController();
  

   @override
  void dispose() {
    _name.dispose();
    _numero.dispose();
    _email.dispose();
    super.dispose();
  }

  Future _sendUpdate() async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    final providerProfil =
        Provider.of<UserInfosProvider>(context, listen: false);
    final userId = await provider.userId();
    var data = {
      "name": _name.text,
      "phone_number": _numero.text,
      "email": _email.text,
    };
    try {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
          
      final res = await api.postUpdateUserProfil(data, userId);
      final body = json.decode(res.body);
      Navigator.pop(context);
      if (res.statusCode == 200) {
        ProfilModel user = ProfilModel.fromJson(body['profil']);
        providerProfil.saveToLocalStorage(user);
        api.showSnackBarSuccessPersonalized(context, body['message']);
        Navigator.pop(context);
      } else {
        api.showSnackBarErrorPersonalized(context, body["message"]);
      }
    } catch (err) {
      api.showSnackBarErrorPersonalized(context,
          "Erreur lors de l'envoi des données , veuillez réessayer. $err");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon:const Icon(Icons.arrow_back_ios_new_rounded, size: AppSizes.iconLarge)),
        title: Text(
          "Modification de compte",
          style: GoogleFonts.roboto(
            fontSize: AppSizes.fontLarge,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Form(
              key: _globalKey,
              child: Column(
                children: [
                  _text(context),
                  _textFieldName(
                    context,
                  ),
                  _textFieldNumber(context),
                  _textFieldMail(context),
                  const SizedBox(height: 100),
                  _buttonSend(context),
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
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Changer le profil ",
              style:
                  GoogleFonts.roboto(fontSize: AppSizes.fontLarge, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Vous pouvez apporter des modifications à votre profil",
              style:
                  GoogleFonts.roboto(fontSize: AppSizes.fontSmall, fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
    );
  }

  Widget _textFieldName(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
         controller: _name,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          hintText: "Name",
          hintStyle:
              GoogleFonts.aBeeZee(fontSize: AppSizes.fontMedium, fontWeight: FontWeight.w400),
          prefixIcon: const Icon(Icons.person_2_outlined, size: AppSizes.iconLarge),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _textFieldNumber(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
         controller: _numero,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          hintText: "Numero",
          hintStyle:
              GoogleFonts.aBeeZee(fontSize: AppSizes.fontMedium, fontWeight: FontWeight.w400),
          prefixIcon: const Icon(Icons.phone_android, size: AppSizes.iconLarge),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _textFieldMail(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
         controller: _email,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          hintText: "Email",
          hintStyle:
              GoogleFonts.aBeeZee(fontSize: AppSizes.fontMedium, fontWeight: FontWeight.w400),
          prefixIcon: const Icon(Icons.mail_outline, size: AppSizes.iconLarge),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buttonSend(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton.icon(
          onPressed: () {
            _sendUpdate();
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D1A30),
              elevation: 5,
              fixedSize: const Size(320, 50)),
          icon: Icon(Icons.edit, size: AppSizes.iconLarge, color: Colors.grey[100]),
          label: Text("Modifier le profil",
              style: GoogleFonts.roboto(
                  fontSize: AppSizes.fontSmall,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[100]))),
    );
  }
}
