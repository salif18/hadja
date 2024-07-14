<?php

use App\Http\Controllers\ArticlesController;
use App\Http\Controllers\Auth_controller;
use App\Http\Controllers\Categorie_Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

//CONFIGURATION A AJOUTER MANUELLEMENT
Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

//AUTHENTIFICATIONS
Route::middleware("auth:sanctum")->post("/logout",[Auth_controller::class,"logout"]);
Route::post("/registre",[Auth_controller::class,"registre"]);
Route::post("/login",[Auth_controller::class,"login"]);
Route::post("/update_password/{userId}",[Auth_controller::class,"updatePassword"]);
Route::post("/delete",[Auth_controller::class,"delete"]);

//REQUETTES CATEGORIES
Route::post("/categories",[Categorie_Controller::class,"createCategorys"]);
Route::get("/categories",[Categorie_controller::class,"getCategorys"]);

//REQUETTES ARTICLES
Route::post("/articles",[ArticlesController::class,"createArticles"]);