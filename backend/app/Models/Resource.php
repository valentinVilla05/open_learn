<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Resource extends Model
{
    use HasFactory;
    // We declare the attributes that can be mass assigned
    protected $fillable = [
        'course_id',
        'type',
        'name',
        'description',
        'limit_date',
        'url'
    ];
    // We declare the attributes that are cast to a specific type
    protected $casts = [
        'limit_date' => 'datetime',
    ];  

    // We declare the relationship 

    // A resource belongs to a course
    public function course(){
        return $this->belongsTo(Course::class);
    }
    // A resource can have many comments
    public function comments(){
        return $this->hasMany(Comment::class);
    }
}
