import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/auth_api.dart';


class UpdateLibery extends StatefulWidget {
  const UpdateLibery({super.key});

  @override
  State<UpdateLibery> createState() => _UpdateLiberyState();
}

class _UpdateLiberyState extends State<UpdateLibery> {

   // CLE KEY FORMULAIRE
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  // API SERVICE AUTHENTIFICATION
  ServicesApiAuth api = ServicesApiAuth();

  //CHAMPS FORMULAIRES
  final _nom = TextEditingController();
  final _numero = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
   String? _statutUser ;
  final List<String> _statutList = ["isAdmin","isLibery","isClient"];

  bool isVisibility = true;

  @override
  void dispose() {
    _nom.dispose();
    _numero.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

 Future<void> _sendToserver(BuildContext context) async {
    if (_globalKey.currentState!.validate()) {
      final data = {
        "name": _nom.text,
        "phone_number": _numero.text,
        "email": _email.text,
        "user_statut":_statutUser,
        "password": _password.text
      };
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
          api.showSnackBarSuccessPersonalized(context, body["message"]);
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
    return Container();

  }

  
  _formulaires(BuildContext context) {
    return Form(
        key: _globalKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.name,
                controller: _nom,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: "Nom ",
                    hintStyle:
                        GoogleFonts.roboto(fontSize: 18, color: Colors.grey),
                    prefixIcon: const Icon(Icons.person_add, size: 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.phone,
                controller: _numero,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer un numero';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: "Numero",
                    hintStyle:
                        GoogleFonts.roboto(fontSize: 18, color: Colors.grey),
                    prefixIcon: const Icon(Icons.phone, size: 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _email,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer un e-mail';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle:
                        GoogleFonts.roboto(fontSize: 18, color: Colors.grey),
                    prefixIcon: const Icon(Icons.mail_rounded, size: 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
            Padding(
            padding: const EdgeInsets.all(10),
            child: DropdownButtonFormField<String?>(
              hint: Text(
                "Definir statut user",
                style: GoogleFonts.roboto(
                    fontSize: 20, fontWeight: FontWeight.w500),
              ),
              value: _statutUser,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez choisir une catégorie';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _statutUser = value;
                });
              },
              decoration: InputDecoration(
                fillColor: Colors.grey[100],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                prefixIcon: const Icon(Icons.category_outlined, size: 28),
              ),
              items: _statutList.map((statut) {
                return DropdownMenuItem<String?>(
                  value: statut,
                  child: Text(
                    statut,
                    style:
                        GoogleFonts.roboto(fontSize: 20, color: Colors.black),
                  ),
                );
              }).toList(),
            ),
          ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.name,
                obscureText: isVisibility,
               
                controller: _password,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer un mot de passe';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle:
                        GoogleFonts.roboto(fontSize: 18, color: Colors.grey),
                    prefixIcon: const Icon(Icons.key, size: 20),
                    suffixIcon: IconButton(
                      onPressed: (){
                           setState(() {
                      isVisibility = !isVisibility;
                    });
                      }, 
                      icon: Icon(isVisibility ? Icons.visibility:Icons.visibility_off)
                      ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
             const SizedBox(height: 15),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D1A30),
                        minimumSize: const Size(400, 50)),
                    onPressed: () {
                      _sendToserver(context);
                    },
                    child: Text("Enregistrer",
                        style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.white)))
          ],
        ));

        
  }
}