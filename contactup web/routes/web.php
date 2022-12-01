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



// The list of the react's routes
Route::get('/', function () {
    return view('home');
});
Route::get('/favs', function () {
    return view('home');
});
Route::get('/archs', function () {
    return view('home');
});
Route::get('/about', function () {
    return view('home');
});
Route::get('/settings', function () {
    return view('home');
});
Route::get('/addContact', function () {
    return view('home');
});
Route::get('/edit/{conId}', function () {
    return view('home');
});




// The list of the mobile route
Route::get('/contact/list', [App\Http\Controllers\contactController::class, "index"])->name("home");
Route::get('/contact/show/{contact}', [App\Http\Controllers\contactController::class, "show"]);
Route::get('/contact/list/favs', [App\Http\Controllers\contactController::class, "indexFav"])->name("homeFavs");
Route::get('/contact/list/archs', [App\Http\Controllers\contactController::class, "indexArch"])->name("homeArch");

Route::post('/contact', [App\Http\Controllers\contactController::class, "store"]);
Route::post('/contact/theme', [App\Http\Controllers\contactController::class, "theme"]);
Route::post('/contact/edit/{contact}', [App\Http\Controllers\contactController::class, "update"]);
Route::post('/contact/edit/fav/{contact}', [App\Http\Controllers\contactController::class, "favorite"]);
Route::post('/contact/edit/arch/{contact}', [App\Http\Controllers\contactController::class, "archive"]);
Route::get('/delcontact/{contact}', [App\Http\Controllers\contactController::class, "destroyMob"]);
Route::get('/delmulcontact/{contact}', [App\Http\Controllers\contactController::class, "destroyMulMob"]);

Route::any('{catchall}', function () {
    return view('home');
})->where('catchall', '.*'); // 404 not found page