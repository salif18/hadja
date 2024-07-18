import 'package:hadja_grish/models/cart_item_model.dart';

class OrdersModel{
 final String orderId;
 final String userId;
 final String? deliberyId;
 final String address;
 double?  latitude;
 double?  longitude;
 final String? tel;
 final int total;
 bool statutOfdelivery;
 List<CartItemModel> articles;

 OrdersModel({
    required this.orderId,
    required this.userId, 
    required this.deliberyId, 
    required this.address, 
    required this.latitude,
    required this.longitude, 
    required this.tel, 
    required this.total, 
    required this.statutOfdelivery, 
    required this.articles
 });

 factory OrdersModel.fromJson(Map<String, dynamic> json){
  return OrdersModel(
    orderId: json['userId'], 
    userId: json["userId"], 
    deliberyId: json["deliberyId"], 
    address: json["address"], 
    latitude: json['latitude'], 
    longitude: json['longitude'], 
    tel: json['tel'], 
    total: json['total'], 
    statutOfdelivery: json['livrer'], 
    articles: (json['articles'] as List).map((json)=> CartItemModel.fromJson(json)).toList());
 }

 Map<String ,dynamic> toJson(){
  return {
    "orderId":orderId,
    "userId":userId,
    "deliberyId":deliberyId,
    "address":address, 
    "latitude":latitude,
    "longitude":longitude,
    "tel":tel ,
    "total":total, 
    "statutOfdelivery":statutOfdelivery ,
    "articles":articles
  };
 }
}