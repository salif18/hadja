<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\User;
use Illuminate\Support\Facades\Mail;
use Illuminate\Mail\Message;
use Illuminate\Support\Carbon;
use Twilio\Rest\Client;

class User_recuperation extends Controller
{
     // Durée de blocage en secondes (1 heure)
     const BLOCK_DURATION = 5 * 60 * 1000; 
     // Nombre maximal de tentatives
     const TENTATIVES_MAX = 3;
     // RECUPERATION DE COMPTE OUBLIE RESET PASSWORD
     public function reset(Request $req)
     {
         try {
             // Validation des champs de la requête
             $validator = Validator::make($req->all(), [
                 "numero" => "required",
                 "email" => "required"
             ]);
 
             // En cas d'erreur de validation, retourner les erreurs
             if ($validator->fails()) {
                 return response()->json([
                     "status" => false,
                     "message" => $validator->errors()
                 ], 400);
             }
 
             $user = User::where("phone_number", $req->numero)
                 ->where("email", $req->email)
                 ->first();
 
             if (!$user) {
                 return response()->json([
                     "status" => false,
                     "message" => "Cet utilisateur n'existe pas"
                 ], 404);
             }

               // Vérifier si l'utilisateur est bloqué (a atteint le nombre maximal de tentatives)
            if ($user->tentatives >= self::TENTATIVES_MAX && $user->tentatives_expires > Carbon::now()) {
                // Convertir 'tentatives_expires' en chaîne de caractères pour l'afficher
                $tempsDattente = Carbon::parse($user->tentatives_expires)->toDateTimeString();
                error_log("Temps d'attente: " . $tempsDattente);
                return response()->json([
                    'message' => "Nombre maximal de tentatives atteint. Veuillez réessayer après {$tempsDattente}."
                ], 429);
            }
 
             // Génération d'un nombre aleatoire d'authentification
             $token = str_pad(rand(0, 9999), 4, "0", STR_PAD_LEFT);
             $user->remember_token = $token;

             $user->tentatives += 1;

             // Si le nombre maximal de tentatives est atteint, définir la date d'expiration du blocage
             if ($user->tentatives >= self::TENTATIVES_MAX) {
                 $user->tentatives_expires = Carbon::now()->addMilliseconds(self::BLOCK_DURATION);
             }
 
             $user->save();
        
 
             //Envoi vers un email
             Mail::send([], [], function (Message $message) use ($user, $token) {
                 $message->to($user->email)
                     ->subject("Récupération")
                     ->html("Votre code de récupération est <b>$token</b>");
             });
 
             //Envoyer vers le numero
            //  $client = new Client(env('TWILIO_SID'), env('TWILIO_TOKEN'));
            //  $client->messages->create(
            //      $user->phone_number, // Le numéro de téléphone du destinataire
            //      [
            //          'from' => env('TWILIO_FROM'), // Votre numéro Twilio
            //          'body' => "Le code de validation est $token."
            //      ]
            //  );
             return response()->json([
                 "status" => true,
                 "message" => "Un code a 4 chiffres a été envoyer sur votre email pour validation du nouveau mot de passe",
                 "token" => $token
             ], 200);
 
         } catch (\Exception $err) {
             return response()->json([
                 "status" => false,
                 "message" => $err->getMessage()
             ], 500);
         }
     }
 
     // VALIDATION DE COMPTE
     public function validation(Request $req)
     {
         try {
             // Validation des champs de la requête
             $validator = Validator::make($req->all(), [
                 "resetToken" => "required",
                 "new_password" => "required|min:6",
                 "confirm_password" => "required|min:6"
             ]);
 
             // En cas d'erreur de validation, retourner les erreurs
             if ($validator->fails()) {
                 return response()->json([
                     "status" => false,
                     "message" => $validator->errors()
                 ], 400);
             }
 
             $user = User::where("remember_token", $req->resetToken)->first();
 
             if (!$user) {
                 return response()->json([
                     "status" => false,
                     "message" => "Ce code a été expiré"
                 ], 401);
             }
 
             if ($req->new_password !== $req->confirm_password) {
                 return response()->json([
                     "status" => false,
                     "message" => "Les mots de passe ne correspondent pas"
                 ], 400);
             }

             $user->password = bcrypt($req->new_password);
             $user->remember_token = null;
             $user->tentatives = 0; // Réinitialiser les tentatives après la modification du mot de passe
             $user->tentatives_expires = Carbon::now(); // Réinitialiser la date d'expiration
             $user->save();
 
             return response()->json([
                 "status" => true,
                 "message" => "Votre mot de passe a été réinitialisé avec succès"
             ], 200);
 
         } catch (\Exception $err) {
             return response()->json([
                 "status" => false,
                 "message" => $err->getMessage()
             ], 500);
         }
     }
}
