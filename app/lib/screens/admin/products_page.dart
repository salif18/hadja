// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/category_api.dart';
import 'package:hadja_grish/api/product_admin_api.dart';
import 'package:hadja_grish/models/articles_model.dart';
import 'package:hadja_grish/models/categorie_model.dart';
import 'dart:io';
import 'package:hadja_grish/screens/admin/singleProduct_admin.dart';
import 'package:image_picker/image_picker.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  // Clé Key du formulaire
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  // api denvoie vers le server
  ServicesAPiProducts api = ServicesAPiProducts();
  ServicesApiCategory apiCatego = ServicesApiCategory();
  // declarations des Variables list categories et list des articles
  List<CategoriesModel> _listCategories = [];
  final StreamController<List<ArticlesModel>> _articlesData = StreamController();

// configuration de selection image depuis gallerie
  final ImagePicker _picker = ImagePicker();
  XFile? _articleImage;
  List<XFile>? gallerieImages = [];

// configuration des champs de formulaires pour le controller
  final _nameController = TextEditingController();
  String? _categoryController;
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getProducts();
    _getCategories();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _articlesData.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getProducts();
  }

// fonction de recuperation des categories list depuis server
  Future<void> _getCategories() async {
    try {
      final res = await apiCatego.getCategories();
      final body = res.data;
      if (res.statusCode == 200) {
        setState(() {
          _listCategories = (body["categories"] as List)
              .map((json) => CategoriesModel.fromJson(json))
              .toList();
        });
      }
    } catch (e) {
      Exception(e);
    }
  }

// fonction fetch data articles depuis server
  Future<void> _getProducts() async {
    try {
      final res = await api.getAllProducts();
      final body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        _articlesData.add((body["articles"] as List)
            .map((json) => ArticlesModel.fromJson(json))
            .toList());
      }
    } catch (e) {
      _articlesData.addError("");
    }
  }

// obtenir l"image depuis gallerie du telephone
  Future<void> _getImageToGalleriePhone() async {
    final XFile? imagePicked = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (imagePicked != null) {
        _articleImage = imagePicked;
      }
    });
  }

// selectionner plusieur images depuis gallerie du telephone
  Future<void> _selectMultiImageGallery() async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        setState(() {
          gallerieImages?.addAll(pickedFiles);
        });
      }
    } on Exception catch (e) {
      Exception(e.toString());
    }
  }

// Envoie des donnees vers le server
  Future<void> _sendToServer() async {
    if (_globalKey.currentState!.validate()) {
      if (_articleImage == null || _categoryController == null) {
        api.showSnackBarErrorPersonalized(context, "Veuillez sélectionner une image et une catégorie.");
        return;
      }

      // recuperation des chemins de chaque images ajouter dans gallerieImages
      List<MultipartFile> imageFilesPaths = [];
      for (var image in gallerieImages!) {
        imageFilesPaths.add(await MultipartFile.fromFile(image.path, filename: image.path.split("/").last));
      }

      FormData formData = FormData.fromMap({
        "name": _nameController.text,
        "img": await MultipartFile.fromFile(_articleImage!.path, filename: _articleImage!.path.split("/").last),
        "galleries[]": imageFilesPaths,
        "categorie": _categoryController,
        "desc": _descController.text,
        "stock": _stockController.text,
        "price": _priceController.text,
        "likes": 0,
        "disLikes": 0
      });

      try {
        final res = await api.postNewProduct(formData);
        if (res.statusCode == 201) {
          api.showSnackBarSuccessPersonalized(context, res.data["message"]);
        } else {
          api.showSnackBarErrorPersonalized(context, res.data["message"]);
        }
      } catch (e) {
        api.showSnackBarErrorPersonalized(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 28),
        ),
        title: Text(
          "Produits",
          style: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w400),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _addProducts(context);
            },
            icon: const Icon(Icons.add, size: 28),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder<List<ArticlesModel>>(
            stream: _articlesData.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Erreur", style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w600)),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text("Aucune donnée disponible", style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w600)),
                );
              } else {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final data = snapshot.data!;
                      ArticlesModel article = data[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SingleProductAdmin(article: article)));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              border: const Border(bottom: BorderSide(color: Color.fromARGB(255, 235, 235, 235)))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20)),
                                      child: Image.network(
                                        article.img,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(article.name, style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500)),
                                        Text("${article.price.toString()} fcfa", style: GoogleFonts.roboto(fontSize: 14, color: Colors.grey[500]))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text("stocks:", style: GoogleFonts.roboto(fontSize: 14)),
                                    const SizedBox(width: 10),
                                    Text(article.stock > 0 ? article.stock.toString() : "finis"),
                                  ],
                                ),
                              )
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

  void _addProducts(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(15),
          height: MediaQuery.of(context).size.height * 0.95,
          child: Form(
            key: _globalKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text("Ajout de Produit", style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: "Nom du produit", border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Le nom du produit est requis";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _descController,
                    decoration: const InputDecoration(labelText: "Description du produit", border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "La description est requise";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(labelText: "Prix du produit", border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Le prix est requis";
                      } else if (double.tryParse(value) == null) {
                        return "Veuillez entrer un prix valide";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _stockController,
                    decoration: const InputDecoration(labelText: "Stock du produit", border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Le stock est requis";
                      } else if (int.tryParse(value) == null) {
                        return "Veuillez entrer un stock valide";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _categoryController,
                    decoration: const InputDecoration(labelText: "Catégorie du produit", border: OutlineInputBorder()),
                    items: _listCategories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category.nameCategorie,
                        child: Text(category.nameCategorie),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _categoryController = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return "La catégorie est requise";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text("Image du produit",style: GoogleFonts.roboto(fontSize: 18)),
                          IconButton(
                            icon:  const Icon(Icons.photo_camera_back_outlined, size: 38),
                            onPressed: () {
                              _getImageToGalleriePhone();
                            },
                          ),
                        ],
                      ),
                      if (_articleImage != null)
                        Image.file(File(_articleImage!.path), width: 100, height: 100),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Text("Ajouter des images à la galerie",style: GoogleFonts.roboto(fontSize: 18)),
                      IconButton(
                        icon:const Icon(Icons.photo_library_outlined, size: 38),
                        onPressed: () {
                          _selectMultiImageGallery();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (gallerieImages != null)
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: gallerieImages?.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(File(gallerieImages![index].path), width: 100, height: 100),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                     style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D1A30),
                minimumSize: const Size(400, 50)),
                    onPressed: () {
                      _sendToServer();
                      Navigator.pop(context);
                    },
                    child:Text("Ajouter" ,style: GoogleFonts.roboto(fontSize: 18, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
