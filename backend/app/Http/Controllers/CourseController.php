<?php

namespace App\Http\Controllers;

use App\Models\Course;
use Illuminate\Http\Request;

class CourseController extends Controller
{
    // Method to get all courses
    public function showAllCourses()
    {
        $courses = Course::all();
        return response()->json($courses, 200); // Return the courses in JSON with 200 status
    }

    // Method to get a course by ID
    public function getCourseById($id)
    {
        // First, we check if the course exists using the findOrFail method from laravel which send a 404 status if the course is not found
        $course = Course::findOrFail($id);

        return response()->json($course, 200); // Return the course in JSON with 200 status
    }

    // Method to create a new course
    public function createCourse(Request $request)
    {
        // We validate the data passed from the user
        try {
            $data = $request->validate([
                'teacher_id' => 'required|exists:users,id',
                'title' => 'required|string|max:255',
                'description' => 'required|string',
                'privacy' => 'required|in:private,public',
                'image' => 'nullable|string',
                'max_students' => 'required|integer|min:0',
                'subject' => 'required|string|max:255',
                'duration' => 'nullable|string|max:255',
            ]);
            // We create a new course with the validated data
            $course = Course::create($data);
            return response()->json($course, 201); // Return the new course with a 201 status
        } catch(\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    // Method to update a course
    public function updateCourse(Request $request, $id)
    {
        // First, we check if the course exists using the findOrFail method from laravel which send a 404 status if the course is not found
        $course = Course::findOrFail($id);
        // We validate the data
        $data = $request->validate([
            'teacher_id' => 'nullable|exists:users,id',
            'title' => 'required|string|max:255',
            'description' => 'required|string',
            'privacy' => 'required|in:private,public',
            'image' => 'nullable|string',
            'max_students' => 'required|integer|min:0',
            'subject' => 'required|string|max:255',
            'duration' => 'nullable|string|max:255',
        ]);

        $course->update($data); // Update the course with the new data;
        return response()->json($course, 200); // Return the updated course with a 200 status
    }

    // Method to delete a course
    public function deleteCourse($id)
    {
        // First, we check if the course exists using the findOrFail method from laravel which send a 404 status if the course is not found
        $course = Course::findOrFail($id);

        $course->delete(); // Delete the course;
        return response()->json(['message' => 'The course was deleted successfully'], 200); // Return a success message with a 200 status
    }
}