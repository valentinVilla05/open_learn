<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Comment extends Model
{
    // We declare the attributes that can be mass assigned
    protected $fillable = [
        'user_id',
        'resource_id',
        'response_id',
        'comment'
    ];
    // We declare the relationships
    // A comment belongs to a user
    public function user(){
        return $this->belongsTo(User::class);
    }
    // A comment belongs to a resource
    public function resource(){
        return $this->belongsTo(Resource::class);
    }
    // A comment can have a response (another comment)
    public function response(){
        return $this->belongsTo(Comment::class);
    }
    public function replies(){
        return $this->hasMany(Comment::class, 'response_id');
    }

    // Method to get root comments (comments without a response)
    public function scopeRootComments($query){
        return $query->whereNull('response_id'); // We get the comments that don't have replies; 
    }
}
