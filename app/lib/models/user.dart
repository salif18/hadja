class ModelUser {
  final String? userId;
  final String? name;
  final String? photo;
  final String? number;
  final String? email;
  final String? statut;

  ModelUser({
    required this.userId, 
    required this.name, 
    required this.photo, 
    required this.number,
    required this.email, 
    required this.statut});

 factory ModelUser.fromJson(Map<String, dynamic> json) {
  return ModelUser(
    userId: json["id"].toString(), 
    name: json["name"] ?? "", 
    photo: json["photo"], 
    number: json["phone_number"] ?? "",
    email: json["email"] ?? "",
    statut:json["user_statut"]
  );
}
Map<String, dynamic> toJson() {
    return {
      "userId":userId,
      "name": name,
      "photo": photo,
      "number": number,
      "email": email,
      "statut":statut
    };
  }
}
