<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Exam extends Model
{
    protected $fillable = [
        'course_id',
        'title',
        'is_active',
    ];
    // The attributes that should be cast to native types.
    protected $casts = [
        'is_active' => 'boolean'
    ];

    // An exam belongs to a course
    public function course(){
        return $this->belongsTo(Course::class);
    }
    // An exam has many questions
    public function questions()
    {
        return $this->hasMany(Test::class);
    }
    // An exam is made by an user
    public function userExams()
    {
        return $this->hasMany(UserExam::class);
    }
    // An exam has many califications by different users
    public function califications(){
        return $this->hasMany(Calification::class);
    }

    // Method to filter the active examns
    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }
}
