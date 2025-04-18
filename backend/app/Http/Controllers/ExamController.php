<?php

namespace App\Http\Controllers;

use App\Models\Exam;
use Illuminate\Http\Request;

class ExamController extends Controller
{
    public function getAllExams(){
        $exams = Exam::all();

        return response()->json($exams, 200);
    }

    public function getExamsFromCourse($course_id){
        $exams = Exam::where('course_id', $course_id)->get();

        return response()->json($exams, 200);
    }

    public function createExam(Request $request){
        $data = $request->validate([
            'course_id' => 'required|integer',
            'title' => 'required|string',
            'is_active' => 'boolean',
        ]);
        $examen = Exam::create($data);
        return response()->json(['message' => 'The exam was created succesfully'], 201);
    }

    public function deleteExam($id){
        $exam = Exam::findOrFail($id);

        $exam->delete();
        return response()->json(['message' => 'The exam was deleted succesfully'], 200);
    }
}
