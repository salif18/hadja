
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/models/categorie_model.dart';
import 'package:hadja_grish/screens/admin/categories/categorie_list.dart';
import 'package:hadja_grish/screens/categories/categorie_product.dart';

class MyChooseCategoryWidget extends StatefulWidget {
  final listCategories;
  const MyChooseCategoryWidget({super.key, required this.listCategories});

  @override
  State<MyChooseCategoryWidget> createState() => _MyChooseCategoryState();
}

class _MyChooseCategoryState extends State<MyChooseCategoryWidget> {
 

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: SizedBox(
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Categories",
                      style: GoogleFonts.roboto(
                          fontSize: 24, fontWeight: FontWeight.w400)),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 22)
                ],
              ),
            ),
            Expanded(
                child: StreamBuilder<List<CategoriesModel>>(
                    stream: widget.listCategories.stream,
                    builder: (context, snaptshot) {
                      if (snaptshot.hasError) {
                        return const Center(
                          child: Text("Error"),
                        );
                      } else if (!snaptshot.hasData ||
                          snaptshot.data!.isEmpty) {
                        return Container(
                          alignment: Alignment.center,
                          child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MyCategoriList()));
                              },
                              icon: const Icon(Icons.add)),
                        );
                      } else {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snaptshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            final marque = snaptshot.data![index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> ArticleByCategories(categorie:marque.nameCategorie)));
                              },
                              child: Container(
                                height: 50,
                                width: 120,
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: const Color(0xFF1D1A30),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      marque.nameCategorie,
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    })),
          ],
        ),
      ),
    );
  }
}
