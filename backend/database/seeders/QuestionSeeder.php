<?php

namespace Database\Seeders;

use App\Models\Exam;
use App\Models\Question;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class QuestionSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $exams = Exam::all();

        Question::factory()->count(100)->make()->each(function($test) use ($exams){
            $test->exam_id = $exams->random()->id;
            $test->save();
        });
    }
}
