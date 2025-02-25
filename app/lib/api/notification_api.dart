import 'dart:convert';
import 'package:hadja_grish/http/domaine.dart';
import 'package:http/http.dart' as http;

const String domaineName = AppDomaine.domaine;
class NotificationServices{

  postNotifications(data)async{
    var uri = "$domaineName/notifications/send-notification";
    return await http.post(Uri.parse(uri),
    body: jsonEncode(data),
     headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer "
          },
    );
  }

  getNotifications(userId)async{
    var uri = "$domaineName/notifications/$userId";
    return await http.get(Uri.parse(uri),
     headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer "
          },
    );
  }

  readMarkNotifications(userId,notificationId)async{
    var uri = "$domaineName/notifications/mark-as-read/$userId/$notificationId'";
    return await http.put(Uri.parse(uri),
     headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer "
          },
    );
  }

}