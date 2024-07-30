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
Route::delete("/user/{id}",[Auth_controller::class,"delete"]);

//RECURER LES LIVREURS
Route::get("/livreurs",[Auth_controller::class,"getLibery"]);
Route::put("/livreurs/update/{id}",[Auth_controller::class,"updateLibery"]);
Route::delete("/livreurs/delete/{id}",[Auth_controller::class,"deleteLibery"]);

//REQUETTES CATEGORIES
Route::post("/categories",[Categorie_Controller::class,"createCategorys"]);
Route::get("/categories",[Categorie_controller::class,"getCategorys"]);
Route::put("/categories/update/{id}",[Categorie_controller::class,"updateCategorys"]);
Route::delete("/categories/delete/{id}",[Categorie_controller::class,"removeCategorys"]);

//REQUETTES ORDERS
Route::post("/orders",[Orders_controller::class,"createOrders"]);
Route::get("/orders",[Orders_controller::class,"getAllOrders"]);
Route::get("/orders/{userId}",[Orders_controller::class,"getOrdersByUser"]);
Route::get("/orders/positions/{id}",[Orders_controller::class,"getOneOrderPositons"]);
Route::get("/orders/status/{statut}", [Orders_Controller::class, "getOrdersByStatut"]);
Route::get("/orders/livrer/{userId}", [Orders_Controller::class, "getOrdersByDeliberyStatut"]);
Route::put("/orders/{id}",[Orders_controller::class,"updateOrdersStatut"]);
Route::put("/orders/positions/{id}",[Orders_controller::class,"updateOrderPositons"]);
Route::put("/orders/livreurId/{id}",[Orders_controller::class,"updateOrderDeliveryId"]);
// MY ROUTE ARTICLES
Route::post('/articles', [Articles_Controller::class, 'createArticle']);
Route::get('/get_article_with_galeries', [Articles_Controller::class, 'getArticleWithGaleries']);
Route::get('/articles_by_categories/{catego}',[Articles_Controller::class,'getArticlesByCategorie']);
Route::put('/articles/update/{id}', [Articles_Controller::class, 'updateArticle']);
Route::delete('/articles/delete/{id}', [Articles_Controller::class, 'removeArticle']);