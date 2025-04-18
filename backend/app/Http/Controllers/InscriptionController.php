<?php

namespace App\Http\Controllers;

use App\Models\Course;
use App\Models\Inscription;
use Illuminate\Http\Request;

class InscriptionController extends Controller
{
    // Method to get the courses from an user
    public function getCoursesFromUser($user_id){
        $courses = Inscription::where('user_id', $user_id)->get();

        return response()->json($courses, 200);
    }

    // Method to get all the users from a course
    public function getUsersFromCourse($course_id){
        $users = Inscription::where('course_id', $course_id)->get();

        return response()->json($users, 200);
    }
    // Method to create an assignation when an user get enrolled to a course
    public function createInscription(Request $request)
    {
        $data = $request->validate([
            'user_id' => 'required|integer',
            'course_id' => 'required|integer',
        ]);

        $user_id = $data['user_id'];
        $course_id = $data['course_id'];

        $exists = Inscription::where('user_id', $user_id)
            ->where("course_id", $course_id)
            ->exists();

        if ($exists) {
            return response()->json([
                'message' => 'You are already enrolled to this course'
            ], 400);
        }

        // We add the assignation date
        $data['inscription_date'] = now();

        $inscription = Inscription::create($data);
        return response()->json(['message' => 'You have been enrolled to this course'], 201);
    }

    // Method to delete de assignation when an user get unenrolled to a course
    public function deleteInscription($user_id, $course_id)
    {
        $inscription = Inscription::where('user_id', $user_id)
                                    ->where("course_id", $course_id)
                                    ->first();

        if( $inscription ) {
            $inscription->delete();
            return response()->json(['message' => 'You have been unrolled from this course'], 200);
        } else {
            return response()->json(['message' => "This user is not enrolled in this course"], 400);
        }
    }
}
