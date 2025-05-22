<?php

use App\Http\Controllers\CalificationController;
use App\Http\Controllers\CertificateController;
use App\Http\Controllers\CommentController;
use App\Http\Controllers\ExamController;
use App\Http\Controllers\InscriptionController;
use App\Http\Controllers\QuestionController;
use App\Http\Controllers\ResourceController;
use App\Http\Controllers\UserTestController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;
use App\Http\Controllers\CourseController;


Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:api');

// Endpoint Auth
Route::post('/login', [UserController::class, 'login']); // Login
Route::post('/register', [UserController::class, 'createUser']); // Create a new user
Route::post('/refresh', [UserController::class, 'refresh']); // Refesh the user token


//Endpoint Users
Route::get('/users', [UserController::class, 'showAllUsers']); // Get all users
Route::get('/users/{id}', [UserController::class, 'showUserById']); // Get a user by ID
Route::middleware(['auth:api', 'is_admin'])->group(function () {
    Route::put('/users/{id}', [UserController::class, 'updateUser']); // Update a user by ID
    Route::delete('/users/{id}', [UserController::class, 'deleteUser']); // Delete a user by ID
});

// Endpoint Courses
Route::get('/courses', [CourseController::class, 'showAllCourses']); // Everyone can see the courses
Route::get('/courses/{id}', [CourseController::class, 'getCourseById']); // See a specific course

// Protected course modification routes
Route::middleware(['auth:api', 'is_admin'])->group(function () {
    Route::post('/courses', [CourseController::class, 'createCourse']);
    Route::delete('/courses/{id}', [CourseController::class, 'deleteCourse']);
    Route::put('/courses/{id}', [CourseController::class, 'updateCourse']);
});

// Endpoint Resources
Route::get('/resources', [ResourceController::class, 'showAllResources']); // Get all resources
Route::get('/resources/{courseId}', [ResourceController::class, 'showResourceByCourseId']); // Get resources from a specific course
// Only teachers can manage the resources
Route::middleware(['auth:api', 'is_teacher'])->group(function () {
    Route::post('/resources', [ResourceController::class, 'createResource']); // Create a new resource
    Route::put('/resources/{id}', [ResourceController::class, 'updateResource']); // Update a resource
    Route::delete('/resources/{id}', [ResourceController::class, 'deleteResource']); // Delete a resource
});

// Endpoint Comments
Route::get('/comments', [CommentController::class, 'showAllComments']); // Get all comments
Route::get('/comments/resource/{resource_id}', [CommentController::class, 'showCommentsByResource']); // Get comments from a specific resource
Route::get('/comments/user/{user_id}', [CommentController::class, 'showCommentByUserId']); // Get comments from a specific user
Route::middleware(['auth:api'])->group(function () {
    Route::post('/comments', [CommentController::class, 'createComment']); // Create a new comment
    Route::middleware(['auth:api', 'author_comment'])->group(function () {
        Route::put('/comments/{id}', [CommentController::class, 'updateComment']); // Update a comment
        Route::delete('/comments/{id}', [CommentController::class, 'deleteComment']); // Delete a comment
    });
});

// Endpoint Inscription
Route::get('/inscriptions/user/{user_id}', [InscriptionController::class, 'getCoursesFromUser']); // Get all courses from a user
Route::get('/inscriptions/course/{course_id}', [InscriptionController::class, 'getUsersFromCourse']); // Get all users from a course
Route::post('/inscriptions', [InscriptionController::class, 'createInscription']); // Create a new inscription
Route::delete('/inscriptions/{user_id}/{course_id}', [InscriptionController::class, 'deleteInscription']); // Delete an inscription

// Endpoint Exams 
Route::get('/exams', [ExamController::class, 'getAllExams']); // Get all exams
Route::get('/exams/course/{course_id}', [ExamController::class, 'getExamsFromCourse']); // Get all exams from a course
Route::middleware(['auth:api', 'is_teacher'])->group(function () {
    Route::post('/exams', [ExamController::class, 'createExam']); // Create a new exam
    Route::put('/exams/{id}', [ExamController::class, 'updateExam']); // Update an exam
    Route::delete('/exams/{id}', [ExamController::class, 'deleteExam']); // Delete an exam
});

// Endpoint Questions
Route::get('/questions', [QuestionController::class, 'showAllQuestions']); // Get all questions
Route::get('/questions/exam/{exam_id}', [QuestionController::class, 'showQuestionsFromExam']); // Get all questions from an exam
Route::middleware(['auth:api', 'is_teacher'])->group(function () {
    Route::post('/questions', [QuestionController::class, 'createQuestion']); // Create a new question
    Route::put('/questions/{id}', [QuestionController::class, 'updateQuestion']); // Update a question
    Route::delete('/questions/{id}', [QuestionController::class, 'deleteQuestion']); // Delete a question
});

// Endpont Answers
Route::get('/answers/score/{user_id}/{exam_id}', [UserTestController::class, 'getScore']); // Get the score of a user in an exam
Route::get('/answers', [UserTestController::class, 'showAllAnswers']); // Get all answers
Route::get('/answers/{user_id}/{exam_id}', [UserTestController::class, 'showAnswerFromUserAndExam']); // Get all answers from a user and an exam
Route::get('/answers/{user_id}/{exam_id}/{question_id}', [UserTestController::class, 'getAnswerFromQuestion']); // Get if the user has answered the question
Route::delete('/answers/{user_id}/{exam_id}', [UserTestController::class, 'deleteUserAnswerFromExam']);
Route::post('/answers', [UserTestController::class, 'createAnswer']); // Create a new answer
Route::get('/answers/{id}', [UserTestController::class, 'correctAnswer']); // Correct an answer


// Endpoint Califications
Route::get('/califications', [CalificationController::class, 'showAllCalifications']); // Get all califications
Route::get('/califications/user/{user_id}', [CalificationController::class, 'showCalificationsFromUser']); // Get all califications from an user 
Route::get('/califications/exam/{exam_id}', [CalificationController::class, 'showCalificationsFromExam']); // Get all califications from an exam
Route::post('/califications', [CalificationController::class, 'createCalification']); // Create a new calification
Route::put('/califications/exam/{exam_id}',[CalificationController::class, 'updateCalification'] );

// Endpoint Certificates
Route::get('/certificates/user/{user_id}', [CertificateController::class, 'getAllCertificatesFromUser']); // Get all certificates from a user
Route::get('/certificates/{user_id}/{course_id}', [CertificateController::class, 'generateCertificate']); // Generate a certificate for a user and a course
