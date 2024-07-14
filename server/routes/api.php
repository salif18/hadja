<?php

use App\Http\Controllers\Articles_Controller;
use App\Http\Controllers\Auth_controller;
use App\Http\Controllers\Categorie_Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

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
Route::post("/articles",[Articles_Controller::class,"createArticles"]);