<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;


class Question extends Model
{
    use HasFactory;
    protected $fillable = [
      'exam_id',
      'statement',
      'correct_answer',
      'incorrect_answer_1',
      'incorrect_answer_2',
      'incorrect_answer_3',
    ];
    // A question belongs to an exam
    public function exam()
    {
        return $this->belongsTo(Exam::class);
    }
    // A question has many answer by an user
    public function userTests()
    {
        return $this->hasMany(UserTest::class);
    }
    // A method to give all the asnwer
    public function getAllAnswers(){
        $answers = [
            $this->correct_answer,
            $this->incorrect_answer_1,
            $this->incorrect_answer_2,
            $this->incorrect_answer_3
        ];
        shuffle($answers); // Shuffle the answers
        return $answers;
    }
    // A method to check the user answer
    public function isCorrectAnswer($userAnswer): bool
    {
        return $this->correct_answer === $userAnswer;
    }


}
