<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Calification extends Model
{
    protected $fillable = [
        'user_id',
        'exam_id',
        'calification',
        'attempted_at',
    ];
    protected $casts = [
        'attempted_at' => 'datetime',
    ];

    // A calification belongs to a user and an exam
    public function user(){
        return $this->belongsTo(User::Class);
    }
    public function exam(){
        return $this->belongsTo(Exam::Class);
    }

    // Give the format to the calification
    public function getCalification($calification){ 
        return number_format($this->calification, 2);
    }
}