<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Course;
use Database\Factories\CourseFactory;
use Database\Factories\UserFactory;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class CourseSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // We create 10 teachers
        $teacher = User::where('rol', 'teacher')->pluck('id');

        Course::factory(10)->create([
            'teacher_id' => $teacher->random(),
        ]);
    }
}
