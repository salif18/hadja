<?php

namespace App\Http\Controllers;

use App\Models\User;
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
                "phone_number" => "required|string|unique:users|min:8|max:15",
                "email" => "required|email|unique:users",
                "user_statut"=>"required|string",
                "password" => "required|min:6"
            ]);

            // En cas d'erreur de validation, retourner les erreurs
            if ($validator->fails()) {
                return response()->json([
                    "status" => false,
                    "message" => $validator->errors()
                ], 401);
            }

            // Enregistrement de l'utilisateur dans la base de données
            $user = User::create([
                "name" => $request->name,
                "phone_number" => $request->phone_number,
                "email" => $request->email,
                "user_statut"=>$request->user_statut,
                "password" => bcrypt($request->password),
            ]);

            // Génération d'un jeton d'authentification JWT
            $token = $user->createToken("user_token")->plainTextToken;

            //creer un profil
            $dataUser = [
                "name" => $user->name,
                "number" => $user->phone_number,
                "email" => $user->email,
                "user_statut"=>$user->user_statut,
            ];

            // Retour des informations sur l'utilisateur et du jeton JWT
            return response()->json([
                "status" => true,
                "message" => "Compte crée avec succès !!",
                "profil" => $dataUser,
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
            // print $body ;
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
            $user = User::where('email', $body['contacts'])
                ->orwhere("phone_number", $body["contacts"])
                ->first();

            // Si l'utilisateur n'existe pas, retourner un message d'erreur
            if (!$user) {
                return response()->json([
                    "status" => false,
                    "message" => 'Votre email est incorrect'
                ], 401);
            }

            // Vérification du mot de passe
            if (!Hash::check($body['password'], $user->password)) {
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
    public function delete()
    {
        try {

        } catch (\Exception $error) {
            return response()->json([
                "status" => false,
                "error" => $error->getMessage()
            ], 500);
        }
    }



    // Fonction de connexion de l'utilisateur
    // public function login(Request $req){
    //      try{
    //         $data = $req->all();
    //         $valid = Validator::make($data,[
    //           "email"=>"required",
    //           "password"=>"required"
    //         ]);

    //         if($valid->fails()){
    //             return response()->json([
    //                 "status" => false,
    //                 "message" => $valid->errors()
    //             ], 401);
    //         }

    //         if(!Auth::attempt(["email"=>request("email"), "password"=>request("password") ])){
    //             return response()->json([
    //                 "status" => false,
    //                 "message" => "email ou mot de passe incorrect"
    //             ], 401);
    //         }
    //         $user = User::where("email", request("email"))->first();
    //         $token = $user->createToken("user_token")->plainTextToken;

    //         return response()->json([
    //             "status" => true,
    //             "userId" => $user->id,
    //             "userInfos"=>$user,
    //             "token"=>$token
    //         ], 200);

    //      }catch(\Exception $error){
    //         return response()->json([
    //             "status" => false,
    //             "error" => $error->getMessage()
    //         ], 500);
    //      }
    // }
}
