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
  final constraints;
  const MyChooseCategoryWidget(
      {super.key, required this.listCategories, required this.constraints});

  @override
  State<MyChooseCategoryWidget> createState() => _MyChooseCategoryState();
}

class _MyChooseCategoryState extends State<MyChooseCategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: widget.constraints.maxWidth *
              AppSizes.converValueToadapter(context, 8)),
      child: SizedBox(
        height: widget.constraints.maxWidth *
            AppSizes.converValueToadapter(context, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: widget.constraints.maxWidth *
                    AppSizes.converValueToadapter(context, 20),
                vertical: widget.constraints.maxWidth *
                    AppSizes.converValueToadapter(context, 10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Categories",
                      style: GoogleFonts.roboto(
                          fontSize: widget.constraints.maxWidth *
                              AppSizes.converValueToadapter(context, 14),
                          color: AppColor.textColor,
                          fontWeight: FontWeight.w600)),
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: widget.constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 14))
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
                            return Center(
                              child: Text(
                                "Problème de chargement...",
                                style: TextStyle(
                                    fontSize: widget.constraints.maxWidth *
                                        AppSizes.converValueToadapter(
                                            context, 12)),
                              ),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            if (profil?.userStatut == "admin") {
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
                                    icon: Icon(Icons.add)),
                              );
                            } else {
                              return Container(
                                  alignment: Alignment.center,
                                  child: Center(
                                    child: Text("Aucunes catégories dabord..."),
                                  ));
                            }
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
                                    height: widget.constraints.maxWidth *
                                        AppSizes.converValueToadapter(
                                            context, 10),
                                    width: widget.constraints.maxWidth *
                                        AppSizes.converValueToadapter(
                                            context, 120),
                                    margin: EdgeInsets.all(
                                        widget.constraints.maxWidth *
                                            AppSizes.converValueToadapter(
                                                context, 6)),
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            242, 255, 255, 255),
                                        borderRadius: BorderRadius.circular(
                                            widget.constraints.maxWidth *
                                                AppSizes.converValueToadapter(
                                                    context, 10))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          marque.nameCategorie,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.roboto(
                                              fontWeight: FontWeight.w600,
                                              fontSize: widget
                                                      .constraints.maxWidth *
                                                  AppSizes.converValueToadapter(
                                                      context, 12),
                                              color: const Color(0xFF1D1A30)),
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
