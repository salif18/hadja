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
          
      final res = await api.postUpdateUserData(data, userId);
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
      body:LayoutBuilder(
        builder: (context,constraints){
          return  Container(
          padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context, 20))),
              child: Form(
                key: _globalKey,
                child: Column(
                  children: [
                    _text(context,constraints),
                    _textFieldName(
                      context,constraints
                    ),
                    _textFieldNumber(context,constraints),
                    _textFieldMail(context,constraints),
                    SizedBox(height: constraints.maxWidth * AppSizes.converValueToadapter(context, 100)),
                    _buttonSend(context,constraints),
                  ],
                ),
              ),
            ),
          ),
        );
        },
       
      ),
    );
  }

  Widget _text(BuildContext context ,constraints) {
    return Padding(
      padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
            child: Text(
              "Changer le profil ",
              style:
                  GoogleFonts.roboto(fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 14), fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
            child: Text(
              "Vous pouvez apporter des modifications à votre profil",
              style:
                  GoogleFonts.roboto(fontSize:constraints.maxWidth * AppSizes.converValueToadapter(context, 12), fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
    );
  }

  Widget _textFieldName(BuildContext context,constraints) {
    return Padding(
      padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
      child: TextFormField(
         controller: _name,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          hintText: "Name",
          hintStyle:
              GoogleFonts.aBeeZee(fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 12), fontWeight: FontWeight.w400),
          prefixIcon: Icon(Icons.person_2_outlined, size: constraints.maxWidth * AppSizes.converValueToadapter(context, 24)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _textFieldNumber(BuildContext context,constraints) {
    return Padding(
      padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
      child: TextFormField(
         controller: _numero,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          hintText: "Numero",
          hintStyle:
              GoogleFonts.aBeeZee(fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 12), fontWeight: FontWeight.w400),
          prefixIcon: Icon(Icons.phone_android, size: constraints.maxWidth * AppSizes.converValueToadapter(context, 24)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _textFieldMail(BuildContext context,constraints) {
    return Padding(
      padding:EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
      child: TextFormField(
         controller: _email,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          hintText: "Email",
          hintStyle:
              GoogleFonts.aBeeZee(fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 12), fontWeight: FontWeight.w400),
          prefixIcon: Icon(Icons.mail_outline, size: constraints.maxWidth * AppSizes.converValueToadapter(context, 24)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buttonSend(BuildContext context,constraints) {
    return Padding(
      padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
      child: ElevatedButton.icon(
          onPressed: () {
            _sendUpdate();
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D1A30),
              elevation: 5,
              fixedSize: Size(constraints.maxWidth * AppSizes.converValueToadapter(context, 320), constraints.maxWidth * AppSizes.converValueToadapter(context, 40))),
          icon: Icon(Icons.edit, size: constraints.maxWidth * AppSizes.converValueToadapter(context, 20), color: Colors.grey[100]),
          label: Text("Modifier le profil",
              style: GoogleFonts.roboto(
                  fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 12),
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[100]))),
    );
  }
}
