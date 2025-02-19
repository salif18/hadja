// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/category_api.dart';
import 'package:hadja_grish/constants/app_size.dart';
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

// OBTENIR LES CATEGORIES API
  Future<void> _getCategories() async {
    try {
      final res = await api.getCategories();
      final body = res.data;
      if (res.statusCode == 200) {
        List<CategoriesModel> converDataToModelCategorie = (body["categories"] as List)
            .map((json) => CategoriesModel.fromJson(json))
            .toList();
            converDataToModelCategorie.sort((a, b) => a.nameCategorie.compareTo(b.nameCategorie));
        _listCategories.add(converDataToModelCategorie);
      }
    } catch (e) {
      Exception(e); // Ajout d'une impression pour le debug
    }
  }

//SUPPRIMER CATEGORIE API
  Future<void> _removeCategories(int id) async {
    try {
      final res = await api.deleteCategories(id);
      if (res.statusCode == 200) {
        api.showSnackBarSuccessPersonalized(context, res.data["message"]);
        _getCategories(); // Actualiser la liste des catégories
      } else {
        api.showSnackBarErrorPersonalized(context, res.data["message"]);
      }
    } catch (e) {
      api.showSnackBarErrorPersonalized(context, e.toString());
    }
  }

//AJOUTER CATEGORIE API
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
        Navigator.pop(context); // Fermer le dialog

        if (res.statusCode == 200) {
          api.showSnackBarSuccessPersonalized(context, res.data["message"]);
          _getCategories();
        } else {
          api.showSnackBarErrorPersonalized(context, res.data["message"]);
        }
      } catch (e) {
        Navigator.pop(context); // Fermer le dialog
        api.showSnackBarErrorPersonalized(context, e.toString());
      }
    }
  }

//MODIFIER CATEGORIE API
  Future<void> _sendNewUpdateToserver(BuildContext context, int id) async {
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
        final res = await api.updateCategories(data, id);
        Navigator.pop(context); // Fermer le dialog

        if (res.statusCode == 200) {
          api.showSnackBarSuccessPersonalized(context, res.data["message"]);
          _getCategories();
        } else {
          api.showSnackBarErrorPersonalized(context, res.data["message"]);
        }
      } catch (e) {
        Navigator.pop(context); // Fermer le dialog
        api.showSnackBarErrorPersonalized(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.width * 50/360,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: MediaQuery.of(context).size.width * 24/360),
        ),
        title: Text(
          "Categories",
          style: GoogleFonts.roboto(
            fontSize: MediaQuery.of(context).size.width * 16/360,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: LayoutBuilder(builder: (context,constraints){
        return Container(
        padding:  EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
        child: StreamBuilder<List<CategoriesModel>>(
          stream: _listCategories.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Problème de connexion au server",style: TextStyle(fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 12)),));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("Pas de données disponibles",style: TextStyle(fontSize:  constraints.maxWidth * AppSizes.converValueToadapter(context, 12)),));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, int index) {
                  CategoriesModel categorie = snapshot.data![index];
                  return Dismissible(
                    key: Key(categorie.id.toString()),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      _removeCategories(categorie.id);
                    },
                    confirmDismiss: (direction) async {
                      return await showRemoveCategorie(context,constraints);
                    },
                    background: Container(
                      color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.delete_outline,
                              color: Colors.white, size:  constraints.maxWidth * AppSizes.converValueToadapter(context, 22)),
                          SizedBox(width:  constraints.maxWidth * AppSizes.converValueToadapter(context, 50)),
                        ],
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Color.fromARGB(255, 245, 245, 245)))),
                      child: ListTile(
                        title: Text(categorie.nameCategorie,style: GoogleFonts.roboto(fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 12)),),
                        trailing: IconButton(
                            onPressed: () {
                              _updateCateShow(context, categorie.id,constraints);
                            },
                            icon: Icon(Icons.edit,
                                size: constraints.maxWidth * AppSizes.converValueToadapter(context, 22), color: Colors.blue)),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      );
      }),
      floatingActionButton: LayoutBuilder(builder: (context,constraints){
        return FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 5, 191, 100),
        onPressed: () {
          _addCateShow(context, constraints);
        },
        child: Icon(
          Icons.add,
          size:  constraints.maxWidth * AppSizes.converValueToadapter(context, 22),
          color: Colors.white,
        ),
      );
      })
    );
  }

//FENETRE POUR AJOUTER CATEGORIE
  void _addCateShow(BuildContext context,constraints) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Ajouter categories",
              style: GoogleFonts.roboto(
                fontSize:  constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
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
                        hintStyle: GoogleFonts.roboto(fontSize:  constraints.maxWidth * AppSizes.converValueToadapter(context, 12)),
                        prefixIcon: Icon(
                          Icons.category_rounded,
                          size:  constraints.maxWidth * AppSizes.converValueToadapter(context, 12),
                          color: Colors.purpleAccent,
                        ),
                      ),
                    ),
                    SizedBox(height:  constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
                    ElevatedButton(
                      onPressed: () {
                        _sendToserver(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D1A30),
                        minimumSize: Size( constraints.maxWidth * AppSizes.converValueToadapter(context, 400), constraints.maxWidth * AppSizes.converValueToadapter(context, 40)),
                      ),
                      child: Text(
                        "Enregistrer",
                        style: GoogleFonts.roboto(
                          fontSize:  constraints.maxWidth * AppSizes.converValueToadapter(context, 12),
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

//FENETRE POUR MODIFIER CATEGORIE
  void _updateCateShow(BuildContext context, int id,constraints) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Modifier categories",
              style: GoogleFonts.roboto(
                fontSize:  constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
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
                        hintStyle: GoogleFonts.roboto(fontSize:  constraints.maxWidth * AppSizes.converValueToadapter(context, 12)),
                        prefixIcon: Icon(
                          Icons.category_rounded,
                          size:  constraints.maxWidth * AppSizes.converValueToadapter(context, 22),
                          color: Colors.purpleAccent,
                        ),
                      ),
                    ),
                  SizedBox(height:  constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
                    ElevatedButton(
                      onPressed: () {
                        _sendNewUpdateToserver(context, id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D1A30),
                        minimumSize: Size( constraints.maxWidth * AppSizes.converValueToadapter(context, 400),  constraints.maxWidth * AppSizes.converValueToadapter(context, 40)),
                      ),
                      child: Text(
                        "Mettre à jour",
                        style: GoogleFonts.roboto(
                          fontSize:  constraints.maxWidth * AppSizes.converValueToadapter(context, 12),
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

// FENTRE DIALOGUE POUR CONFIRMER LA SUPPRESSION
Future<bool> showRemoveCategorie(BuildContext context,constraints) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Confirmer",style: GoogleFonts.roboto(fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 14))),
        content: Text("Êtes-vous sûr de vouloir supprimer cette catégorie ?",style: GoogleFonts.roboto(fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 12))),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text("Annuler",style: GoogleFonts.roboto(fontSize:constraints.maxWidth * AppSizes.converValueToadapter(context, 12))),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text("Supprimer",style: GoogleFonts.roboto(fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 12))),
          ),
        ],
      );
    },
  );
}
