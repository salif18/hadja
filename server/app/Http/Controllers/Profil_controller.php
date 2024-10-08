<?php

namespace App\Http\Controllers;

use App\Models\Profil;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class Profil_controller extends Controller
{
    /// UPDATE PROFIL
    public function postPhotoProfil(Request $req)
    {
        try {
            error_log(print_r($req->all(), true));
            if ($req->hasFile("photo")) {
                $photoFile = $req->file('photo');
                $photoPath = $photoFile->store('photos', "public");
            }

            $photoProfil = Profil::create([
                "user_id" => $req->user_id,
                "photo" => Storage::url($photoPath)
            ]);

            return response()->json([
                "status" => true,
                "message" => "Photo de profil ajoutée avec succès !!",
                "photo" => $photoProfil
            ], 201);
        } catch (\Exception $error) {
            return response()->json([
                "status" => false,
                "message" => $error->getMessage()
            ], 500);
        }
    }

    public function updatePhotoProfil(Request $req)
    {
        try {
            // error_log(print_r($req->all(), true));

            if ($req->hasFile("photo")) {
            // Trouvez le profil associé à l'utilisateur
                $profil = Profil::where('user_id', $req->user_id)->first();

                error_log(print_r($profil, true));

                if ($profil) {
                    // Supprimer l'ancienne photo de profil si elle existe
                    if ($profil->photo) {
                        $oldPhotoPath = str_replace('/storage', 'public', $profil->photo);
                        if (Storage::exists($oldPhotoPath)) {
                            Storage::delete($oldPhotoPath);
                        }
                    }
                    // recuperer le fichier photo
                    $photoFile = $req->file('photo');
                     // Stockez le fichier et obtenez le chemin
                    $photoPath = $photoFile->store('photos', "public");
                    // Mettre à jour le chemin de la photo de profil
                    $profil->update(['photo' => Storage::url($photoPath)]);
                } 
            
                return response()->json([
                    "status" => true,
                    "message" => "Photo de profil mise à jour avec succès !!",
                    "photo" => $profil
                ], 200);
            } else {
                return response()->json([
                    "status" => false,
                    "message" => "Aucune photo n'a été téléchargée."
                ], 400);
            }
        } catch (\Exception $error) {
            return response()->json([
                "status" => false,
                "message" => $error->getMessage()
            ], 500);
        }
    }

    // DELETE PHOTO
    public function deletePhotoProfil(Request $req)
{
    try {
        // Récupérer l'utilisateur
        $user = User::find($req->user_id);
        if (!$user) {
            return response()->json([
                "status" => false,
                "message" => "Utilisateur non trouvé."
            ], 404);
        }

        $profil = $user->profil; // Assurez-vous que la relation profil est définie dans votre modèle User

        // Supprimer l'ancien fichier photo s'il existe
        if ($profil && $profil->photo) {
            $oldPhotoPath = str_replace('/storage', 'public', $profil->photo); // Convertir l'URL en chemin de stockage
            Storage::delete($oldPhotoPath);

            // Mettre à jour le profil pour supprimer le chemin de la photo
            $profil->update(['photo' => null]);
        } else {
            return response()->json([
                "status" => false,
                "message" => "Aucune photo de profil à supprimer."
            ], 404);
        }

        return response()->json([
            "status" => true,
            "message" => "Photo de profil supprimée avec succès !!"
        ], 200);
    } catch (\Exception $error) {
        return response()->json([
            "status" => false,
            "message" => $error->getMessage()
        ], 500);
    }
}


}
