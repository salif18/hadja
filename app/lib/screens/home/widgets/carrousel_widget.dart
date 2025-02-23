import 'dart:async' show Future, StreamController;
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/product_admin_api.dart';
import 'package:hadja_grish/constants/app_color.dart';
import 'package:hadja_grish/constants/app_size.dart';
import 'package:hadja_grish/models/articles_model.dart';
import 'package:hadja_grish/screens/home/details/single_product_sliver.dart';

class MyCarouselWidget extends StatefulWidget {
  final constraints;
  const MyCarouselWidget({super.key,required this.constraints});

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getProducts();
  }

  @override
  void dispose() {
    _articlesData.close();
    super.dispose();
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
      padding:  EdgeInsets.all(0.0),
      child: Container(
        padding: EdgeInsets.only(top: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
              child: Container(
                  padding: EdgeInsets.only(left: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15), bottom: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Nouveaux arrivages",
                    style: GoogleFonts.roboto(
                        fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 14), color:AppColor.textColor, fontWeight: FontWeight.w600),
                  )),
            ),
            StreamBuilder<List<ArticlesModel>>(
                stream: _articlesData.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Problème de chargement...",style: GoogleFonts.roboto(fontSize:widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12)));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text("Pas de données disponibles",style: GoogleFonts.roboto(fontSize:widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12)),);
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
                            height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 150),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
                                color: AppColor.secondBackgroud,
                                image: DecorationImage(
                                    image: NetworkImage(item.img ?? ""),
                                    fit: BoxFit.contain)),
                          ),
                        );
                      }).toList(),
                      options: CarouselOptions(
                          height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 150),
                          enlargeCenterPage: true,
                          aspectRatio: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 16) / 9,
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
            SizedBox(height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
            DotsIndicator(
              dotsCount: 5,
              position: currentIndex.toInt(),
              decorator: DotsDecorator(
                  size: Size(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 10), widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 10)),
                  activeSize: Size(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 40), widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 10)),
                  color: Colors.grey[400]!,
                  activeColor: AppColor.colorBackground,
                  //const Color.fromARGB(255, 5, 191, 100),
                  spacing: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 3)),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 5)),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 5)),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
