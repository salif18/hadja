// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/category_api.dart';
import 'package:hadja_grish/models/categorie_model.dart';

class MyCategoriList extends StatefulWidget {
  const MyCategoriList({super.key});

  @override
  State<MyCategoriList> createState() => _MyCategoriListState();
}

class _MyCategoriListState extends State<MyCategoriList> {
  ServicesApiCategory api = ServicesApiCategory();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final StreamController<List<CategoriesModel>> _listCategories =
      StreamController<List<CategoriesModel>>();
  final _categorieName = TextEditingController();

  @override
  void initState() {
    _getCategories();
    super.initState();
  }

  @override
  void dispose() {
    _listCategories.close();
    _categorieName.dispose();
    super.dispose();
  }

  Future<void> _getCategories() async {
    try {
      final res = await api.getCategories();
      final body = res.data;
      if (res.statusCode == 200) {
        _listCategories.add((body["categories"] as List)
            .map((json) => CategoriesModel.fromJson(json))
            .toList());
      }
    } catch (e) {
      Exception(e);
    }
  }

  Future<void> _sendToserver(BuildContext context) async {
    if (_globalKey.currentState!.validate()) {
      final data = {
        "name_categorie": _categorieName.text,
      };
      try {
        showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
        final res = await api.postCategories(data);
        final body = res.data;
        Navigator.pop(context); // Fermer le dialog

        if (res.statusCode == 200) {
          api.showSnackBarSuccessPersonalized(context, body["message"]);
          _getCategories();
        } else {
          api.showSnackBarErrorPersonalized(context, body["message"]);
        }
      } catch (e) {
        Navigator.pop(context); // Fermer le dialog
        api.showSnackBarErrorPersonalized(context, e.toString());
        Exception(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 28),
        ),
        title: Text(
          "Categories",
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: StreamBuilder<List<CategoriesModel>>(
          stream: _listCategories.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Pas de données disponibles"));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  CategoriesModel categorie = snapshot.data![index];
                  return Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Color.fromARGB(255, 245, 245, 245)))),
                    child: ListTile(
                      title: Text(categorie.nameCategorie),
                      trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.edit,
                              size: 20, color: Colors.blue)),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 5, 191, 100),
        onPressed: () {
          _addCateShow(context);
        },
        child: const Icon(
          Icons.add,
          size: 28,
          color: Colors.white,
        ),
      ),
    );
  }

  void _addCateShow(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Ajouter categories",
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: _globalKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _categorieName,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veuillez entrer une categorie';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Nom de la categorie",
                        hintStyle: GoogleFonts.roboto(fontSize: 18),
                        prefixIcon: const Icon(
                          Icons.category_rounded,
                          size: 20,
                          color: Colors.purpleAccent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _sendToserver(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D1A30),
                        minimumSize: const Size(400, 50),
                      ),
                      child: Text(
                        "Enregistrer",
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
