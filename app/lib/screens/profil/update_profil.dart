import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdateProfil extends StatefulWidget {
  const UpdateProfil({super.key});

  @override
  State<UpdateProfil> createState() => _UpdateProfilState();
}

class _UpdateProfilState extends State<UpdateProfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon:const Icon(Icons.arrow_back_ios_new_rounded, size: 24)),
        title: Text(
          "Modification de compte",
          style: GoogleFonts.roboto(
            fontSize: 20,
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
                  GoogleFonts.roboto(fontSize: 23, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Vous pouvez apporter des modifications à votre profil",
              style:
                  GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w400),
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
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          hintText: "Name",
          hintStyle:
              GoogleFonts.aBeeZee(fontSize: 18, fontWeight: FontWeight.w400),
          prefixIcon: const Icon(Icons.person_2_outlined, size: 33),
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
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          hintText: "Numero",
          hintStyle:
              GoogleFonts.aBeeZee(fontSize: 18, fontWeight: FontWeight.w400),
          prefixIcon: const Icon(Icons.phone_android, size: 33),
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
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          hintText: "Email",
          hintStyle:
              GoogleFonts.aBeeZee(fontSize: 18, fontWeight: FontWeight.w400),
          prefixIcon: const Icon(Icons.mail_outline, size: 33),
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
          onPressed: () {},
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D1A30),
              elevation: 5,
              fixedSize: const Size(320, 50)),
          icon: Icon(Icons.edit, size: 30, color: Colors.grey[100]),
          label: Text("Modifier le profil",
              style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[100]))),
    );
  }
}
