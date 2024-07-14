class Galleries{
  String id;
  String urlImg;
  Galleries({
    required this.id,
    required this.urlImg});

    factory Galleries.fromJson(Map<String,dynamic> json){
      return Galleries(id: json["id"],urlImg: json["urlImg"]);
    }

    Map<String,dynamic> toJson(){
      return {
          "id":id, 
          "urlImg":urlImg
      };
    }
}

class ArticlesModel {
  final String productId;
  final String name;
  final String img;
  final List<String> galerie;
  final String category;
  final String desc;
  final int price;
  final int stock;
  final bool favorite;
  final int likes;

  ArticlesModel(
      {required this.productId,
      required this.name,
      required this.img,
      required this.galerie,
      required this.category,
      required this.desc,
      required this.price,
      required this.stock,
      required this.favorite,
      required this.likes});

  factory ArticlesModel.fromJson(Map<String, dynamic> json) {
    return ArticlesModel(
        productId: json['productId'],
        name: json['name'],
        img: json['img'],
        galerie: json['galerie'],
        category: json['category'],
        desc: json['desc'],
        price: json['price'],
        stock: json['stock'],
        favorite: json['favorite'],
        likes: json['likes']);
  }

  Map<String, dynamic> toJson() {
    return {
      "productId": productId,
      "name": name,
      "img": img,
      "galerie": galerie,
      "category": category,
      "desc": desc,
      "price": price,
      "stock": stock,
      "favorite": favorite,
      "likes": likes
    };
  }

