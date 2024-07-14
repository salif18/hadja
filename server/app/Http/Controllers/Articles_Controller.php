<?php

namespace App\Http\Controllers;

use App\Models\Article;
use App\Models\Gallerie;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ArticlesController extends Controller
{
    // Ajouter un article
    public function createArticles(Request $req)
    {
        try {
            $body = $req->all();
            // Vérifier les champs
            $verifyField = Validator::make($body, [
                'name' => 'required|string',
                'img' => 'required|file|mimes:jpg,jpeg,png,bmp|max:2048',
                'galleries.*' => 'required|file|mimes:jpg,jpeg,png,bmp|max:2048',
                'category' => 'required|string',
                'desc' => 'required|string',
                'price' => 'required|integer',
                'stock' => 'required|integer',
                'likes' => 'required|integer',
                'disLikes' => 'required|integer'
            ]);

            if ($verifyField->fails()) {
                return response()->json([
                    "status" => false,
                    "message" => "Veuillez vérifier les champs.",
                    "errors" => $verifyField->errors()
                ]);
            }

            // Insérer le produit dans la base
            if ($req->hasFile("img")) {
                $urlimg = $req->file("img")->store("uploads", "public");
                $article = Article::create([
                    "name" => $req->name,
                    "img" => $urlimg,
                    "category" => $req->category,
                    "desc" => $req->desc,
                    "price" => $req->price,
                    "stock" => $req->stock,
                    "likes" => $req->likes,
                    "disLikes" => $req->disLikes
                ]);

                // Insérer les images dans galleries
                if ($req->hasFile('galleries')) {
                    foreach ($req->file('galleries') as $image) {
                        $path = $image->store('uploads', 'public');
                        Gallerie::create([
                            'article_id' => $article->id,
                            'img_path' => $path,
                        ]);
                    }
                }

                return response()->json([
                    "status" => true,
                    "message" => "Article ajouté.",
                    "article" => $article
                ], 201);
            }

            return response()->json([
                "status" => false,
                "message" => "Erreur lors de l'upload de l'image principale."
            ], 400);

        } catch (\Throwable $err) {
            return response()->json([
                "status" => false,
                "message" => "Erreur survenue lors de la requête.",
                "error" => $err->getMessage()
            ], 500);
        }
    }
}
