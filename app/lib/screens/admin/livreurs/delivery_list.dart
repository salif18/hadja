import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/auth_api.dart';
import 'package:hadja_grish/api/livreurs_api.dart';

import 'package:hadja_grish/models/user.dart';

class DeliveryList extends StatefulWidget {
  const DeliveryList({super.key});

  @override
  State<DeliveryList> createState() => _DeliveryListState();
}

class _DeliveryListState extends State<DeliveryList> {
  final StreamController<List<ModelUser>> _liberyData =
      StreamController<List<ModelUser>>();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  ServicesApiAuth api = ServicesApiAuth();
  ServicesApiDelibery apiDelibry = ServicesApiDelibery();
  final _nom = TextEditingController();
  final _numero = TextEditingController();
   String? _statutUser ;
  final _email = TextEditingController();
  final _password = TextEditingController();
   bool isVisibility = false;

  final List<String> _statutList = ["isAdmin","isLibery","isClient"];

   @override
  void initState() {
    super.initState();
    _getLibery();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getLibery();
  }

  @override
  void dispose() {
    _liberyData.close();
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

  Future<void> _getLibery()async{
    try{
       final res = await apiDelibry.getAllDelibery();
       final body = json.decode(res.body);
       if(res.statusCode == 200){
         _liberyData.add((body["theLiberys"] as List).map((json) => ModelUser.fromJson(json)).toList());
       }
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                _addLivreurs(context);
              },
              icon: const Icon(Icons.add, size: 28)),
          const SizedBox(
            width: 20,
          )
        ],
        title: Text("Livreurs",
            style:
                GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w500)),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_rounded, size: 24)),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder<List<ModelUser>>(
            stream: _liberyData.stream,
            builder: (context, snaptshot) {
              if (snaptshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snaptshot.hasError) {
                return Text("err",
                    style: GoogleFonts.roboto(
                        fontSize: 20, fontWeight: FontWeight.w600));
              } else if (!snaptshot.hasData || snaptshot.data!.isEmpty) {
                return Text("No data available",
                    style: GoogleFonts.roboto(
                        fontSize: 20, fontWeight: FontWeight.w600));
              } else {
                return ListView.builder(
                    itemCount: snaptshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final livreur = snaptshot.data!;
                      return GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             _showSingleProduct(context)));
                        },
                        child: Container(
                          height: 100,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              border: const Border(
                                  bottom: BorderSide(
                                      color: Color.fromARGB(
                                          255, 235, 235, 235)))),
                          child: Row(
                            
                           
                            children: [
                              Row(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Image.asset(
                                        livreur[index].photo ?? "assets/images/profil.jpeg",
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(livreur[index].name!,
                                            style: GoogleFonts.roboto(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500)),
                                        Text(
                                            livreur[index].number.toString(),
                                            style: GoogleFonts.roboto(
                                                fontSize: 18,
                                                color: Colors.grey[500]))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                             
                            ],
                          ),
                        ),
                      );
                    });
              }
            }),
      ),
    );
  }

  _addLivreurs(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(15),
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: const BoxDecoration(),
            child: Column(
              children: [
                SizedBox(
                  height: 80,
                  child: Center(
                    child: Text("Ajouter livreurs",
                        style: GoogleFonts.roboto(
                            fontSize: 20, fontWeight: FontWeight.w400)),
                  ),
                ),
                _formulaires(context),
               
              ],
            ),
          );
        });
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
