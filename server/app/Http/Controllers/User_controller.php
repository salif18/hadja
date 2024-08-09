<?php

namespace App\Http\Controllers;

use App\Models\User;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class User_controller extends Controller
{
    // UPDATE PASSWORD
    public function updatePassword(Request $req, $userId)
    {
        try {
            // Validation des champs de la requête
            $validator = Validator::make($req->all(), [
                "current_password" => "required|min:6",
                "new_password" => "required|min:6",
                "confirm_password" => "required|min:6"
            ]);

            if ($validator->fails()) {
                return response()->json([
                    "status" => false,
                    "message" => $validator->errors()
                ], 400);
            }

            $user = User::find($userId);

            if (!$user) {
                return response()->json([
                    "status" => false,
                    "message" => "Utilisateur non trouvé"
                ], 404);
            }

            if (!Hash::check($req->current_password, $user->password)) {
                return response()->json([
                    "status" => false,
                    "message" => "Mot de passe actuel incorrect"
                ], 401);
            }

            if ($req->new_password !== $req->confirm_password) {
                return response()->json([
                    "status" => false,
                    "message" => "votre mots de passe ne sont pas les memes"
                ], 400);
            }

            $user->update([
                "password" => bcrypt($req->new_password)
            ]);

            return response()->json([
                "status" => true,
                "message" => "Mot de passe modifié avec succès"
            ], 200);
        } catch (\Exception $error) {
            return response()->json([
                "status" => false,
                "message" => $error->getMessage()
            ], 500);
        }
    }

     // recuperer les libery
     public function getLibery()
     {
         try {
 
             $liberys = User::where("user_statut", "delivery")->get();
             return response()->json([
                 "status" => true,
                 "theLiberys" => $liberys
             ], 200);
         } catch (\Exception $err) {
             return response()->json([
                 "status" => false,
                 "error" => $err->getMessage()
             ], 500);
         }
     }
 
     // FONCTION DE MODIFICATION
     public function updateLibery(Request $request, $id)
     {
         try {
             // Trouver l'utilisateur dans la base de données
             $user = User::find($id);
             error_log(print_r($user, true));
             // Mettre à jour les informations de l'utilisateur
 
             if (!$user) {
                 return response()->json([
                     "status" => false,
                     "message" => "Utilisateur non trouvé"
                 ], 404);
             }
             $user->update([
                 "name" => $request->name ?? $user->name,
                 "phone_number" => $request->phone_number ?? $user->phone,
                 "email" => $request->email ?? $user->email,
                 "user_statut" => $request->user_statut ?? $user->user_statut,
             ]);
 
             // Retourner les informations sur l'utilisateur
             return response()->json([
                 "status" => true,
                 "message" => "Compte mis à jour avec succès !!",
 
             ], 200); // Code de statut 200 pour une mise à jour réussie
 
         } catch (\Exception $error) {
             return response()->json([
                 "status" => false,
                 "message" => $error->getMessage()
             ], 500); // Code de statut 500 pour les erreurs serveur
         }
     }
 
     // FONCTION DE SUPPRESSION
     public function deleteLibery($id)
     {
         try {
             // Trouver l'utilisateur dans la base de données
             $user = User::find($id);
 
             if (!$user) {
                 return response()->json([
                     "status" => false,
                     "message" => "Utilisateur non trouvé"
                 ], 404);
             }
 
             // Supprimer l'utilisateur
             $user->delete();
 
             // Retourner une réponse de succès
             return response()->json([
                 "status" => true,
                 "message" => "Compte supprimé avec succès !!",
             ], 200); // Code de statut 200 pour une suppression réussie
 
         } catch (\Exception $error) {
             return response()->json([
                 "status" => false,
                 "message" => $error->getMessage()
             ], 500); // Code de statut 500 pour les erreurs serveur
         }
     }

}
