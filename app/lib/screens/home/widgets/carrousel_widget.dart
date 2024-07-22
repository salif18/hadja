import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/product_admin_api.dart';
import 'package:hadja_grish/models/articles_model.dart';
import 'package:hadja_grish/screens/home/details/single_product_sliver.dart';

class MyCarouselWidget extends StatefulWidget {
  const MyCarouselWidget({super.key});

  @override
  State<MyCarouselWidget> createState() => _MyCarouselState();
}

class _MyCarouselState extends State<MyCarouselWidget> {
  final StreamController<List<ArticlesModel>> _articlesData =
      StreamController();
       ServicesAPiProducts api = ServicesAPiProducts();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  @override
  void dispose() {
    _articlesData.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getProducts();
  }

 // fonction fetch data articles depuis server
  Future<void> _getProducts() async {
    try {
      final res = await api.getAllProducts();
      final body = jsonDecode(res.body);
      if(res.statusCode == 200){
      _articlesData.add(
        (body["articles"] as List).map((json)=> ArticlesModel.fromJson(json)).toList()
      );
      }
    } catch (e) {
      _articlesData.addError("");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        padding: const EdgeInsets.only(top: 15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  padding: const EdgeInsets.only(left: 15, bottom: 15),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Nouveaux arrivages",
                    style: GoogleFonts.roboto(
                        fontSize: 24, fontWeight: FontWeight.w400),
                  )),
            ),
            StreamBuilder<List<ArticlesModel>>(
                stream: _articlesData.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("err");
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text("No data available");
                  } else {
                    return CarouselSlider(
                      items: snapshot.data!.take(5).map((item) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SingleProductVerSionSliver(
                                            item: item)));
                          },
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color(0xffF0FCF3),
                                image: DecorationImage(
                                    image: NetworkImage(item.img),
                                    fit: BoxFit.contain)),
                          ),
                        );
                      }).toList(),
                      options: CarouselOptions(
                          height: 200,
                          enlargeCenterPage: true,
                          aspectRatio: 16 / 9,
                          autoPlay: true,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          viewportFraction: 0.8,
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentIndex = index;
                            });
                          }),
                    );
                  }
                }),
            const SizedBox(height: 20),
            DotsIndicator(
              dotsCount: 5,
              position: currentIndex.toInt(),
              decorator: DotsDecorator(
                  size: const Size(12.0, 12.0),
                  activeSize: const Size(40.0, 12.0),
                  color: Colors.grey[400]!,
                  activeColor: const Color(0xFF1D1A30),
                  //const Color.fromARGB(255, 5, 191, 100),
                  spacing: const EdgeInsets.all(3.0),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
