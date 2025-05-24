<?php

namespace App\Http\Controllers;

use App\Models\Exam;
use Illuminate\Http\Request;

class ExamController extends Controller
{
    public function getAllExams()
    {
        $exams = Exam::all();

        return response()->json($exams, 200);
    }

    public function getExamsFromCourse($course_id)
    {
        $exams = Exam::where('course_id', $course_id)->get();

        return response()->json($exams, 200);
    }

    public function createExam(Request $request)
    {
        $data = $request->validate([
            'course_id' => 'required|integer',
            'title' => 'required|string',
            'is_active' => 'sometimes|boolean',
        ]);

        $data['is_active'] = $data['is_active'] ?? false; // Set the filed false if not specified

        // Check if there is any exam in that course
        $existingExam = Exam::where('course_id', $data['course_id'])->first();
        if ($existingExam) {
            return response()->json([
                'message' => 'An exam already exists for this course.'
            ], 409); // 409 Conflict
        }

        $exam = Exam::create($data);
        return response()->json($exam, 201);
    }
    public function updateExam(Request $request, $id)
    {
        $exam = Exam::findOrFail($id);

        $data = $request->validate([
            'is_active' => 'boolean',
        ]);

        $exam->update($data);
        return response()->json(['message' => 'The exam was updated succesfully'], 200);
    }

    public function deleteExam($id)
    {
        $exam = Exam::findOrFail($id);

        $exam->delete();
        return response()->json(['message' => 'The exam and all the questions associated to it were deleted succesfully'], 200);
    }
}
