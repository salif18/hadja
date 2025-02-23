class CategoriesModel{
  final String? id;
  final String nameCategorie ;
  CategoriesModel({
    required this.id,
    required this.nameCategorie
  });

factory CategoriesModel.fromJson(Map<String,dynamic> json){
  return CategoriesModel(
    id: json["_id"],
    nameCategorie: json["name_categorie"]
    );
}

Map<String,dynamic> toJson(){
  return {
    "_id":id,
    "name_categorie":nameCategorie
  };
}
}