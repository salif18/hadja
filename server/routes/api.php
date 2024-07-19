<?php

use App\Http\Controllers\Articles_Controller;
use App\Http\Controllers\Auth_controller;
use App\Http\Controllers\Categorie_Controller;
use App\Http\Controllers\Orders_controller;
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

//RECURER LES LIVREURS
Route::get("/livreurs",[Auth_controller::class,"getLibery"]);

//REQUETTES CATEGORIES
Route::post("/categories",[Categorie_Controller::class,"createCategorys"]);
Route::get("/categories",[Categorie_controller::class,"getCategorys"]);

//REQUETTES ARTICLES
Route::post("/articles",[Articles_Controller::class,"createArticles"]);

//REQUETTES ORDERS
Route::post("/orders",[Orders_controller::class,"createOrders"]);
Route::get("/orders",[Orders_controller::class,"getAllOrders"]);
Route::get("/orders/{userId}",[Orders_controller::class,"getOrdersByUser"]);
Route::get("/orders/status/{statut}", [Orders_Controller::class, "getOrdersByStatut"]);
Route::put("/orders/{id}",[Orders_controller::class,"updateOrdersStatut"]);