<?php

namespace App\Http\Controllers;

use App\Models\User;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
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

    
    // Durée de blocage en secondes (1 heure)
    const BLOCK_DURATION = 5 * 60 * 1000; 
    // Nombre maximal de tentatives
    const TENTATIVES_MAX = 5;
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
            $user = User::with("profil")->where('phone_number', $request->contacts)
                ->orwhere("email", $request->contacts)->first();

            // Si l'utilisateur n'existe pas, retourner un message d'erreur
            if (!$user) {
                return response()->json([
                    "status" => false,
                    "message" => 'Votre email est incorrect'
                ], 401);
            }

               // Vérifier si l'utilisateur est bloqué (a atteint le nombre maximal de tentatives)
         if ($user->tentatives >= self::TENTATIVES_MAX && $user->tentatives_expires > Carbon::now()) {
            // Convertir 'tentatives_expires' en chaîne de caractères pour l'afficher
            $tempsDattente = Carbon::parse($user->tentatives_expires)->toDateTimeString();
                $time = explode(" ",$tempsDattente)[1];
                return response()->json([
                    'message' => "Nombre maximal de tentatives atteint. Veuillez réessayer après {$time}."
                ], 429);
        }

            // Vérification du mot de passe
            if (!Hash::check($request->password, $user->password)) {
                $user->tentatives += 1;
                // Si le nombre maximal de tentatives est atteint, définir la date d'expiration du blocage
                if ($user->tentatives >= self::TENTATIVES_MAX) {
                    $user->tentatives_expires = Carbon::now()->addMilliseconds(self::BLOCK_DURATION);
                }
                // Sauvegarder les modifications de l'utilisateur
                $user->save();
                return response()->json([
                    "status" => false,
                    "message" => 'Votre mot de passe est incorrect'
                ], 401);
            }

             // Réinitialiser les tentatives après la modification du mot de passe
        $user->tentatives = 0; 
        // Réinitialiser la date d'expiration
       $user->tentatives_expires = Carbon::now();
       // Sauvegarder les modifications de l'utilisateur
       $user->save();

            // Authentification réussie, génération d'un jeton JWT
            $token = $user->createToken("user_token")->plainTextToken;

            //VERIFIER SI LE PROFIL EXISTE 
            $profilPhoto = $user->profil ? $user->profil->photo : null;
            $profilPhotoId = $user->profil ? $user->profil->id : null;

            $profil = [
                "name" => $user->name,
                "phone_number" => $user->phone_number,
                "email" => $user->email,
                "user_statut" => $user->user_statut,
                "photo"=>$profilPhoto,
                "photoId"=>$profilPhotoId
            ];
            
            // Retour des informations sur l'utilisateur et du jeton JWT
            return response()->json([
                "status" => true,
                "message" => "Connecté avec succès  !!",
                'userId' => $user->id,
                'token' => $token,
                "profil" => $profil,
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
    public function delete(Request $req)
    {
        try {
            $req->user()->currentAccessToken()->delete();
            $req->user()->delete();

            return response()->json([
                "status" => true,
                "message" => "Compte supprimer avec succès !!"
            ], 200);
        } catch (\Exception $error) {
            return response()->json([
                "status" => false,
                "error" => $error->getMessage()
            ], 500);
        }
    }



   
}
