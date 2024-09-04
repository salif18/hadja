import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:hadja_grish/http/domaine.dart';

  const String domaineName = AppDomaine.domaine;

class ServicesApiStats{
  
Dio dio = Dio();
   //ajouter de categorie pour formulaire
 getStatsWeek()async{
  
    var uri = "$domaineName/orders/stats/week";
    return await dio.get(uri,
     options:Options(headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "Accept":"*/*",
            "Accept-Encoding":"gzip, deflate, br",
          },
    ));
  }
   //obtenir categorie pour formulaire
  getCategories()async{
    var uri = "$domaineName/categories";
    return await dio.get(uri,
     options:Options(headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "Accept":"*/*",
            "Accept-Encoding":"gzip, deflate, br",
          },
    ));
  }
}