// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/category_api.dart';
import 'package:hadja_grish/api/product_admin_api.dart';
import 'package:hadja_grish/models/articles_model.dart';
import 'package:hadja_grish/models/categorie_model.dart';
import 'dart:io';
import 'package:hadja_grish/screens/products_admin/details/singleProduct_admin.dart';
import 'package:image_picker/image_picker.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  ServicesAPiProducts api = ServicesAPiProducts();
  ServicesApiCategory apiCatego = ServicesApiCategory();
  List<CategoriesModel> _listCategories = [];
  final StreamController<List<ArticlesModel>> _articlesData =
      StreamController();

  //coisir image depuis gallerie de phone
  final picker = ImagePicker();
  File? _imageProduct;
  final List<File>? _gallery = [];

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

  Future<void> _getProducts() async {
    try {
      _articlesData.add(ArticlesModel.data());
    } catch (e) {
      _articlesData.addError(e);
    }
  }

  Future<void> _getImageToGalleriePhone() async {
    final imagePicked = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (imagePicked != null) {
        _imageProduct = File(imagePicked.path);
      }
    });
  }

  Future<void> _selectMultiImageGallery() async {
    try {
      var images = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _gallery!.add(File(images!.path));
      });
    } on Exception catch (e) {
      Exception(e.toString());
    }
  }

  Future<void> _sendToServer() async {
    if (_globalKey.currentState!.validate()) {
      List<MultipartFile> imageFiles = [];
      for (var asset in _gallery!) {
        final paths = asset.path;
        imageFiles.add(await MultipartFile.fromFile(
          paths,
        ));
      }
      FormData formData = FormData.fromMap({
        "name": _nameController.text,
        "img": await MultipartFile.fromFile(_imageProduct!.path,
            filename: "photo.png"),
        "galleries*": imageFiles,
        "category": _categoryController,
        "desc": _descController.text,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
      body: SafeArea(
        child: StreamBuilder<List<ArticlesModel>>(
            stream: _articlesData.stream,
            builder: (context, snaptshot) {
              if (snaptshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
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
                      final article = snaptshot.data!;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      _showSingleProduct(context)));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xfff0fcf3),
                            border: Border(bottom: BorderSide(color: const Color.fromARGB(255, 235, 235, 235)))
                          ),
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
                                      child: Image.asset(
                                        article[index].img,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                   Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(article[index].name,
                                        style: GoogleFonts.roboto(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500)),
                                    Text(
                                        "${article[index].price.toString()} fcfa",
                                        style: GoogleFonts.roboto(
                                            fontSize: 18,
                                            color: Colors.grey[500]))
                                  ],
                                ),
                              ),
                                ],
                              ),
                             
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text("stocks:"),
                                    const SizedBox(width: 10),
                                    Text(article[index].stock.toString()),
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
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 80,
                  child: Center(
                    child: Text(
                      "Ajouter produits",
                      style: GoogleFonts.roboto(
                          fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                _formulaires(context),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D1A30),
                    minimumSize: const Size(400, 50),
                  ),
                  onPressed: _sendToServer,
                  child: Text(
                    "Enregistrer",
                    style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _formulaires(BuildContext context) {
    return Form(
      key: _globalKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: _getImageToGalleriePhone,
              child: InputDecorator(
                decoration: InputDecoration(
                  hintText: "Photo",
                  hintStyle:
                      GoogleFonts.roboto(fontSize: 18, color: Colors.grey),
                  prefixIcon: const Icon(Icons.image, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: _imageProduct == null
                    ? Text("Aucune image sélectionnée",
                        style: GoogleFonts.roboto(
                            fontSize: 18, color: Colors.grey))
                    : Image.file(_imageProduct!, height: 100),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _nameController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez entrer le nom';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "Nom du produit",
                hintStyle: GoogleFonts.roboto(fontSize: 18, color: Colors.grey),
                prefixIcon: const Icon(Icons.pix_rounded, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: DropdownButtonFormField<String?>(
              hint: Text(
                "Choisir une catégorie",
                style: GoogleFonts.roboto(
                    fontSize: 20, fontWeight: FontWeight.w500),
              ),
              value: _categoryController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez choisir une catégorie';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _categoryController = value;
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
              items: _listCategories.map((categorie) {
                return DropdownMenuItem<String?>(
                  value: categorie.nameCategorie,
                  child: Text(
                    categorie.nameCategorie,
                    style:
                        GoogleFonts.roboto(fontSize: 20, color: Colors.black),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: _selectMultiImageGallery,
              child: InputDecorator(
                decoration: InputDecoration(
                  hintText: "Autres images",
                  hintStyle:
                      GoogleFonts.roboto(fontSize: 18, color: Colors.grey),
                  prefixIcon: const Icon(Icons.image, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: _gallery == null
                    ? Text("Aucune image sélectionnée",
                        style: GoogleFonts.roboto(
                            fontSize: 18, color: Colors.grey))
                    : Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: _gallery.map((asset) {
                          return SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.file(asset),
                          );
                        }).toList(),
                      ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _descController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez entrer la description';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "Description",
                hintStyle: GoogleFonts.roboto(fontSize: 18, color: Colors.grey),
                prefixIcon: const Icon(Icons.list, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _priceController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez entrer le prix';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "Prix",
                hintStyle: GoogleFonts.roboto(fontSize: 18, color: Colors.grey),
                prefixIcon: const Icon(Icons.monetization_on_rounded, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _stockController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez entrer un nombre de stock';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "Stock",
                hintStyle: GoogleFonts.roboto(fontSize: 18, color: Colors.grey),
                prefixIcon:
                    const Icon(Icons.store_mall_directory_sharp, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _showSingleProduct(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          child: SingleProductAdmin(),
        );
      },
    );
  }
}
