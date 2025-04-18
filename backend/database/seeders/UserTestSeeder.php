<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Course;
use App\Models\Exam;
use App\Models\UserTest;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class UserTestSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $users = User::all();
        $courses = Course::all();
        $exams = Exam::all();

        UserTest::factory()->count(100)->make()->each(function ($userTest) use ($users, $courses, $exams){
            $userTest->user_id = $users->random()->id;
            $userTest->course_id  = $courses->random()->id;
            $userTest->exam_id = $exams->random()->id;
            $userTest->save();
        });
    }
}
