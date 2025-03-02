import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/auth_api.dart';
import 'package:hadja_grish/api/category_api.dart';
import 'package:hadja_grish/api/notification_api.dart';
import 'package:hadja_grish/components/drawer.dart';
import 'package:hadja_grish/constants/app_size.dart';
import 'package:hadja_grish/models/categorie_model.dart';
import 'package:hadja_grish/providers/auth_provider.dart';
import 'package:hadja_grish/providers/cart_provider.dart';
import 'package:hadja_grish/screens/cart/views/cart_page.dart';
import 'package:hadja_grish/screens/favorites/views/favorites_page.dart';
import 'package:hadja_grish/screens/home/widgets/carrousel_widget.dart';
import 'package:hadja_grish/screens/home/widgets/categori_section_widget.dart';
import 'package:hadja_grish/screens/home/widgets/header_widget.dart';
import 'package:hadja_grish/screens/home/widgets/productlist_widget.dart';
import 'package:hadja_grish/screens/home/widgets/recomaded_widget.dart';
import 'package:hadja_grish/screens/home/widgets/search_section_widget.dart';
import 'package:hadja_grish/screens/notifications/notification.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

  ServicesApiCategory api = ServicesApiCategory();
  final ServicesApiAuth apiAuth = ServicesApiAuth();
  final NotificationServices apiNoti = NotificationServices();
  int count = 0;

  final StreamController<List<CategoriesModel>> _listCategories =
      StreamController<List<CategoriesModel>>();

  @override
  void initState() {
    _setupFirebaseMessaging();
    _getCategories();
    _getNotificationNoRead();
    super.initState();
  }

  void _getNotificationNoRead() async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    final userId = await provider.userId();
    try {
      final res = await apiNoti.getCountNotificationsNoRead(userId);
      final body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        setState(() {
          count = body["count"];
        });
      } else {
        setState(() {
          count = 0;
        });
      }
    } catch (e) {
      print(e); // Affiche l'erreur pour le debug
    }
  }

  @override
  void dispose() {
    _listCategories.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getCategories();
  }

  Future<void> _getCategories() async {
    try {
      final res = await api.getCategories();
      final body = res.data;
      if (res.statusCode == 200) {
        List<CategoriesModel> converDataToModelCategorie =
            (body["categories"] as List)
                .map((json) => CategoriesModel.fromJson(json))
                .toList();
        converDataToModelCategorie
            .sort((a, b) => a.nameCategorie.compareTo(b.nameCategorie));
        _listCategories.add(converDataToModelCategorie);
      }
    } catch (e) {
      Exception(e);
    }
  }

  // Enregistrer le token FCM de telephone de utilisateur
  Future<void> _setupFirebaseMessaging() async {
    final provider = Provider.of<AuthProvider>(context, listen: false);

    String? userId = await provider.userId();
    if (userId == null || userId.trim().isEmpty) {
      print("Impossible d'envoyer le token, userId est null ou vide.");
      return;
    }

    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token == null || token.trim().isEmpty) {
        print(
            "Impossible d'envoyer le token, Firebase n'a pas généré de token.");
        return;
      }

      print("Firebase Token: $token");

      final res = await apiAuth.postTokenFmcUser(userId, token);
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        print("Token enregistré avec succès : ${body["message"]}");
      }
    } catch (e) {
      print("Erreur lors de l'envoi du token FCM : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: drawerKey,
      drawer: const DrawerWindow(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.1,
        toolbarHeight: MediaQuery.of(context).size.width * 50 / 360,
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            drawerKey.currentState!.openDrawer();
          },
          icon: Icon(
            Icons.sort,
            size: MediaQuery.of(context).size.width * 24 / 360,
            color: Colors.white,
          ),
        ),
        title: Text(
          "HadjaStore",
          style: GoogleFonts.aladin(
            fontSize: MediaQuery.of(context).size.width * 22 / 360,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartPage(),
                    ),
                  );
                },
                icon: Icon(
                  FontAwesomeIcons.cartShopping,
                  size: MediaQuery.of(context).size.width * 20 / 360,
                  color: Colors.white,
                ),
              ),
              Consumer<CartProvider>(
                builder: (context, provider, child) {
                  return FutureBuilder(
                      future: provider.loadCartFromLocalStorage(),
                      builder: (context, snaptshot) {
                        if (provider.myCart.isNotEmpty) {
                          return Positioned(
                            left: MediaQuery.of(context).size.width * 25 / 360,
                            bottom:
                                MediaQuery.of(context).size.width * 25 / 360,
                            child: Badge.count(
                              count: provider.nombreArticles,
                              backgroundColor: Colors.amber,
                              largeSize: (MediaQuery.of(context).size.width *
                                      30 /
                                      360) /
                                  2,
                              textStyle: GoogleFonts.roboto(
                                fontSize: MediaQuery.of(context).size.width *
                                    12 /
                                    360,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      });
                },
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesPage(),
                ),
              );
            },
            icon: Icon(
              FontAwesomeIcons.heart,
              size: MediaQuery.of(context).size.width * 20 / 360,
              color: Colors.white,
            ),
          ),
          Stack(children: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationView()));
                },
                icon: Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.width * 22 / 360,
                )),
            if (count != 0)
              Positioned(
                left: MediaQuery.of(context).size.width * 25 / 360,
                bottom: MediaQuery.of(context).size.width * 25 / 360,
                child: Badge.count(
                  count: count,
                  backgroundColor: Colors.amber,
                  largeSize: (MediaQuery.of(context).size.width * 30 / 360) / 2,
                  textStyle: GoogleFonts.roboto(
                    fontSize: MediaQuery.of(context).size.width * 12 / 360,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
          ]),
          SizedBox(
            width: MediaQuery.of(context).size.width * 15 / 360,
          )
        ],
      ),
      backgroundColor: const Color(0xFF1D1A30),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    MyHeaderWidget(constraints: constraints),
                    MySearchSectionWidget(constraints: constraints),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 25)),
                      topRight: Radius.circular(constraints.maxWidth *
                          AppSizes.converValueToadapter(context, 25)),
                    ),
                  ),
                  child: Column(
                    children: [
                      MyCarouselWidget(constraints: constraints),
                      MyChooseCategoryWidget(
                          listCategories: _listCategories,
                          constraints: constraints),
                      MyRecomadationWidget(constraints: constraints),
                      MyProductListWidget(constraints: constraints),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
