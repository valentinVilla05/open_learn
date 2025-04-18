<?php

use App\Http\Controllers\CommentController;
use App\Http\Controllers\ExamController;
use App\Http\Controllers\InscriptionController;
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
Route::get('/resources/{courseId}', [ResourceController::class, 'showResourceByCourseId']); // Get resources from a specific course
Route::post('/resources', [ResourceController::class, 'createResource']); // Create a new resource
Route::put('/resources/{id}', [ResourceController::class, 'updateResource']); // Update a resource
Route::delete('/resources/{id}', [ResourceController::class, 'deleteResource']); // Delete a resource

// Endpoint Comments
Route::get('/comments', [CommentController::class, 'showAllComments']); // Get all comments
Route::get('/comments/resource/{resource_id}', [CommentController::class, 'showCommentsByResource']); // Get comments from a specific resource
Route::get('/comments/user/{user_id}', [CommentController::class, 'showCommentByUserId']); // Get comments from a specific user
Route::post('/comments', [CommentController::class, 'createComment']); // Create a new comment
Route::put('/comments/{id}', [CommentController::class, 'updateComment']); // Update a comment
Route::delete('/comments/{id}', [CommentController::class, 'deleteComment']); // Delete a comment

// Endpoint Inscription
Route::get('/inscriptions/user/{user_id}', [InscriptionController::class, 'getCoursesFromUser']); // Get all courses from a user
Route::get('/inscriptions/course/{course_id}', [InscriptionController::class, 'getUsersFromCourse']); // Get all users from a course
Route::post('/inscriptions', [InscriptionController::class, 'createInscription']); // Create a new inscription
Route::delete('/inscriptions/{user_id}/{course_id}', [InscriptionController::class, 'deleteInscription']); // Delete an inscription

// Endpoint Exams 
Route::get('/exams', [ExamController::class, 'getAllExams']); // Get all exams
Route::get('/exams/course/{course_id}', [ExamController::class, 'getExamsFromCourse']); // Get all exams from a course
Route::post('/exams', [ExamController::class, 'createExam']); // Create a new exam
Route::delete('/exams/{id}', [ExamController::class, 'deleteExam']); // Delete an exam

