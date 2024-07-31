<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;

class Profil_controller extends Controller
{
    /// UPDATE PROFIL
    public function updateProfil(Request $req, $id)
    {
        try {
            $user = User::find($id);

            if (!$user) {
                return response()->json([
                    "status" => false,
                    "message" => "Utilisateur non trouvé"
                ], 404);
            }

            $user->update([
                "name" => $req->name ?? $user->name,
                "phone_number" => $req->phone_number ?? $user->phone_number,
                "email" => $req->email ?? $user->email,
                "user_statut" => $req->user_statut ?? $user->user_statut,
            ]);

            return response()->json([
                "status" => true,
                "message" => "Modification apportée avec succès !!",
                "profil" => [
                    "name" => $user->name,
                    "number" => $user->phone_number,
                    "email" => $user->email,
                    "user_statut" =>  $user->user_statut
                ]
            ], 200);

        } catch (\Exception $error) {
            return response()->json([
                "status" => false,
                "message" => $error->getMessage()
            ], 500);
        }
    }

}
