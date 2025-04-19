<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;


class UserTest extends Model
{
    use HasFactory;
    protected $fillable = [
        'user_id',
        'question_id',
        'exam_id',
        'user_answer',
        'is_correct',
    ];

    // An answer belongs to an user
    public function user(){
        return $this->belongsTo(User::class);
    }
    // An answer belongs to a question
    public function test(){
        return $this->belongsTo(Question::class);
    }
    // An aswer belongs to an exam
    public function exam(){
        return $this->belongsTo(Exam::class);
    }

    // Method to get the answer of a question
    public function checkAnswer(){
        return $this->test->isCorrectAnswer($this->user_answer);
    }
    // Method to save the answer
    public function setAnswer(){
        $this->is_correct =  $this->checkAnswer();
        $this->save();
    }
}
