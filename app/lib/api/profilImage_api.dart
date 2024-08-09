import 'package:dio/dio.dart';
import 'package:hadja_grish/http/domaine.dart';
String domaineApi = Domaine().domaine();

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

  // fonction de modification
  updatePhotoProfil(data)async{
    var url = "$domaineApi/profil/photo/update";
    return await dio.post(url, 
    data:data, 
     options: Options(headers: {
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br",
    })
    );
  }

   // fonction de delete
  deletePhotoProfil(data)async{
    var url = "$domaineApi/profil/photo/delete";
    return await dio.delete(url, 
    data:data, 
     options: Options(headers: {
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br",
    })
    );
  }

}