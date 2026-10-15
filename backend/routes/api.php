<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\RestaurantController;
use App\Http\Controllers\Api\MenuController;
use App\Http\Controllers\Api\ReservationController;
use App\Http\Controllers\Api\ReviewController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\PasswordController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\AdminController;
use App\Http\Controllers\Api\AdministratorController;

// ==================== PUBLIC ====================

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::post('/forgot-password', [PasswordController::class, 'forgotPassword']);
Route::post('/reset-password', [PasswordController::class, 'resetPassword']);

Route::get('/restaurants', [RestaurantController::class, 'index']);
Route::get('/restaurants/{id}', [RestaurantController::class, 'show']);


// ==================== LOGIN ====================

Route::middleware('auth:sanctum')->group(function () {

    // Authentication
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/profile', [AuthController::class, 'profile']);


    // ==================== CUSTOMER ====================

    Route::post('/reservations', [ReservationController::class, 'store']);

    Route::delete('/reservations/{id}', [ReservationController::class, 'destroy']);

    Route::post('/reviews', [ReviewController::class, 'store']);


    // ==================== RESERVATION ====================

    Route::get('/reservations', [ReservationController::class, 'index']);
    Route::get('/reservations/{id}', [ReservationController::class, 'show']);


    // ==================== ADMIN RESTORAN ====================

    Route::middleware('role:admin')->group(function () {

        // Dashboard
        Route::get('/admin/dashboard', [AdminController::class, 'dashboard']);

        // Restaurant
        Route::post('/restaurants', [RestaurantController::class, 'store']);
        Route::put('/restaurants/{id}', [RestaurantController::class, 'update']);
        Route::delete('/restaurants/{id}', [RestaurantController::class, 'destroy']);

        // Menu
        Route::post('/menus', [MenuController::class, 'store']);
        Route::put('/menus/{id}', [MenuController::class, 'update']);
        Route::delete('/menus/{id}', [MenuController::class, 'destroy']);

        // Reservation
        Route::put('/reservations/{id}/status', [ReservationController::class, 'updateStatus']);
    });


    // ==================== ADMINISTRATOR ====================

    Route::middleware('role:administrator')->group(function () {

        // Dashboard
        Route::get('/administrator/dashboard', [AdministratorController::class, 'dashboard']);

        // Restaurant approval
        Route::put('/restaurants/{id}/approve', [RestaurantController::class, 'approve']);
        Route::put('/restaurants/{id}/reject', [RestaurantController::class, 'reject']);

        // Category
        Route::post('/categories', [CategoryController::class, 'store']);
        Route::put('/categories/{id}', [CategoryController::class, 'update']);
        Route::delete('/categories/{id}', [CategoryController::class, 'destroy']);

        // User management
        Route::get('/users', [UserController::class, 'index']);
        Route::put('/users/{id}/block', [UserController::class, 'block']);
        Route::delete('/users/{id}', [UserController::class, 'destroy']);
    });


    // ==================== MENU ====================

    Route::get('/restaurants/{restaurant_id}/menus', [MenuController::class, 'index']);

    // ==================== REVIEW ====================

    Route::get('/restaurants/{restaurant_id}/reviews', [ReviewController::class, 'index']);

    // ==================== CATEGORY ====================

    Route::get('/categories', [CategoryController::class, 'index']);
});