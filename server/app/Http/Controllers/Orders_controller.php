<?php

namespace App\Http\Controllers;

use App\Models\Article;
use App\Models\Order;
use App\Models\OrderItem;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class Orders_controller extends Controller
{
    //créer un nouveau order
    public function createOrders(Request $req)
    {
        try {

            // // Validation des données
            // $isValide = Validator::make($req->all(), [
            //     "userId" => "required",
            //     "deliberyId" => "string|nullable",
            //     "address" => "required",
            //     "latitude" => "required",
            //     "longitude" => "required",
            //     "telephone" => "required",
            //     "total" => "required",
            //     "statut_of_delibery" => "required",
            //     "articles" => "required|array"
            // ]);

            // if ($isValide->fails()) {
            //     return response()->json([
            //         "status" => false,
            //         "message" => "Vos champs ne sont pas corrects",
            //         "errors" => $isValide->errors()
            //     ]);
            // }

            error_log(print_r($req->all(),true));

            // Créer la commande
            $orders = Order::create([
                "userId" => $req->userId,
                "deliveryId" => $req->deliveryId ,
                "address" => $req->address,
                "clientLat" => $req->clientLat,
                "clientLong" => $req->clientLong,
                "deliveryLat" => $req->deliveryLat,
                "deliveryLong" => $req->deliveryLong,
                "telephone" => $req->telephone,
                "total" => $req->total,
                "statut_of_delibery" => $req->statut_of_delibery,
            ]);

            // Créer les articles de commande et mettre à jour les stocks
            foreach ($req->articles as $item) {
                $article = Article::findOrFail($item['productId']);

                if ($article && $item['qty'] > 0 && $item['qty'] <= $article->stock) {
                    OrderItem::create([
                        'order_id' => $orders->id,
                        'productId' => $item['productId'],
                        'name' => $item['name'],
                        'img' => $item['img'],
                        'qty' => $item['qty'],
                        'prix' => $item['prix'],
                    ]);

                    // Mettre à jour le stock de l'article
                    $article->stock -= $item['qty'];
                    $article->save();
                } else {
                    return response()->json([
                        'status' => false,
                        'message' => "Stock insuffisant pour le produit {$item['name']} restant {$article->stock}",
                    ], 400);
                }
            }


            return response()->json([
                "status" => true,
                "message" => "Votre commande a été reçu !!"
            ], 201);
        } catch (Exception $err) {
            return response()->json([
                "status" => false,
                "message" => $err->getMessage()
            ], 500);
        }
    }

    //obtenir tous les orders 
    public function getAllOrders()
    {
        try {

            $orders = Order::with('orderItems')->get();

            return response()->json([
                "status" => true,
                "orders" => $orders,
            ], 200);
        } catch (Exception $err) {
            return response()->json([
                "status" => false,
                "message" => $err->getMessage()
            ], 500);
        }
    }

    //obtenir les orders par user
    public function getOrdersByUser($userId)
    {
        try {

            $orders = Order::where('userId', $userId)
                ->orwhere('deliveryId', $userId)
                ->with('orderItems')->get();

                // error_log(print_r($orders,true));

            return response()->json([
                "status" => true,
                "orders" => $orders,
            ], 200);
        } catch (Exception $err) {
            return response()->json([
                "status" => false,
                "message" => $err->getMessage()
            ], 500);
        }
    }

     //obtenir les orders par user
     public function getOneOrderPositons($id)
     {
         try {
 
             $orders = Order::find($id);
            // error_log(print_r($orders,true));
             return response()->json([
                 "status" => true,
                 "clientLat" => $orders->clientLat,
                 "clientLong" => $orders->clientLong,
                 "deliveryLat" => $orders->deliveryLat,
                 "deliveryLong" => $orders->deliveryLong,
             ], 200);

         } catch (Exception $err) {
             return response()->json([
                 "status" => false,
                 "message" => $err->getMessage()
             ], 500);
         }
     }

      //obtenir les orders par user
      public function updateOrderPositons(Request $req,$id)
      {
          try {
  
              $orders = Order::findOrFail($id);
             // error_log(print_r($orders,true));

             $orders->update([
                "deliveryLat" => $req->deliveryNewLat,
                "deliveryLong" => $req->deliveryNewLong,
             ]);

              return response()->json([
                  "status" => true,
                  "clientLat" => $orders->clientLat,
                  "clientLong" => $orders->clientLong,
                  "deliveryLat" => $orders->deliveryLat,
                  "deliveryLong" => $orders->deliveryLong,
              ], 200);
              
          } catch (Exception $err) {
              return response()->json([
                  "status" => false,
                  "message" => $err->getMessage()
              ], 500);
          }
      }

      //AJOUTER ID DE LIVREUR
      public function updateOrderDeliveryId(Request $req, $id)
{
    try {
        $order = Order::findOrFail($id);
        error_log(print_r($req->all(), true)); // Impression des données reçues

        $order->update([
            "deliveryId" => $req->deliveryId,
        ]);

        return response()->json([
            "status" => true,
            "orders" => $order,
            "message" => "Livreur ajouté à la commande"
        ], 200);
        
    } catch (Exception $err) {
        return response()->json([
            "status" => false,
            "message" => $err->getMessage()
        ], 500);
    }
}


    // Obtenir les commandes par statut de livraison
    public function getOrdersByStatut($statut)
    {
        try {
            $orders = Order::where('statut_of_delibery', $statut)
                ->with('orderItems')
                ->get();

            return response()->json([
                "status" => true,
                "orders" => $orders,
            ], 200);
        } catch (Exception $err) {
            return response()->json([
                "status" => false,
                "message" => $err->getMessage()
            ], 500);
        }
    }

    
    // Obtenir les commandes par statut de livraison
    public function getOrdersByDeliberyStatut($userId)
    {
        try {
            $orders = Order::where('statut_of_delibery', 'Livrer')
            ->orwhere("deliveryId",$userId)
                ->with('orderItems')
                ->get();

            return response()->json([
                "status" => true,
                "orders" => $orders,
            ], 200);
        } catch (Exception $err) {
            return response()->json([
                "status" => false,
                "message" => $err->getMessage()
            ], 500);
        }
    }

    //mis ajours du statut de order
    public function updateOrdersStatut(Request $req, $id)
    {
        try {

            // Récupérer l'instance de la commande
            $order = Order::findOrFail($id);

            // Mettre à jour le statut de la commande
            $order->update([
                'statut_of_delibery' => $req->newstatut
            ]);

            return response()->json([
                "status" => true,
                "orders" => $order,
            ], 200);
        } catch (Exception $err) {
            return response()->json([
                "status" => false,
                "message" => $err->getMessage()
            ], 500);
        }
    }
}
