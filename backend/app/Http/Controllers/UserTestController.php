<?php

namespace App\Http\Controllers;

use App\Models\Question;
use App\Models\UserTest;
use Illuminate\Http\Request;

class UserTestController extends Controller
{
    public function showAllAnswers()
    {
        $answers = UserTest::all();

        return response()->json($answers, 200);
    }
    public function showAnswerFromUserAndExam($userId, $examId)
    {
        $answers = UserTest::where('user_id', $userId)->where('exam_id', $examId)->get();

        if ($answers->isEmpty()) {
            return response()->json(['message' => 'No answers found for this user and test'], 404);
        }

        return response()->json($answers, 200);
    }

    public function createAnswer(Request $request)
    {
        $answer = $request->validate([
            'user_id' => 'required|integer',
            'question_id' => 'required|integer',
            'exam_id' => 'required|integer',
            'user_answer' => 'nullable|string',
        ]);
        $userTest = UserTest::create($answer);
        return response()->json([
            'message' => 'Your answer has been saved',
            'answer' => $userTest // devuelve el objeto creado, que contiene el ID
        ], 201);
    }

    public function correctAnswer(Request $request, $id)
    {
        $answer = UserTest::findOrFail($id);

        // Get the question associated to the answer
        $question = Question::findOrFail($answer->question_id);

        // Check if the answer is correct
        $isCorrect = $answer->user_answer === $question->correct_answer;

        // Update the answer
        $answer->update([
            'is_correct' => $isCorrect
        ]);

        return response()->json(['is_correct' => $isCorrect], 200);

    }

    public function getScore($user_id, $exam_id)
    {
        // We get the answers from the user and the exam
        $totalQuestions = Question::where('exam_id', $exam_id)->count();
        $answers = UserTest::where('user_id', $user_id)->where('exam_id', $exam_id)->get();

        // Check if there are answers
        if ($answers->isEmpty()) {
            return response()->json(['message' => 'There are no answers in this exam from this user'], 404);
        }
        $correctAnswers = $answers->where('is_correct', true)->count();
        $totalScore = round(($correctAnswers / $totalQuestions) * 10, 2);

        return response()->json($totalScore, 200);
    }
}
