import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/constants/app_color.dart';
import 'package:hadja_grish/constants/app_size.dart';
import 'package:hadja_grish/models/categorie_model.dart';
import 'package:hadja_grish/models/user.dart';
import 'package:hadja_grish/providers/user_provider.dart';
import 'package:hadja_grish/screens/admin/categorie_list.dart';
import 'package:hadja_grish/screens/categories/categorie_product.dart';
import 'package:provider/provider.dart';

class MyChooseCategoryWidget extends StatefulWidget {
  final dynamic listCategories;
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
                          fontSize: AppSizes.fontLarge,color:AppColor.textColor ,fontWeight: FontWeight.w600)),
                  const Icon(Icons.arrow_forward_ios_rounded, size: AppSizes.iconMedium)
                ],
              ),
            ),
            Expanded(
              child: Consumer<UserInfosProvider>(
                builder: (context, provider, child) {
                  return FutureBuilder<ProfilModel?>(
                    future: provider.loadProfilFromLocalStorage(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final ProfilModel? profil = snapshot.data;
                      return StreamBuilder<List<CategoriesModel>>(
                        stream: widget.listCategories.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text("Error"),
                            );
                          } else if (!snapshot.hasData ||
                              (snapshot.data!.isEmpty &&
                                  profil!.userStatut == "admin")) {
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
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                final marque = snapshot.data![index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ArticleByCategories(
                                                    categorie:
                                                        marque.nameCategorie)));
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 120,
                                    margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: const Color(0xFF1D1A30),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          marque.nameCategorie,
                                          style: GoogleFonts.roboto(
                                              fontWeight: FontWeight.w400,
                                              fontSize: AppSizes.fontSmall,
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
