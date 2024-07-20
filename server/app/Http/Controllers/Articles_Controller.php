<?php

namespace App\Http\Controllers;

use App\Models\Article;
use App\Models\Gallerie;
use Exception;
use Illuminate\Http\Request;
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
            $imageNames = '';
            if ($request->hasfile('img')) {
                $image = $request->file('img');
                $name = time() . '_' . $image->getClientOriginalName();
                $image->move(public_path('images'), $name);
                $imageNames = $name;
            }

            // INSERTION DES ARTICLES DANS LA TABLE ARTICLE
            $article = Article::create([
                'name' => $request->name,
                'categorie' => $request->categorie,
                'desc' => $request->desc,
                'likes' => $request->likes,
                'stock' => $request->stock,
                'price' => $request->price,
                'img' => $imageNames,
            ]);

            //INSERTIONS DES IMAGES GALLERIES DANS LA TABLE GALLERIES
            $imageNames = [];
            if ($request->hasfile('galleries')) {
                foreach ($request->file('galleries') as $file) {
                    $name = time() . '_' . $file->getClientOriginalName();
                    $file->move(public_path('galeries'), $name);
                    $imageNames[] = $name;
                }

                Gallerie::create([
                    'article_id' => $article->id,
                    'img_path' => json_encode($imageNames),
                ]);

                return response()->json([
                    "statut"=>true,
                    'success' => 'Files uploaded successfully', 
                    'files' => $imageNames
                ],201);
            }

            return response()->json([
                'status' => true,
                'Article' => $article,
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
                'Articles' => $articles
            ],200);
        } catch (Exception $err) {

            return response()->json([
                'status' => false,
                'message' => $err->getMessage(),
            ]);
        }
    }
}
