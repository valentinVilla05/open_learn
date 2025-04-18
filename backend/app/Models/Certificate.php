<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;


class Certificate extends Model
{
    use HasFactory;
    protected $fillable = [
        'user_id',
        'course_id',
        'certificate_code',
        'ending_date'
    ];
    // The attributes that should be casted
    protected function casts(): array
    {
        return [
            'ending_date' => 'datetime',
        ];
    }

    // Define the relationships

    // A cerificate belongs to a user
    public function user()
    {
        return $this->belongsTo(User::class);
    }
    // A certificate belongs to a course
    public function course()
    {
        return $this->belongsTo(Course::class);
    }
    // A method to give the format of the certificate date
    public function getFormattedEndingDateAttribute()
    {
        return $this->ending_date?->format('d/m/Y');
    }
    public static function generateCode($userId, $courseId): string{
        return 'CERT-'. strtoupper(uniqid()) . 'U' . $userId . 'C' . $courseId;
    }
}
