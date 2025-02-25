import 'dart:convert';

class NotificationModel {
  final String? orderId;
  final String message;
  final bool read;
  final DateTime createdAt;
  final String? id;

  NotificationModel({
    required this.orderId,
    required this.message,
    required this.read,
    required this.createdAt,
    required this.id,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      orderId: json['orderId'] ?? "",
      message: json['message'],
      read: json['read'],
      createdAt: DateTime.parse(json['createdAt']),
      id: json['_id'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
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
