<?php

namespace App\Http\Controllers;

use App\Models\Order;
use App\Models\OrderItem;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class Orders_controller extends Controller
{
    //creer nouveaux corder
    public function createOrders(Request $req){
       try{

        $isValide = Validator::make($req->all(),[
           "userId"=>"required",
           "deliberyId"=>"required",
           "address"=>"required",
           "latitude"=>"required",
           "longitude"=>"required",
           "telephone"=>"required",
           "total"=>"required",
           "statut_of_delibery"=>"required",
           "articles"=>"required"
        ]) ;

        if($isValide->fails()){
            return response()->json([
              "statut"=>false, 
              "message"=>"Vos champs ne sont pas corrects"
            ]);
        }

        $orders = Order::create([
           "userId"=>$req->userId,
           "deliberyId"=>$req->deliberyId,
           "address"=>$req->address,
           "latitude"=>$req->latitude,
           "longitude"=>$req->longitude,
           "telephone"=>$req->telephone,
           "total"=>$req->total,
           "statut_of_delibery"=>$req->statut_of_delibery,
        ]);

        foreach($req->only("articles") as $item){
            OrderItem::create([
                "order_id"=>$orders->id,
                "productId"=>$item->productId,
                "name"=>$item->name,
                "img"=>$item->img,
                "qty"=>$item->qty,
                "prix"=>$item->prix,

            ]);
        }

        return response()->json([
            "status"=>true,
            "message"=>"nouvel order"
       ],201);

       }catch(Exception $err){
        return response()->json([
             "status"=>false,
             "message"=>$req->getMessage()
        ],500);
       }
    }
}
