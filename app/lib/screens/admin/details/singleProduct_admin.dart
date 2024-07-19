// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/category_api.dart';
import 'package:hadja_grish/api/product_admin_api.dart';
import 'package:hadja_grish/models/articles_model.dart';
import 'package:hadja_grish/models/categorie_model.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class SingleProductAdmin extends StatefulWidget {
  final ArticlesModel article;
  const SingleProductAdmin({super.key, required this.article});

  @override
  State<SingleProductAdmin> createState() => _SingleProductAdminState();
}

class _SingleProductAdminState extends State<SingleProductAdmin> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  ServicesAPiProducts api = ServicesAPiProducts();
  ServicesApiCategory apiCatego = ServicesApiCategory();
  List<CategoriesModel> _listCategories = [];

  //coisir image depuis gallerie de phone
  final picker = ImagePicker();
  File? _imageProduct;
  final List<File> _gallery = [];

  final _nameController = TextEditingController();
  String? _categoryController;
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
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
        _gallery.add(File(images!.path));
      });
    } on Exception catch (e) {
      Exception(e.toString());
    }
  }

  Future<void> _sendToServer() async {
    if (_globalKey.currentState!.validate()) {
      List<MultipartFile> imageFiles = [];
      for (var asset in _gallery) {
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
        "categorie": _categoryController,
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
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text(widget.article.name),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_rounded, size: 28)),
       
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                    padding: const EdgeInsets.all(15),
                    child: Image.asset(
                      widget.article.img,
                      width: 200,
                      height: 200,
                    )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("Nom",style: GoogleFonts.roboto(fontSize:20),),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(widget.article.name,style: GoogleFonts.roboto(fontSize:16,color:Colors.grey)),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Prix",style: GoogleFonts.roboto(fontSize:20),),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(widget.article.price.toString(),style: GoogleFonts.roboto(fontSize:16,color:Colors.grey)),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Stocks",style: GoogleFonts.roboto(fontSize:20),),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(widget.article.stock.toString(),style: GoogleFonts.roboto(fontSize:16,color:Colors.grey)),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Categories",style: GoogleFonts.roboto(fontSize:20),),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(widget.article.category,style: GoogleFonts.roboto(fontSize:16,color:Colors.grey)),
                      ],
                    )
                  ],
                )
              ],
            ),
            Column(
              children: [
                Padding(padding: const EdgeInsets.all(15), 
                child: Text("Gallerie",style:GoogleFonts.roboto(fontSize:20)),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.article.galerie.map((element){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 120,
                            height: 120,
                            child: Image.asset(element,)
                          ),
                        );
                      }).toList()
                    ),
              ],
            ),
            Padding(padding: const EdgeInsets.only(top:55), 
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, 
                minimumSize: const Size(350, 50)
              ),
              onPressed: (){
                _updatedProducts(context);
              },
              icon: const Icon(Icons.edit_note, size: 28,color: Colors.white),
              label: Text("modifier",style:GoogleFonts.roboto(fontSize:20,color: Colors.white)),)
            )
          ],
        ),
      ),
    );
  }

  void _updatedProducts(BuildContext context) {
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
          const SizedBox(height: 15),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D1A30),
              minimumSize: const Size(400, 50),
            ),
            onPressed: () => _sendToServer(),
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
    );
  }
}
