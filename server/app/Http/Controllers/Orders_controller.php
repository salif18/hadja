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

            // Validation des données
            $isValide = Validator::make($req->all(), [
                "userId" => "required",
                "deliberyId" => "required",
                "address" => "required",
                "latitude" => "required",
                "longitude" => "required",
                "telephone" => "required",
                "total" => "required",
                "statut_of_delibery" => "required",
                "articles" => "required|array"
            ]);

            if ($isValide->fails()) {
                return response()->json([
                    "status" => false,
                    "message" => "Vos champs ne sont pas corrects",
                    "errors" => $isValide->errors()
                ]);
            }

            // Créer la commande
            $orders = Order::create([
                "userId" => $req->userId,
                "deliberyId" => $req->deliberyId,
                "address" => $req->address,
                "latitude" => $req->latitude,
                "longitude" => $req->longitude,
                "telephone" => $req->telephone,
                "total" => $req->total,
                "statut_of_delibery" => $req->statut_of_delibery,
            ]);

            // Créer les articles de commande et mettre à jour les stocks
            foreach ($req->articles as $item) {
                $article = Article::find($item['productId']);

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
                        'message' => 'Stock insuffisant pour le produit ' . $item['name'],
                    ], 400);
                }
            }


            return response()->json([
                "status" => true,
                "message" => "nouvel order"
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
                ->orwhere('deliberyId', $userId)
                ->with('orderItems')->get();

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
