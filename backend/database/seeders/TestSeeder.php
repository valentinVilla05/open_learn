<?php

namespace Database\Seeders;

use App\Models\Exam;
use App\Models\Test;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class TestSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $exams = Exam::all();

        Test::factory()->count(100)->make()->each(function($test) use ($exams){
            $test->exam_id = $exams->random()->id;
            $test->save();
        });
    }
}
