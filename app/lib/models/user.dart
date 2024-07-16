class ModelUser {
  final String? name;
  final String? number;
  final String? email;
  final String userStatut;

  ModelUser({required this.name, required this.number, required this.email, required this.userStatut});

 factory ModelUser.fromJson(Map<String, dynamic> json) {
  return ModelUser(
    name: json["name"] ?? "", 
    number: json["phone_number"] ?? "",
    email: json["email"] ?? "",
    userStatut:json["user_statut"].toString() 
  );
}
Map<String, dynamic> toJson() {
    return {
      "name": name,
      "number": number,
      "email": email,
      "userStatut":userStatut
    };
  }
}
