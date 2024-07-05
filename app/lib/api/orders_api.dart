import "package:http/http.dart" as http;
const String domaineApi = "http://10.0.2.2:8000/api";
class ServicesApiOrders{
  //obtenir depenses par user jour
  getExpensesUserByDay( userId)async{
    var uri = "$domaineApi/orders/$userId";
    return await http.get(Uri.parse(uri),
     headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "Accept":"*/*",
            "Accept-Encoding":"gzip, deflate, br",
          },
    );
  }
}