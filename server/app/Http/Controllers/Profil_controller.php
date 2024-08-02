<?php

namespace App\Http\Controllers;

use App\Models\Profil;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class Profil_controller extends Controller
{
    /// UPDATE PROFIL
    public function postPhotoProfil(Request $req)
    {
        try {

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
        if ($req->hasFile("photo")) {
            $photoFile = $req->file('photo');
            $photoPath = $photoFile->store('photos', "public");

            $profil = Profil::where('user_id', $req->user_id)->first();

            if ($profil) {
                // Supprimer l'ancienne photo de profil si elle existe
                if ($profil->photo) {
                    $oldPhotoPath = str_replace('/photos', 'public', $profil->photo);
                    if (Storage::exists($oldPhotoPath)) {
                        Storage::delete($oldPhotoPath);
                    }
                }

                // Mettre à jour la photo de profil
                $profil->update(['photo' => Storage::url($photoPath)]);
            } else {
                // Créer un nouveau profil si aucun n'existe
                $profil = Profil::create([
                    'user_id' => $req->user_id,
                    'photo' => Storage::url($photoPath)
                ]);
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


    /// UPDATE PROFIL
    // public function updatePhotoProfil(Request $req)
    // {
    //     try {
    //         if($req->hasFile("photo")){
    //             $photoFile = $req->file('photo');
    //             $photoPath = $photoFile->store('photos', "public");

    //             $profil = Profil::updateOrCreate(
    //                 ['user_id' => $req->user_id],
    //                 ['photo' => Storage::url($photoPath)]
    //             );

    //             return response()->json([
    //                 "status" => true,
    //                 "message" => "Photo de profil mise à jour avec succès !!",
    //                 "photo" => $profil
    //             ], 200);
    //         } else {
    //             return response()->json([
    //                 "status" => false,
    //                 "message" => "Aucune photo n'a été téléchargée."
    //             ], 400);
    //         }

    //     } catch (\Exception $error) {
    //         return response()->json([
    //             "status" => false,
    //             "message" => $error->getMessage()
    //         ], 500);
    //     }
    // }



}
