class CategoriesModel{
  final String nameCategorie ;
  CategoriesModel({
    required this.nameCategorie
  });

factory CategoriesModel.fromJson(Map<String,dynamic> json){
  return CategoriesModel(nameCategorie: json["name_categorie"]);
}

Map<String,dynamic> toJson(){
  return {
    "name_categorie":nameCategorie
  };
}
}