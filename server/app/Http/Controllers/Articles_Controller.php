<?php
namespace App\Http\Controllers;

use App\Models\Article;
use App\Models\Gallerie;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class Articles_Controller extends Controller
{
        public function createArticle(Request $request){

            try {
                $valid=Validator::make($request->all(),[
                    'name'=>'required',
                    'categorie'=>'required',
                    'desc'=>'required',
                    'stock'=>'required',
                    'price'=>'required'

                ]);
                if($valid->fails()){
                    return response()->json([
                        'status'=>false,
                        'message'=> $valid->errors(),
                    ]);
                }


                //traitement de l'image recu de l'article
                $imageNames = '';
                if ($request->hasfile('img')) {
                    $image=$request->file('img');
                        $name = time() . '_' . $image->getClientOriginalName();
                        $image->move(public_path('images'), $name);
                        $imageNames = $name;
                    }

                $article=Article::create([
                    'name'=>$request->name,
                    'categorie'=>$request->categorie,
                    'desc'=>$request->desc,
                    'likes'=>$request->likes,
                    'stock'=>$request->stock,
                    'price'=>$request->price,
                    'img'=>$imageNames,
                ]);

                $imageNames = [];
                if ($request->hasfile('galleries')) {
                    foreach ($request->file('galleries') as $file) {
    
                        $name = time() . '_' . $file->getClientOriginalName();
                        $file->move(public_path('galeries'), $name);
                        $imageNames[] = $name;
                    }
                     Gallerie::create([
                    'article_id'=>$article->id,
                    'img_path'=>json_encode($imageNames),
                ]);
                return response()->json(['success' => 'Files uploaded successfully', 'files' => $imageNames]);
                }

                return response()->json([
                    'status'=>true,
                    'Article'=> $article,
                    'message'=>'Article ajouter avec succes',
                ]);

            } catch (\Throwable $th) {
                return response()->json([
                    'status'=>false,
                    'message'=> $th->getMessage(),
                ]);
            }

        }

        public function getArticleWithGaleries(){

            $a = Article::with('galleries')->get();
            return response()->json(['success' => 'articles are : ', 'Articles' => $a]);


        }



}
