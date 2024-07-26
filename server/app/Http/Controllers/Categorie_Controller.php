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


       //UPDATE CATEGORIES
      // UPDATE CATEGORIES
public function updateCategorys(Request $req, $id){
   try{
       // Log request data and ID
       error_log(print_r($req->all(), true));
       error_log(print_r($id, true));
       
       // Find the category by ID
       $categorie = Categorie::findOrFail($id);
       
       // Update the category name
       $categorie->update(['name_categorie' => $req->name_categorie]);

       return response()->json([
           'status' => true,
           'categories' => $categorie,
           'message' => 'Categorie modifiée !!'
       ], 201);

   } catch(\Exception $error){
       return response()->json([
           'status' => false,
           'message' => 'Erreur survenue lors de la requête.',
           'error' => $error->getMessage()
       ], 500);
   }
}


       //DELETE CATEGORIES
      // DELETE CATEGORIES
public function removeCategorys($id){
   try{
       // Log the ID
       error_log(print_r($id, true));
       
       // Find the category by ID
       $categorie = Categorie::findOrFail($id);
       
       // Delete the category
       $categorie->delete();

       return response()->json([
           'status' => true,
           'message' => 'Categorie supprimée !!'
       ], 200);

   } catch(\Exception $error){
       return response()->json([
           'status' => false,
           'message' => 'Erreur survenue lors de la requête.',
           'error' => $error->getMessage()
       ], 500);
   }
}

}
