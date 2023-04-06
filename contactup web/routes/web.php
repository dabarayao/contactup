<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Artisan;

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
Route::get('/contact/list', [App\Http\Controllers\ContactController::class, "index"])->name("home");
Route::get('/contact/show/{contact}', [App\Http\Controllers\ContactController::class, "show"]);
Route::get('/contact/list/favs', [App\Http\Controllers\ContactController::class, "indexFav"])->name("homeFavs");
Route::get('/contact/list/archs', [App\Http\Controllers\ContactController::class, "indexArch"])->name("homeArch");

Route::post('/contact', [App\Http\Controllers\ContactController::class, "store"]);
Route::post('/contact/theme', [App\Http\Controllers\ContactController::class, "theme"]);
Route::post('/contact/edit/{contact}', [App\Http\Controllers\ContactController::class, "update"]);
Route::post('/contact/edit/fav/{contact}', [App\Http\Controllers\ContactController::class, "favorite"]);
Route::post('/contact/edit/arch/{contact}', [App\Http\Controllers\ContactController::class, "archive"]);
Route::get('/delcontact/{contact}', [App\Http\Controllers\ContactController::class, "destroyMob"]);
Route::get('/delmulcontact/{contact}', [App\Http\Controllers\ContactController::class, "destroyMulMob"]);

Route::get('/keygen', function () {
    Artisan::call('key:generate');
});

Route::get('/migrateseed', function () {
    Artisan::call('migrate:fresh');
    Artisan::call('db:seed');

    echo "La base de donnée a été restaurée";
});

Route::get('/storagelink', function () {
    Artisan::call('storage:link');

    echo "Le dossier storage a été liée";
});

Route::any('{catchall}', function () {
    return view('home');
})->where('catchall', '.*'); // 404 not found page