import 'package:hadja_grish/http/domaine.dart';

class ProfilModel {
  final int? userId;
  final String? name;
  final String? photo;
  final int?
      photoId; // Notez l'utilisation de ? pour indiquer que ce champ peut être null
  final String? number;
  final String? email;
  final String? userStatut;

  ProfilModel({
    required this.userId,
    required this.name,
    this.photo, // photo peut être null
    this.photoId, //peut etre null
    required this.number,
    required this.email,
    required this.userStatut,
  });

  factory ProfilModel.fromJson(Map<String, dynamic> json) {
    return ProfilModel(
      userId: json['id'], // Utilisez 'id' au lieu de 'userId'
      name: json['name'],
      photo: json['photo'] != null ? completeImageUrl(json['photo']) : null,
      photoId: json['photoId'] != null ? json['photoId'] : null,
      number:
          json['phone_number'], // Utilisez 'phone_number' au lieu de 'number'
      email: json['email'],
      userStatut:
          json['user_statut'], // Utilisez 'user_statut' au lieu de 'userStatut'
    );
  }
// SEREALISATION INVERSE DES CHAMPS
  Map<String, dynamic> toJson() {
    return {
      'id': userId, // Utilisez 'id' au lieu de 'userId'
      'name': name,
      'photo': photo,
      'photoId': photoId,
      'phone_number': number, // Utilisez 'phone_number' au lieu de 'number'
      'email': email,
      'user_statut':
          userStatut, // Utilisez 'user_statut' au lieu de 'userStatut'
    };
  }

  static String completeImageUrl(String imgPath) {
    String baseUrl = AppDomaine.urlImage;
    return imgPath.startsWith("http") ? imgPath : baseUrl + imgPath;
  }
}
