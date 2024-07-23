class Galleries {
  int id;
  int articleId;
  String imgPath;

  Galleries({
    required this.id,
    required this.articleId,
    required this.imgPath,
  });

  factory Galleries.fromJson(Map<String, dynamic> json) {
    return Galleries(
      id: json['id'],
      articleId: json['article_id'],
      imgPath: completeImageUrl(json['img_path']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'article_id': articleId,
      'img_path': imgPath,
    };
  }

  static String completeImageUrl(String imgPath) {
    const String baseUrl =
        "http://10.0.2.2:8000"; // Remplacez par l'URL de base de votre serveur
    return imgPath.startsWith("http") ? imgPath : baseUrl + imgPath;
  }
}

class ArticlesModel {
  int id;
  String name;
  String img;
  String categorie;
  String desc;
  int price;
  int stock;
  int likes;
  int dislikes;
  List<Galleries> galleries;

  ArticlesModel({
    required this.id,
    required this.name,
    required this.img,
    required this.categorie,
    required this.desc,
    required this.price,
    required this.stock,
    required this.likes,
    required this.dislikes,
    required this.galleries,
  });

  factory ArticlesModel.fromJson(Map<String, dynamic> json) {
    return ArticlesModel(
      id: json['id'],
      name: json['name'],
      img: completeImageUrl(json['img']),
      categorie: json['categorie'],
      desc: json['desc'],
      price: json['price'],
      stock: json['stock'],
      likes: json['likes'],
      dislikes: json['disLikes'],
      galleries: (json['galleries'] as List)
          .map((galleryJson) => Galleries.fromJson(galleryJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'img': img,
      'categorie': categorie,
      'desc': desc,
      'price': price,
      'stock': stock,
      'likes': likes,
      'disLikes': dislikes,
      'galleries': galleries.map((gallerie) => gallerie.toJson()).toList(),
    };
  }

  static String completeImageUrl(String imgPath) {
    const String baseUrl =
        "http://10.0.2.2:8000"; // Remplacez par l'URL de base de votre serveur
    return imgPath.startsWith("http") ? imgPath : baseUrl + imgPath;
  }
}
