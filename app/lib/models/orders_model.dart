class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final String name;
  final String img;
  final int qty;
  final int prix;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.name,
    required this.img,
    required this.qty,
    required this.prix,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: json['order_id'],
      productId: int.parse(json['productId']),
      name: json['name'],
      img: json['img'],
      qty: json['qty'],
      prix: json['prix'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "order_id": orderId,
      "productId": productId,
      "name": name,
      "img": img,
      "qty": qty,
      "prix": prix,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
    };
  }
}

class OrdersModel {
  final int id;
  final String userId;
  final String? deliveryId;
  final String address;
  final double latitude;
  final double longitude;
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
    required this.latitude,
    required this.longitude,
    required this.deliveryLat,
    required this.deliveryLong,
    required this.telephone,
    required this.total,
    required this.statusOfDelibery,
    required this.createdAt,
    required this.updatedAt,
    required this.orderItems,
  });

  factory OrdersModel.fromJson(Map<String, dynamic> json) {
    return OrdersModel(
      id: json['id'],
      userId: json['userId'],
      deliveryId: json['deliberyId'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      deliveryLat: json['deliveryLat'],
      deliveryLong: json['deliveryLong'],
      telephone: json['telephone'],
      total: json['total'],
      statusOfDelibery: json['statut_of_delibery'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      orderItems: (json['order_items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "deliveryId": deliveryId,
      "address": address,
      "latitude": latitude,
      "longitude": longitude,
      "deliveryLat": deliveryLat,
      "deliveryLong": deliveryLong,
      "telephone": telephone,
      "total": total,
      "statut_of_delibery": statusOfDelibery,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
      "order_items": orderItems.map((item) => item.toJson()).toList(),
    };
  }
}
