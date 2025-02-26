import 'dart:convert';

class NotificationModel {
  final String? orderId;
  final String? username;
  final String message;
  final bool read;
  final DateTime createdAt;
  final String? id;

  NotificationModel({
    required this.orderId,
    required this.username,
    required this.message,
    required this.read,
    required this.createdAt,
    required this.id,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      orderId: json['orderId'] ?? "",
      username: json["username"] ?? "",
      message: json['message'],
      read: json['read'],
      createdAt: DateTime.parse(json['createdAt']),
      id: json['_id'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'username':username,
      'message': message,
      'read': read,
      'createdAt': createdAt.toIso8601String(),
      '_id': id,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
