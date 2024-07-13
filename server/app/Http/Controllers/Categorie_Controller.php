<?php

namespace App\Http\Controllers;

use App\Models\Categorie;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class Categorie_Controller extends Controller
{
    //ajouter
      //AJOUT DE NOUVEAUX CATEGORIES
      public function createCategorys(Request $req){
        try{
         $data = $req->all();
   
         $verifyField = Validator::make($data,[
            "name_categorie"=>"required|string"
         ]);
   
         if($verifyField->fails()){
           return response()->json([
               "status"=>false,
               "message"=>"Veuillez ajouter la categorie .",
            ]);
         }
   
         $categorie = Categorie::create($data);
   
         return response()->json([
           "status"=>true,
           "message"=>"Categorie ajouté .",
           "categories"=>$categorie
        ],201);
   
        }catch(\Exception $error){
           return response()->json([
              "status"=>false,
              "message"=>"Erreur survenue l'ors de la requette .",
              "error"=> $error->getMessage()
           ],500);
       }
      }
   
      //RECUPERER CATEGORIES
      public function getCategorys(){
          try{
             $categories = Categorie::all();
   
             return response()->json([
               "status"=>true,
               "categories"=>$categories
             ],200);
   
          }catch(\Exception $error){
           return response()->json([
               "status"=>false,
               "message"=>"Erreur survenue l'ors de la requette .",
               "error"=> $error->getMessage()
           ],500);
          }
      }
}
