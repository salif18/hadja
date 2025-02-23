class OrderItem {
  final String? id;
  final String? productId;
  final String? name;
  final String? img;
  final int? qty;
  final int? prix;

  OrderItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.img,
    required this.qty,
    required this.prix,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['_id'] ?? "",
      productId: json['productId'] ?? "",
      name: json['name'] ?? "",
      img: json['img'] ?? "",
      qty: json['qty'] ?? 0,
      prix: json['prix'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "productId": productId,
      "name": name,
      "img": img,
      "qty": qty,
      "prix": prix,
    };
  }
}

class OrdersModel {
  final String id;
  final String userId;
  final String? deliveryId;
  final String address;
  final double clientLat;
  final double clientLong;
  final double? deliveryLat;
  final double? deliveryLong;
  final String telephone;
  final int total;
  final String statusOfDelibery;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderItem> orderItems;

  OrdersModel({
    required this.id,
    required this.userId,
    required this.deliveryId,
    required this.address,
    required this.clientLat,
    required this.clientLong,
    this.deliveryLat,
    this.deliveryLong,
    required this.telephone,
    required this.total,
    required this.statusOfDelibery,
    required this.createdAt,
    required this.updatedAt,
    required this.orderItems,
  });

  factory OrdersModel.fromJson(Map<String, dynamic> json) {
    return OrdersModel(
      id: json['_id'] ?? "",
      userId: json['userId'] ?? "",
      deliveryId: json['deliveryId'],
      address: json['address'] ?? "",
      clientLat: (json['clientLat'] ?? 0.0).toDouble(),
      clientLong: (json['clientLong'] ?? 0.0).toDouble(),
      deliveryLat: json['deliveryLat'] != null ? (json['deliveryLat'] as num).toDouble() : null,
      deliveryLong: json['deliveryLong'] != null ? (json['deliveryLong'] as num).toDouble() : null,
      telephone: json['telephone'] ?? "",
      total: json['total'] ?? 0,
      statusOfDelibery: json['statut_of_delibery'] ?? "En attente",
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      orderItems: (json['cartItems'] as List<dynamic>?)
        ?.map((item) => OrderItem.fromJson(item))
        .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "userId": userId,
      "deliveryId": deliveryId,
      "address": address,
      "clientLat": clientLat,
      "clientLong": clientLong,
      "deliveryLat": deliveryLat,
      "deliveryLong": deliveryLong,
      "telephone": telephone,
      "total": total,
      "statut_of_delibery": statusOfDelibery,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
      "cartItems": orderItems.map((item) => item.toJson()).toList(),
    };
  }
}
