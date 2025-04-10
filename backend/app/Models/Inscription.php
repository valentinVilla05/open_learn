<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Inscription extends Model
{
    // Attributes that are mass assignable
    protected $fillable = [
        'user_id',
        'course_id',
        'inscription_date',
    ];

    // The attributes that should be casted
    protected function casts(): array
    {
        return [
            'inscription_date' => 'datetime',
        ];
    }

    // Define the relationships

    // An inscription belongs to a user
    public function user(){
        return $this->belongsTo(User::class);
    }
    // An inscription belongs to a course
    public function course(){
        return $this->belongsTo(Course::class);
    }

    // We add methods that can be reused 
    public function scopeUsers($query, $userId){
        return $query->where('user_id', $userId);
    }
    public function scopeCourse($query, $courseId){
        return $query->where('course_id', $courseId);
    }
}
