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
  final constraints;
  const SingleProductAdmin({super.key, required this.article,required this.constraints});

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
        toolbarHeight: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,50),
        title: Text(
          widget.article.name,
          style: GoogleFonts.roboto(fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,16), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_rounded, size: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,24)),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showRemoveArticle();
            },
            icon: Icon(Icons.delete, size: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,24)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context,15)),
                  child: Image.network(
                    widget.article.img,
                    width: widget.constraints.maxWidth ,
                    height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,170),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context,15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Nom",
                            style: GoogleFonts.roboto(fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,14), fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,20)),
                          Text(widget.article.name,
                              style: GoogleFonts.roboto(
                                  fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,12), color: Colors.grey)),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Prix",
                            style: GoogleFonts.roboto(fontSize:widget.constraints.maxWidth * AppSizes.converValueToadapter(context,14), fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,20)),
                          Text(widget.article.price.toString(),
                              style: GoogleFonts.roboto(
                                  fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,12), color: Colors.grey)),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Stocks",
                            style: GoogleFonts.roboto(fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,14), fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,20)),
                          Text(
                              widget.article.stock > 0
                                  ? widget.article.stock.toString()
                                  : "finis",
                              style: GoogleFonts.roboto(
                                  fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,12), color: Colors.grey)),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Categories",
                            style: GoogleFonts.roboto(fontSize:widget.constraints.maxWidth * AppSizes.converValueToadapter(context,14),fontWeight: FontWeight.bold),
                          ),
                         SizedBox(width: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,20)),
                          Text(widget.article.categorie,
                              style: GoogleFonts.roboto(
                                  fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,12), color: Colors.grey)),
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
                  padding: EdgeInsets.symmetric(vertical: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,15)),
                  child:
                      Text("Gallerie", style: GoogleFonts.roboto(fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,14))),
                ),
                SizedBox(
                  height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,120), // Par exemple, définissez une hauteur fixe
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.article.galleries.length,
                    itemBuilder: (context, int index) {
                      final image = widget.article.galleries[index];
                      return Padding(
                        padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context,8)),
                        child: SizedBox(
                          width: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,115),
                          height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,120),
                          child: Image.network(image.imgPath),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context,15)),
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
              padding:EdgeInsets.only(top: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,55)),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size(widget.constraints.maxWidth * AppSizes.converValueToadapter(context,350), widget.constraints.maxWidth * AppSizes.converValueToadapter(context,40)),
                ),
                onPressed: () {
                  _updatedProducts(context, widget.article);
                },
                icon:
                    Icon(Icons.edit_note, size: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,24), color: Colors.white),
                label: Text("Modifier",
                    style:
                        GoogleFonts.roboto(fontSize:widget.constraints.maxWidth * AppSizes.converValueToadapter(context,12), color: Colors.white)),
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
          padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context,15)),
          height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,360),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,80),
                  child: Center(
                    child: Text(
                      "Modifier produits",
                      style: GoogleFonts.roboto(
                          fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,14), fontWeight: FontWeight.w400),
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
            SizedBox(height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,16)),
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
             SizedBox(height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,16)),
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
            SizedBox(height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,16)),
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
            SizedBox(height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,16)),
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
            SizedBox(height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text("Image du produit",
                        style: GoogleFonts.roboto(fontSize: AppSizes.fontMedium)),
                    IconButton(
                      icon: Icon(Icons.photo_camera_back_outlined,
                          size: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,28)),
                      onPressed: () {
                        _getImageToGalleriePhone();
                      },
                    ),
                  ],
                ),
                if (_articleImage != null)
                  Image.file(File(_articleImage!.path),
                      width: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,100), 
                      height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,100)),
              ],
            ),
            SizedBox(height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,16)),
            Column(
              children: [
                Text("Ajouter des images à la galerie",
                    style: GoogleFonts.roboto(fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,14))),
                IconButton(
                  icon:Icon(Icons.photo_library_outlined, size: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,28)),
                  onPressed: () {
                    _selectMultiImageGallery();
                  },
                ),
              ],
            ),
             SizedBox(height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,16)),
            if (gallerieImages != null && gallerieImages!.isNotEmpty)
              SizedBox(
                height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,100),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: gallerieImages?.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context,8)),
                      child: Image.file(File(gallerieImages![index].path),
                          width: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,100), height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,100)),
                    );
                  },
                ),
              ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D1A30),
                minimumSize: Size(widget.constraints.maxWidth * AppSizes.converValueToadapter(context,400), widget.constraints.maxWidth * AppSizes.converValueToadapter(context,40)),
              ),
              onPressed: () {
                if (_globalKey.currentState?.validate() == true) {
                  _sendToServer();
                }
              },
              child: Text("Ajouter",
                  style: GoogleFonts.roboto(fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,12), color: Colors.white)),
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
        height: widget.constraints.maxWidth / 5,
        padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context,15)),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.delete),
              title: Text(
                "Supprimer cet article ?",
                style: GoogleFonts.roboto(fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context,12)),
              ),
              subtitle: Text(
                "Attention! Cette action est irréversible",
                style: GoogleFonts.roboto(fontSize:  widget.constraints.maxWidth * AppSizes.converValueToadapter(context,12), color: Colors.red),
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
                    style: GoogleFonts.roboto(fontSize:  widget.constraints.maxWidth * AppSizes.converValueToadapter(context,12), color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Annuler",
                    style: GoogleFonts.roboto(fontSize:  widget.constraints.maxWidth * AppSizes.converValueToadapter(context,12), color: Colors.blue),
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
