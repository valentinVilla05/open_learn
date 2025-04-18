<?php

namespace Database\Seeders;

use App\Models\Certificate;
use App\Models\Course;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class CertificateSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $user = User::where('rol', 'student')->pluck('id');
        $courses = Course::all();

        // We create a certificate for each course assigned to a random student
        foreach ($courses as $course) {
            Certificate::factory()->create([
                'course_id' => $course->id,
                'user_id' => $user->random(),
            ]);
        }
    }
}
