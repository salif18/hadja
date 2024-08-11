// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/category_api.dart';
import 'package:hadja_grish/api/product_admin_api.dart';
import 'package:hadja_grish/constants/app_size.dart';
import 'package:hadja_grish/models/articles_model.dart';
import 'package:hadja_grish/models/categorie_model.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:readmore/readmore.dart';

class SingleProductAdmin extends StatefulWidget {
  final ArticlesModel article;
  const SingleProductAdmin({super.key, required this.article});

  @override
  State<SingleProductAdmin> createState() => _SingleProductAdminState();
}

class _SingleProductAdminState extends State<SingleProductAdmin> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final ServicesAPiProducts api = ServicesAPiProducts();
  final ServicesApiCategory apiCatego = ServicesApiCategory();
  List<CategoriesModel> _listCategories = [];

  final ImagePicker _picker = ImagePicker();
  XFile? _articleImage;
  List<XFile>? gallerieImages = [];

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
      print(e);
    }
  }

  Future<void> _removeArticles() async {
    try {
      final res = await api.deleteProduct(widget.article.id);
      if (res.statusCode == 200) {
        Navigator.pop(context);
      } else {
        api.showSnackBarErrorPersonalized(context, res.data["message"]);
      }
    } catch (e) {
      api.showSnackBarErrorPersonalized(context, e.toString());
    }
  }

  Future<void> _getImageToGalleriePhone() async {
    final XFile? imagePicked =
        await _picker.pickImage(source: ImageSource.gallery);
    if (imagePicked != null) {
      setState(() {
        _articleImage = imagePicked;
      });
    }
  }

  Future<void> _selectMultiImageGallery() async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        setState(() {
          gallerieImages?.addAll(pickedFiles);
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _sendToServer() async {
    List<MultipartFile> imageFilesPaths = [];
    for (var image in gallerieImages!) {
      imageFilesPaths.add(await MultipartFile.fromFile(image.path,
          filename: image.path.split("/").last));
    }

    FormData formData = FormData.fromMap({
      "name": _nameController.text,
      "img": await MultipartFile.fromFile(_articleImage!.path,
          filename: _articleImage!.path.split("/").last),
      "galleries": imageFilesPaths,
      "categorie": _categoryController,
      "desc": _descController.text,
      "stock": _stockController.text,
      "price": _priceController.text,
      "likes": 0,
      "disLikes": 0
    });

    try {
      final res = await api.updateProduct(formData, widget.article.id);
      if (res.statusCode == 201) {
        api.showSnackBarSuccessPersonalized(context, res.data["message"]);
        Navigator.pop(context);
      } else {
        api.showSnackBarErrorPersonalized(context, res.data["message"]);
      }
    } catch (e) {
      api.showSnackBarErrorPersonalized(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text(
          widget.article.name,
          style: GoogleFonts.roboto(fontSize: AppSizes.fontLarge, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_rounded, size: AppSizes.iconLarge),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showRemoveArticle();
            },
            icon: const Icon(Icons.delete, size: AppSizes.iconLarge),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Image.network(
                    widget.article.img,
                    width: double.infinity,
                    height: 180,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Nom",
                            style: GoogleFonts.roboto(fontSize: AppSizes.fontMedium, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 20),
                          Text(widget.article.name,
                              style: GoogleFonts.roboto(
                                  fontSize: AppSizes.fontSmall, color: Colors.grey)),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Prix",
                            style: GoogleFonts.roboto(fontSize: AppSizes.fontMedium, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 20),
                          Text(widget.article.price.toString(),
                              style: GoogleFonts.roboto(
                                  fontSize: AppSizes.fontSmall, color: Colors.grey)),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Stocks",
                            style: GoogleFonts.roboto(fontSize: AppSizes.fontMedium, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 20),
                          Text(
                              widget.article.stock > 0
                                  ? widget.article.stock.toString()
                                  : "finis",
                              style: GoogleFonts.roboto(
                                  fontSize: AppSizes.fontSmall, color: Colors.grey)),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Categories",
                            style: GoogleFonts.roboto(fontSize: AppSizes.fontMedium,fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 20),
                          Text(widget.article.categorie,
                              style: GoogleFonts.roboto(
                                  fontSize: 14, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child:
                      Text("Gallerie", style: GoogleFonts.roboto(fontSize: AppSizes.fontMedium)),
                ),
                SizedBox(
                  height: 120, // Par exemple, définissez une hauteur fixe
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.article.galleries.length,
                    itemBuilder: (context, int index) {
                      final image = widget.article.galleries[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 115,
                          height: 120,
                          child: Image.network(image.imgPath),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(15),
                    child: ReadMoreText(
                      widget.article.desc,
                      trimLines: 2,
                      colorClickableText: Colors.blue[400],
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'Voir plus',
                      trimExpandedText: ' réduire',
                      style: TextStyle(
                        color: const Color(0xFF1D1A30).withOpacity(0.7),
                        height: 1.5,
                      ),
                    ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 55),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(350, 50),
                ),
                onPressed: () {
                  _updatedProducts(context, widget.article);
                },
                icon:
                    const Icon(Icons.edit_note, size: AppSizes.iconLarge, color: Colors.white),
                label: Text("Modifier",
                    style:
                        GoogleFonts.roboto(fontSize: AppSizes.fontSmall, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updatedProducts(BuildContext context, ArticlesModel article) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(15),
          height: MediaQuery.of(context).size.height * 0.95,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 80,
                  child: Center(
                    child: Text(
                      "Modifier produits",
                      style: GoogleFonts.roboto(
                          fontSize: AppSizes.fontLarge, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                _formulaires(context, article),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _formulaires(BuildContext context, ArticlesModel article) {
    _nameController.text = article.name;
    _categoryController = article.categorie;
    _descController.text = article.desc;
    _stockController.text = article.stock.toString();
    _priceController.text = article.price.toString();

    return Form(
      key: _globalKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                  labelText: "Nom du produit", border: OutlineInputBorder()),
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
              decoration: const InputDecoration(
                  labelText: "Description du produit",
                  border: OutlineInputBorder()),
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
              decoration: const InputDecoration(
                  labelText: "Prix du produit", border: OutlineInputBorder()),
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
              decoration: const InputDecoration(
                  labelText: "Stock du produit", border: OutlineInputBorder()),
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
              decoration: const InputDecoration(
                  labelText: "Catégorie du produit",
                  border: OutlineInputBorder()),
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
                    Text("Image du produit",
                        style: GoogleFonts.roboto(fontSize: AppSizes.fontMedium)),
                    IconButton(
                      icon: const Icon(Icons.photo_camera_back_outlined,
                          size: 38),
                      onPressed: () {
                        _getImageToGalleriePhone();
                      },
                    ),
                  ],
                ),
                if (_articleImage != null)
                  Image.file(File(_articleImage!.path),
                      width: 100, height: 100),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Text("Ajouter des images à la galerie",
                    style: GoogleFonts.roboto(fontSize: AppSizes.fontMedium)),
                IconButton(
                  icon: const Icon(Icons.photo_library_outlined, size: 38),
                  onPressed: () {
                    _selectMultiImageGallery();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (gallerieImages != null && gallerieImages!.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: gallerieImages?.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(File(gallerieImages![index].path),
                          width: 100, height: 100),
                    );
                  },
                ),
              ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D1A30),
                minimumSize: const Size(400, 50),
              ),
              onPressed: () {
                if (_globalKey.currentState?.validate() == true) {
                  _sendToServer();
                }
              },
              child: Text("Ajouter",
                  style: GoogleFonts.roboto(fontSize: AppSizes.fontMedium, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void showRemoveArticle() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height / 5,
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.delete),
              title: Text(
                "Supprimer cet article ?",
                style: GoogleFonts.roboto(fontSize: AppSizes.fontMedium),
              ),
              subtitle: Text(
                "Attention! Cette action est irréversible",
                style: GoogleFonts.roboto(fontSize: AppSizes.fontSmall, color: Colors.red),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    _removeArticles();
                  },
                  child: Text(
                    "Supprimer",
                    style: GoogleFonts.roboto(fontSize: AppSizes.fontMedium, color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Annuler",
                    style: GoogleFonts.roboto(fontSize: AppSizes.fontMedium, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
