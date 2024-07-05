
import "package:http/http.dart" as http;
const String domaineApi = "http://10.0.2.2:8000/api";

class ServicesApiProducts{
 //obtenir depenses
  getArticles()async{
    var uri = "$domaineApi/articles";
    return await http.get(Uri.parse(uri),
     headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "Accept":"*/*",
            "Accept-Encoding":"gzip, deflate, br",
          },
    );
  }
  //obtenir depenses
  getOneArticles(data) async {
    var uri = "$domaineApi/articles/{}";
    return await http.get(
      Uri.parse(uri),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br",
      },
    );
  }
}