<?php

namespace App\Http\Controllers;

use App\Models\User;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;

class Auth_Controller extends Controller
{
    // FONCTION DE REGISTRE
    public function registre(Request $request)
    {
        try {
            // Récupération des données de la requête
            $body = $request->only("name", "phone_number", "email", "user_statut", "password");

            // Validation des champs de la requête
            $validator = Validator::make($body, [
                "name" => "required|string",
                "phone_number" => "required|string|min:8|max:15",
                "email" => "required|email",
                "user_statut" => "required|string",
                "password" => "required|min:6"
            ]);

            // En cas d'erreur de validation, retourner les erreurs
            if ($validator->fails()) {
                return response()->json([
                    "status" => false,
                    "message" => $validator->errors()
                ], 401);
            }

            // Vérifier si le compte existe déjà
            $userExists = User::where("phone_number", $request->phone_number)
                ->orWhere("email", $request->email)
                ->exists();

            if ($userExists) {
                return response()->json([
                    "status" => false,
                    "message" => "Ce numero ou email existe déjà"
                ], 401);
            }

            // Enregistrement de l'utilisateur dans la base de données
            $user = User::create([
                "name" => $request->name,
                "phone_number" => $request->phone_number,
                "email" => $request->email,
                "user_statut" => $request->user_statut,
                "password" => bcrypt($request->password),
            ]);

            // Génération d'un jeton d'authentification JWT
            $token = $user->createToken("user_token")->plainTextToken;


            // Retour des informations sur l'utilisateur et du jeton JWT
            return response()->json([
                "status" => true,
                "message" => "Compte crée avec succès !!",
                "profil" => $user,
                "userId" => $user->id,
                "token" => $token,
            ], 201);
        } catch (\Exception $error) {
            return response()->json([
                "status" => false,
                "message" => $error->getMessage()
            ]);
        }
    }

    //FONCTION LOGIN
    public function login(Request $request)
    {
        try {
            // Récupération des données de la requête
            $body = $request->only('contacts', 'password');

            // Validation des champs de la requête
            $validator = Validator::make($body, [
                'contacts' => 'required',
                'password' => 'required',
            ]);

            // En cas d'erreur de validation, retourner les erreurs
            if ($validator->fails()) {
                return response()->json([
                    "status" => false,
                    "message" => $validator->errors()
                ], 401);
            }

            // Recherche de l'utilisateur dans la base de données
            $user = User::where('phone_number', $request->contacts)
                ->orwhere("email", $request->contacts)->first();

            // Si l'utilisateur n'existe pas, retourner un message d'erreur
            if (!$user) {
                return response()->json([
                    "status" => false,
                    "message" => 'Votre email est incorrect'
                ], 401);
            }

            // Vérification du mot de passe
            if (!Hash::check($request->password, $user->password)) {
                return response()->json([
                    "status" => false,
                    "message" => 'Votre mot de passe est incorrect'
                ], 401);
            }

            // Authentification réussie, génération d'un jeton JWT
            $token = $user->createToken("user_token")->plainTextToken;

            // Retour des informations sur l'utilisateur et du jeton JWT
            return response()->json([
                "status" => true,
                "message" => "Connecté avec succès  !!",
                'userId' => $user->id,
                'token' => $token,
                "profil" => $user,
            ], 200);
        } catch (\Exception $error) {
            return response()->json([
                "status" => false,
                "message" => $error->getMessage()
            ], 500);
        }
    }


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




    //DECONNEXION
    public function logout(Request $req)
    {
        try {
            $req->user()->currentAccessToken()->delete();
            return response()->json([
                "status" => true,
                "message" => "Déconnecté avec succès !!"
            ], 200);
        } catch (\Exception $error) {
            return response()->json([
                "status" => false,
                "error" => $error->getMessage()
            ], 500);
        }
    }

    //SUPPRESSION DE COMPTE
    public function delete($id)
    {
        try {
            // Trouver l'utilisateur par ID
            $user = User::findOrFail($id);

            if (!$user) {
                return response()->json([
                    "status" => false,
                    "message" => "Utilisateur non trouvé"
                ], 404);
            }

            // Supprimer le jeton d'accès de l'utilisateur
            $user->currentAccessToken()->delete();

            // Supprimer l'utilisateur de la base de données
            $user->delete();

            return response()->json([
                "status" => true,
                "message" => "User account deleted successfully."
            ], 200);
        } catch (\Exception $error) {
            return response()->json([
                "status" => false,
                "error" => $error->getMessage()
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
        } catch (Exception $err) {
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
