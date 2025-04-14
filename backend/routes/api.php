<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\CourseController;


Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::get('/courses', [CourseController::class, 'showAllCourses']); // Everyone can see the courses
Route::get('/courses/{id}', [CourseController::class, 'getCourseById']); // Everyone can an especific course

// For creating, editing and deleting a course we need to be atohorized as an admin
Route::middleware(['auth:sanctum', 'role:admin'])->group(function () {
    Route::post('/courses', [CourseController::class, 'createCourse']);
    Route::delete('/courses/{id}', [CourseController::class, 'deleteCourse']);
    Route::put('/courses/{id}', [CourseController::class, 'updateCourse']);
});

