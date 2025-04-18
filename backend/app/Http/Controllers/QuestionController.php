<?php

namespace App\Http\Controllers;

use App\Models\Question;
use Illuminate\Http\Request;

class QuestionController extends Controller
{
    public function showAllQuestions(){
        $questions = Question::all();

        return response()->json($questions, 200);
    }

    public function showQuestionsFromExam($exam_id){
        $questions = Question::where('exam_id', $exam_id)->get();

        return response()->json($questions, 200);
    }

    public function createQuestion(Request $request){
        $data = $request->validate([
            'exam_id' => 'nullable|integer',
            'statement' => 'required|string',
            'correct_answer' => 'required|string',
            'incorrect_answer_1' => 'required|string',
            'incorrect_answer_2' => 'nullable|string',
            'incorrect_answer_3' => 'nullable|string'
        ]);

        $question = Question::create($data);

        return response()->json(['message' => 'The question was created.'], 200);
    }

    public function updateQuestion(Request $request, $id){
        $question = Question::findOrFail($id);

        $data = $request->validate([
            'exam_id' => 'nullable|integer',
            'statement' => 'required|string',
            'correct_answer' => 'required|string',
            'incorrect_answer_1' => 'required|string',
            'incorrect_answer_2' => 'nullable|string',
            'incorrect_answer_3' => 'nullable|string'
        ]);

        $question->update($data);
        return response()->json(['message' => 'The question was updated.'], 200);
    }

    public function deleteQuestion($id){
        $question = Question::findOrFail($id);
        $question->delete();

        return response()->json(['message' => 'The question was deleted.'], 200);
    }
}
