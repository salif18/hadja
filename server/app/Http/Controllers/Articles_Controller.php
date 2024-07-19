<?php
namespace App\Http\Controllers;

use App\Models\Article;
use App\Models\Gallerie;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class Articles_Controller extends Controller
{
    // Ajouter un article
    public function createArticles(Request $req)
    {
        try {
            // Vérifier les champs
            $validate = Validator::make($req->all(), [
                'name' => 'required|string',
                'img' => 'required',
                'galleries' => 'required|array',
                'categorie' => 'required|string',
                'desc' => 'required|string',
                'price' => 'required|integer',
                'stock' => 'required|integer',
                'likes' => 'required|integer',
                'disLikes' => 'required|integer'
            ]);

            if ($validate->fails()) {
                return response()->json([
                    "status" => false,
                    "message" => "Veuillez vérifier les champs.",
                    "errors" => $validate->errors()
                ], 400);
            }

            // Insérer le produit dans la base
            $articles = Article::create([
                "name" => $req->name,
                "img" => $req->img,
                "categorie" => $req->categorie,
                "desc" => $req->desc,
                "price" => $req->price,
                "stock" => $req->stock,
                "likes" => $req->likes,
                "disLikes" => $req->disLikes
            ]);

            // Insérer les images dans galleries
            foreach ($req->galleries as $image) {
                Gallerie::create([
                    'article_id' => $articles->id,
                    'img_path' => $image,
                ]);
            }

            return response()->json([
                "status" => true,
                "message" => "Article ajouté.",
                "article" => $articles
            ], 201);

        } catch (\Throwable $err) {
            return response()->json([
                "status" => false,
                "message" => "Erreur survenue lors de la requête.",
                "error" => $err->getMessage()
            ], 500);
        }
    }



    // Exemple code to add article and galerie image to an article

        //
        // public function uploadGalerieImages(Request $request)
        // {
        //     $request->validate([
        //         'urlImg.*' => 'required|image|mimes:jpeg,png,jpg,gif,svg|max:22048',
        //     ]);

        //     $imageNames = [];
        //     if ($request->hasfile('urlImg')) {
        //         foreach ($request->file('urlImg') as $file) {

        //             $name = time() . '_' . $file->getClientOriginalName();
        //             $file->move(public_path('galeries'), $name);
        //             $imageNames[] = $name;
        //         }
        //          $galeriesImages=Gallerie::create([
        //         'article_id'=>$request->article_id,
        //         'urlImg'=>json_encode($imageNames),
        //     ]);
        //     return response()->json(['success' => 'Files uploaded successfully', 'files' => $imageNames]);
        //     }

        // }

        // public function AddArticle(Request $request){

        //     try {
        //         $valid=Validator::make($request->all(),[
        //             'name'=>'required',
        //             'category'=>'required',
        //             'desc'=>'required',
        //             'stock'=>'required',
        //             'price'=>'required'

        //         ]);
        //         if($valid->fails()){
        //             return response()->json([
        //                 'status'=>false,
        //                 'message'=> $valid->errors(),
        //             ]);
        //         }


        //         //traitement de l'image recu de l'article

        //         $imageNames = '';
        //         if ($request->hasfile('img')) {
        //             $image=$request->file('img');
        //                 $name = time() . '_' . $image->getClientOriginalName();
        //                 $image->move(public_path('images'), $name);
        //                 $imageNames = $name;
        //             }
        //         $Article=Article::create([
        //             'name'=>$request->name,
        //             'category'=>$request->category,
        //             'desc'=>$request->desc,
        //             'favorite'=>$request->favorite,
        //             'likes'=>$request->likes,
        //             'stock'=>$request->stock,
        //             'price'=>$request->price,
        //             'img'=>$imageNames,
        //         ]);

        //         return response()->json([
        //             'status'=>true,
        //             'Article'=> $Article,
        //             'message'=>'Article ajouter avec succes',
        //         ]);

        //     } catch (\Throwable $th) {
        //         return response()->json([
        //             'status'=>false,
        //             'message'=> $th->getMessage(),
        //         ]);
        //     }

        // }

        // public function getArticleWithGaleries(){

        //     $a = Article::with('galleries')->get();
        //     return response()->json(['success' => 'articles are : ', 'Articles' => $a]);


        // }



}
