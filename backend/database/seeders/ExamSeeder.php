<?php

namespace Database\Seeders;

use App\Models\Course;
use App\Models\Exam;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class ExamSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $courses = Course::all();

        // Assign a random course to each exam
        Exam::factory()->count(10)->make()->each(function($exam) use ($courses){
            $exam->course_id = $courses->random()->id;
            $exam->save();
        });
    }
}
