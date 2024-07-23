<?php

namespace App\Http\Controllers;

use App\Models\Article;
use App\Models\Gallerie;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class Articles_Controller extends Controller
{

    //AJOUT DE NOUVEAUX ARTICLES
    public function createArticle(Request $request)
    {

        try {
            error_log(print_r($request->all(),true));
            // VERIFIER LA VALIDATION DES CHAMPS DE LA REQUETTE
            $valid = Validator::make($request->all(), [
                'name' => 'required',
                'categorie' => 'required',
                'desc' => 'required',
                'stock' => 'required',
                'price' => 'required',
                'likes' => 'required',
                'disLikes' => 'required',
                'img' => 'required|image', // Ajout de la validation pour l'image principale
                'galleries.*' => 'image', // Validation pour les images multiples

            ]);
            if ($valid->fails()) {
                return response()->json([
                    'status' => false,
                    'message' => $valid->errors(),
                ]);
            }

            //traitement de l'image recu de l'article
            if ($request->hasfile('img')) {
                $image = $request->file('img');
               $imagePath = $image->store('pictures',"public");
            }

            // INSERTION DES ARTICLES DANS LA TABLE ARTICLE
            $article = Article::create([
                'name' => $request->name,
                'categorie' => $request->categorie,
                'desc' => $request->desc,
                'likes' => $request->likes,
                'stock' => $request->stock,
                'price' => $request->price,
                'img' => Storage::url($imagePath),
            ]);

            //INSERTIONS DES IMAGES GALLERIES DANS LA TABLE GALLERIES
            if ($request->hasfile('galleries')) {
                foreach ($request->file('galleries') as $file) {
                    $galleriePath = $file->store('galleries','public');
                    Gallerie::create([
                        'article_id' => $article->id,
                        'img_path' => Storage::url($galleriePath),
                    ]);
                }
            }

            return response()->json([
                'status' => true,
                'articles' => $article,
                'message' => 'Article ajouter avec succes',
            ],201);

        } catch (\Throwable $err) {
            return response()->json([
                'status' => false,
                'message' => $err->getMessage(),
            ]);
        }
    }

    //  OBTENIR LES ARTICLES
    public function getArticleWithGaleries()
    {
        try {
            $articles = Article::with('galleries')->get();
            return response()->json([
                "statut"=>true,
                'success' => 'articles are : ', 
                'articles' => $articles
            ],200);
        } catch (Exception $err) {

            return response()->json([
                'status' => false,
                'message' => $err->getMessage(),
            ]);
        }
    }

     //  OBTENIR LES ARTICLES BY CATEGORIES
     public function getArticlesByCategorie($catego)
     {
         try {
             $articles = Article::with('galleries')
             ->where("categorie",$catego)
             ->get();
             return response()->json([
                 "statut"=>true,
                 'success' => 'articles are : ', 
                 'articles' => $articles
             ],200);
         } catch (Exception $err) {
 
             return response()->json([
                 'status' => false,
                 'message' => $err->getMessage(),
             ]);
         }
     }
}
