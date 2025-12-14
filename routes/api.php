<?php

use App\Http\Controllers\API\ProductController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::apiResource('products', ProductController::class);

Route::get('/health', function() {
    return response()->json([
        'status' => 'OK',
        'message' => 'API is running.',
        'timestamp' => now(),
    ], 200);
});
