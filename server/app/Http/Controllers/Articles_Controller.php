<?php

namespace App\Http\Controllers;

use App\Models\Article;
use App\Models\Gallerie;

use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;

class Articles_Controller extends Controller
{

    //AJOUT DE NOUVEAUX ARTICLES
    public function createArticle(Request $request)
    {

        try {
            error_log(print_r($request->all(), true));
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
                $imagePath = $image->store('pictures', "public");
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
                    $galleriePath = $file->store('galleries', 'public');
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
            ], 201);
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
                "statut" => true,
                'success' => 'articles are : ',
                'articles' => $articles
            ], 200);
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
                ->where("categorie", $catego)
                ->get();
            return response()->json([
                "statut" => true,
                'success' => 'articles are : ',
                'articles' => $articles
            ], 200);
        } catch (Exception $err) {

            return response()->json([
                'status' => false,
                'message' => $err->getMessage(),
            ]);
        }
    }

    //MODIFIER UN PRODUIT 
    public function updateArticle(Request $request, $id)
    {
        try {
            DB::beginTransaction();

            $article = Article::with("galleries")->findOrFail($id);

            // Traitement de l'image reçue de l'article
            if ($request->hasFile('img')) {
                // Supprimer l'ancienne image si elle existe
                if ($article->img) {
                    Storage::delete('public/' . $article->img);
                }

                $image = $request->file('img');
                $imagePath = $image->store('pictures', 'public');
                $article->img = $imagePath; // Stocker uniquement le chemin relatif
            }

            // Mise à jour de l'article
            $article->update([
                'name' => $request->name ?? $article->name,
                'categorie' => $request->categorie ?? $article->categorie,
                'desc' => $request->desc ?? $article->desc,
                'likes' => $request->likes ?? $article->likes,
                'stock' => $request->stock ?? $article->stock,
                'price' => $request->price ?? $article->price,
                'img' => $article->img, // Mettre à jour l'image si elle a été modifiée
            ]);

            // Insertion des images des galeries dans la table galleries
            if ($request->hasFile('galleries')) {
                // Supprimer les anciennes images de galerie
                foreach ($article->galleries as $gallery) {
                    Storage::delete('public/' . $gallery->img_path);
                    $gallery->delete();
                }

                foreach ($request->file('galleries') as $file) {
                    $galleriePath = $file->store('galleries', 'public');
                    Gallerie::create([
                        'article_id' => $article->id,
                        'img_path' => $galleriePath, // Stocker uniquement le chemin relatif
                    ]);
                }
            }

            DB::commit();

            return response()->json([
                'status' => true,
                'article' => $article,
                'message' => 'Article mis à jour avec succès',
            ], 200);
        } catch (\Throwable $err) {
            DB::rollBack();
            return response()->json([
                'status' => false,
                'message' => $err->getMessage(),
            ], 500);
        }
    }

    //  SUPPRIMER UN ARTICLES
    public function removeArticle($id)
    {
        try {
            DB::beginTransaction();

            $article = Article::with("galleries")->findOrFail($id);

            // Supprimer l'image principale de l'article du stockage
            if ($article->img) {
                Storage::delete('public/' . $article->img);
            }

            // Supprimer les images des galeries associées de l'article du stockage
            foreach ($article->galleries as $gallery) {
                Storage::delete('public/' . $gallery->img_path);
                $gallery->delete();
            }

            // Supprimer l'article
            $article->delete();

            DB::commit();

            return response()->json([
                "status" => true,
                'message' => 'Article supprimé avec succès',
                'article' => $article
            ], 200);
        } catch (Exception $err) {
            DB::rollBack();
            return response()->json([
                'status' => false,
                'message' => $err->getMessage(),
            ], 500);
        }
    }
}
