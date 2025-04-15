<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;


class Course extends Model
{
    use HasFactory; // We add this line to use the factory later
    // We declare the attributes that can be mass assigned
    protected $fillable = [
        'teacher_id',
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
        return $this->hasMany(Resource::class);
    }
}
