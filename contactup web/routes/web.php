<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/home', function () {
    return view("welcome");
});


// The list of the mobile route
Route::get('/', [App\Http\Controllers\contactController::class, "index"])->name("home");
Route::get('/contact/show/{contact}', [App\Http\Controllers\contactController::class, "show"]);
Route::get('/favs', [App\Http\Controllers\contactController::class, "indexFav"])->name("homeFavs");
Route::get('/archs', [App\Http\Controllers\contactController::class, "indexArch"])->name("homeArch");

Route::post('/contact', [App\Http\Controllers\contactController::class, "store"]);
Route::post('/contact/edit/{contact}', [App\Http\Controllers\contactController::class, "update"]);
Route::post('/contact/edit/fav/{contact}', [App\Http\Controllers\contactController::class, "favorite"]);
Route::post('/contact/edit/arch/{contact}', [App\Http\Controllers\contactController::class, "archive"]);
Route::get('/delcontact/{contact}', [App\Http\Controllers\contactController::class, "destroyMob"]);
Route::get('/delmulcontact/{contact}', [App\Http\Controllers\contactController::class, "destroyMulMob"]);
Route::get('/archmulcontact/{contact}', [App\Http\Controllers\contactController::class, "archiveMul"]);