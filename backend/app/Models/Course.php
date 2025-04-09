<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Course extends Model
{
    // We declare the attributes that can be mass assigned
    protected $fillable = [
        'title',
        'description',
        'privacy',
        'image',
        'max_students',
        'subject',
        'duration',  
    ];
    
    // Define the relationships of the course

    // A course has one teacher
    public function teacher() {
        return $this->belongsTo(User::class, 'teacher_id');
    }
    // A course can have many inscriptions
    public function inscriptions() {
        return $this->hasMany(Inscription::class);
    }
    // And a course can have many enrolled students (we use the inscriptions table as pivot table)
    public function students() {
        return $this->belongsToMany(User::class, 'inscriptions');
    }
    // A course can have many exams
    public function exams() {
        return $this->hasMany(Exam::class);
    }
    // A course can have many resources
    public function resources(){
        return $this->hasMany(Resources::class);
    }
}
