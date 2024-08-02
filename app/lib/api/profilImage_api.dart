import 'package:dio/dio.dart';
const String domaineApi = "http://10.0.2.2:8000/api";

class ServicesApiProfil{
  Dio dio = Dio();
  // fonction de connection
  postPhotoProfil(data)async{
    var url = "$domaineApi/profil/photo";
    return await dio.post(url, 
    data:data, 
     options: Options(headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br",
    }));
  }

  // fonction de connection
  putPhotoProfil(data)async{
    var url = "$domaineApi/profil/update/photo";
    return await dio.put(url, 
    data:data, 
     options: Options(headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br",
    }));
  }
}