  static List<ArticlesModel> data() {
    return [
      ArticlesModel(
          productId: "1",
          name: "Huile",
          img: "assets/images/prod2.jpeg",
          galerie: [
            "assets/images/prod2.jpeg",
            "assets/images/prod1.jpeg",
            "assets/images/prod3.jpeg",
          ],
          category: "pommade",
          desc:
              "Rayman is stranger to peril, but when a fateful flight puts the owlet ku in harm's way. Ori is stranger to peril, but when a fateful flight puts the owlet ku in harm's way. Ori is stranger to peril, but when a fateful flight puts the owlet ku in harm's way.",
          price: 5000,
          stock: 2,
          favorite: true,
          likes: 10),
      ArticlesModel(
          productId: "2",
          name: "Huile",
          img: "assets/images/prod3.jpeg",
          galerie: [
            "assets/images/prod3.jpeg",
            "assets/images/prod2.jpeg",
            "assets/images/prod1.jpeg",
          ],
          category: "pommade",
          desc:
              "Rayman is stranger to peril, but when a fateful flight puts the owlet ku in harm's way. Ori is stranger to peril, but when a fateful flight puts the owlet ku in harm's way. Ori is stranger to peril, but when a fateful flight puts the owlet ku in harm's way.",
          price: 4000,
          stock: 2,
          favorite: true,
          likes: 10),
      ArticlesModel(
          productId: "3",
          name: "Huile",
          img: "assets/images/prod1.jpeg",
          galerie: [
            "assets/images/prod1.jpeg",
            "assets/images/prod2.jpeg",
            "assets/images/prod3.jpeg",
          ],
          category: "pommade",
          desc:
              "Rayman is stranger to peril, but when a fateful flight puts the owlet ku in harm's way. Ori is stranger to peril, but when a fateful flight puts the owlet ku in harm's way. Ori is stranger to peril, but when a fateful flight puts the owlet ku in harm's way.",
          price: 6000,
          stock: 2,
          favorite: true,
          likes: 10),
      ArticlesModel(
          productId: "4",
          name: "Gadgets",
          img: "assets/images/prod4.jpg",
          galerie: [
            "assets/images/prod4.jpg",
            "assets/images/prod2.jpeg",
            "assets/images/prod5.jpeg",
          ],
          category: "pommade",
          desc:
              "Rayman is stranger to peril, but when a fateful flight puts the owlet ku in harm's way. Ori is stranger to peril, but when a fateful flight puts the owlet ku in harm's way. Ori is stranger to peril, but when a fateful flight puts the owlet ku in harm's way.",
          price: 15000,
          stock: 2,
          favorite: true,
          likes: 10),
      ArticlesModel(
          productId: "5",
          name: "parfum",
          img: "assets/images/prod5.jpeg",
          galerie: [
            "assets/images/prod5.jpeg",
            "assets/images/prod4.jpg",
            "assets/images/prod3.jpeg",
          ],
          category: "pommade",
          desc:
              "Rayman is stranger to peril, but when a fateful flight puts the owlet ku in harm's way. Ori is stranger to peril, but when a fateful flight puts the owlet ku in harm's way. Ori is stranger to peril, but when a fateful flight puts the owlet ku in harm's way.",
          price: 4000,
          stock: 2,
          favorite: true,
          likes: 10),
      ArticlesModel(
          productId: "6",
          name: "Savon",
          img: "assets/images/prod6.jpeg",
          galerie: [
            "assets/images/prod6.jpeg",
            "assets/images/prod7.jpeg",
            "assets/images/prod8.jpeg",
          ],
          category: "pommade",
          desc:
              "Rayman is stranger to peril, but when a fateful flight puts the owlet ku in harm's way. Ori is stranger to peril, but when a fateful flight puts the owlet ku in harm's way. Ori is stranger to peril, but when a fateful flight puts the owlet ku in harm's way.",
          price: 800,
          stock: 2,
          favorite: true,
          likes: 10),
      ArticlesModel(
          productId: "7",
          name: "Savon",
          img: "assets/images/prod7.jpeg",
          galerie: [
            "assets/images/prod7.jpeg",
            "assets/images/prod6.jpeg",
            "assets/images/prod8.jpeg",
          ],
          category: "pommade",
          desc:
              "Rayman is stranger to peril, but when a fateful flight puts the owlet ku in harm's way. Ori is stranger to peril, but when a fateful flight puts the owlet ku in harm's way. Ori is stranger to peril, but when a fateful flight puts the owlet ku in harm's way.",
          price: 1500,
          stock: 2,
          favorite: true,
          likes: 10),
      ArticlesModel(
          productId: "8",
          name: "Savon",
          img: "assets/images/prod8.jpeg",
          galerie: [
            "assets/images/prod8.jpeg",
            "assets/images/prod6.jpeg",
            "assets/images/prod7.jpeg",
          ],
          category: "pommade",
          desc:
              "Rayman is stranger to peril, but when a fateful flight puts the owlet ku in harm's way. Ori is stranger to peril, but when a fateful flight puts the owlet ku in harm's way. Ori is stranger to peril, but when a fateful flight puts the owlet ku in harm's way.",
          price: 1000,
          stock: 2,
          favorite: true,
          likes: 10),
           ArticlesModel(
          productId: "9",
          name: "Nivea",
          img: "assets/images/prod10.jpeg",
          galerie: [
            "assets/images/prod10.jpeg",
            "assets/images/prod11.jpeg",
            "assets/images/prod12.jpeg",
          ],
          category: "pommade",
          desc:
              "Rayman is stranger to peril, but when a fateful flight puts the owlet ku in harm's way. Ori is stranger to peril, but when a fateful flight puts the owlet ku in harm's way. Ori is stranger to peril, but when a fateful flight puts the owlet ku in harm's way.",
          price: 2000,
          stock: 2,
          favorite: true,
          likes: 10),
           ArticlesModel(
          productId: "10",
          name: "Topicrem",
          img: "assets/images/prod13.jpeg",
          galerie: [
            "assets/images/prod13.jpeg",
            "assets/images/prod10.jpeg",
            "assets/images/prod12.jpeg",
          ],
          category: "pommade",
          desc:
              "Rayman is stranger to peril, but when a fateful flight puts the owlet ku in harm's way. Ori is stranger to peril, but when a fateful flight puts the owlet ku in harm's way. Ori is stranger to peril, but when a fateful flight puts the owlet ku in harm's way.",
          price: 8000,
          stock: 2,
          favorite: true,
          likes: 10),
           ArticlesModel(
          productId: "11",
          name: "Axe",
          img: "assets/images/prod12.jpeg",
          galerie: [
            "assets/images/prod12.jpeg",
            "assets/images/prod13.jpeg",
            "assets/images/prod11.jpeg",
          ],
          category: "pommade",
          desc:
              "Rayman is stranger to peril, but when a fateful flight puts the owlet ku in harm's way. Ori is stranger to peril, but when a fateful flight puts the owlet ku in harm's way. Ori is stranger to peril, but when a fateful flight puts the owlet ku in harm's way.",
          price: 2000,
          stock: 2,
          favorite: true,
          likes: 10),
    ];
  }
}
