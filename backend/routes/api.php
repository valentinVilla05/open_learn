<?php

use App\Http\Controllers\ResourceController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;
use App\Http\Controllers\CourseController;


Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

// Endpoint Auth
Route::post('/login', [UserController::class, 'login']); // Login

//Endpoint Users
Route::get('/users', [UserController::class, 'showAllUsers']); // Get all users
Route::get('/users/{id}', [UserController::class, 'showUserById']); // Get a user by ID
Route::post('/users', [UserController::class, 'createUser']); // Create a new user
Route::put('/users/{id}', [UserController::class, 'updateUser']); // Update a user by ID
Route::delete('/users/{id}', [UserController::class, 'deleteUser']); // Delete a user by ID

// Endpoint Courses
Route::get('/courses', [CourseController::class, 'showAllCourses']); // Everyone can see the courses
Route::get('/courses/{id}', [CourseController::class, 'getCourseById']); // Everyone can an especific course
// For creating, editing and deleting a course we need to be atohorized as an admin
//Route::middleware(['auth:sanctum', 'rol:admin'])->group(function () {
    Route::post('/courses', [CourseController::class, 'createCourse']);
    Route::delete('/courses/{id}', [CourseController::class, 'deleteCourse']);
    Route::put('/courses/{id}', [CourseController::class, 'updateCourse']);
//});

// Endpoint Resources
Route::get('/resources', [ResourceController::class, 'showAllResources']); // Get all resources
Route::get('/resources/{courseId}', [ResourceController::class, 'showResourceByCourseId']); // Get resources from an specific course
Route::post('/resources', [ResourceController::class, 'createResource']); // Create a new resource
Route::put('/resources/{id}', [ResourceController::class, 'updateResource']); // Update an specific resource
Route::delete('/resources/{id}', [ResourceController::class, 'deleteResource']); // Delete an specific resource

