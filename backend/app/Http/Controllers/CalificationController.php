<?php

namespace App\Http\Controllers;

use App\Models\Calification;
use Illuminate\Http\Request;

class CalificationController extends Controller
{
    public function showAllCalifications(){
        $califications = Calification::all();

        return response()->json($califications, 200);
    }

    public function showCalificationsFromUser($user_id){
        $califications = Calification::where('user_id', $user_id)->get();

        if ($califications->isEmpty()) {
            return response()->json(['message' => 'No califications found for this user'], 404);
        }

        return response()->json($califications, 200);
    }

    public function showCalificationsFromExam($exam_id){
        $califications = Calification::where('exam_id', $exam_id)->get();

        if ($califications->isEmpty()) {
            return response()->json(['message' => 'No califications found for this exam'], 404);
        }

        return response()->json($califications, 200);
    }

    public function createCalification(Request $request){
        $data = $request->validate([
            'user_id' => 'required|integer',
            'exam_id' => 'required|integer',
            'calification' => 'required|numeric',
        ]);

        // Check if the user has already done the exam

        $existing = Calification::where('user_id', $data['user_id'])
                                ->where('exam_id', $data['exam_id'])
                                ->first();

        if($existing){
            return response()->json(['message' => 'This user has already done this exam'], 400);
        }

        $data['attempted_at'] = now();
        $calification = Calification::create($data);

        return response()->json(['message' => 'Calification created succesfully'], 201);
    }
}
