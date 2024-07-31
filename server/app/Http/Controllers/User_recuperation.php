<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\User;
use Illuminate\Support\Facades\Mail;
use Illuminate\Mail\Message;
use Twilio\Rest\Client;

class User_recuperation extends Controller
{
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
 
             // Génération d'un nombre aleatoire d'authentification
             $token = str_pad(rand(0, 9999), 4, "0", STR_PAD_LEFT);
             $user->remember_token = $token;
             $user->save();
            //  $user->update(['remember_token' => $token]);
 
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
             $user->save();
 
            //  $user->update([
            //      'password' => bcrypt($req->new_password),
            //      'remember_token' => null
            //  ]);
 
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
