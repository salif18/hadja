import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:hadja_grish/screens/products_admin/details/singleProduct_admin.dart';
import 'package:image_picker/image_picker.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
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
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 28)
        ),
        title: Text("Produits",
          style: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w400)
        ),
        actions: [
          IconButton(
            onPressed: () {
              _addProducts(context);
            },
            icon: const Icon(Icons.add, size: 28)
          ),
          const SizedBox(width: 20)
        ],
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [],
          ),
        )
      ),
    );
  }

  // Fenêtre qui ouvre l'ajout de produits
  _addProducts(BuildContext context) {
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
                  child: Text("Ajouter produits",
                    style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w400)
                  ),
                ),
              ),
              _formulaires(context),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D1A30),
                  minimumSize: const Size(400, 50)
                ),
                onPressed: () {},
                child: Text("Enregistrer",
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.white
                  )
                )
              )
            ],
          ),
        );
      }
    );
  }

  // Formulaires
  _formulaires(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: _pickImage,
              child: InputDecorator(
                decoration: InputDecoration(
                  hintText: "Photo",
                  hintStyle: GoogleFonts.roboto(fontSize: 18, color: Colors.grey),
                  prefixIcon: const Icon(Icons.image, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  )
                ),
                child: _image == null
                  ? Text("Aucune image sélectionnée")
                  : Image.file(_image!, height: 100),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Nom du produit",
                hintStyle: GoogleFonts.roboto(fontSize: 18, color: Colors.grey),
                prefixIcon: const Icon(Icons.pix_rounded, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Categories",
                hintStyle: GoogleFonts.roboto(fontSize: 18, color: Colors.grey),
                prefixIcon: const Icon(Icons.category_rounded, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Description",
                hintStyle: GoogleFonts.roboto(fontSize: 18, color: Colors.grey),
                prefixIcon: const Icon(Icons.list, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "prix",
                hintStyle: GoogleFonts.roboto(fontSize: 18, color: Colors.grey),
                prefixIcon: const Icon(Icons.monetization_on_rounded, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Stock",
                hintStyle: GoogleFonts.roboto(fontSize: 18, color: Colors.grey),
                prefixIcon: const Icon(Icons.store_mall_directory_sharp, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                )
              ),
            ),
          ),
        ],
      )
    );
  }

  // Fenêtre qui ouvre le détail du produit
  _showSingleProduct(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: SingleProductAdmin(),
        );
      }
    );
  }
}
