<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

class User extends Authenticatable
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'rol',
        'register_date',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'register_date' => 'datetime',
            'password' => 'hashed',
        ];
    }

    // Define the realtionshionsips of the user

    // An user can have many courses
    public function courses(){
        return $this->hasMany(Course::class, 'teacher_id');
    }

    // Courses where the user is enrolled
    public function inscriptions(){
        return $this->hasMany(Inscription::class);
    }
    public function enrolledCourses(){
        return $this->belongsToMany(Course::class, 'inscriptions');
    }

    // An user can write many comments
    public function comments(){
        return $this->hasMany(Comment::class);
    }
    // An user can have many certificates
    public function certificates(){
        return $this->hasMany(Certificate::class);
    }
}
