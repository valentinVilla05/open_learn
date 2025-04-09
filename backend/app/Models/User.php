<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail; 
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

class User extends Authenticatable
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasApiTokens, HasFactory, Notifiable;

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
    // An user can have many califications
    public function califications(){
        return $this->hasMany(Calification::class);
    }
    public function attemptedExams() {
        return $this->belongsToMany(Exam::class, 'califications')
                    ->withPivot(['calification', 'attempted_at'])
                    ->withTimestamps();
                    // We acced to data through a pivot table
    }

    // Methods to check the role of the user
    public function isAdmin(): bool{
        return $this->rol === 'admin';
    }
    public function isStudent(): bool{
        return $this->rol === 'student';
    }
    public function isTeacher(): bool{  
        return $this->rol === 'teacher';
    }   

    // Methos to get users filtered by role using scopes to avoid repetition of "where"
    public function scopeStudents($query){
        return $query->where('rol', 'student');
    }
    public function scopeTeachers($query){
        return $query->where('rol', 'teacher');
    }
}
