<?php

namespace Database\Seeders;

use App\Models\Test;
use App\Models\User;
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
        $tests = Test::all();
        $exams = Exam::all();

        UserTest::factory()->count(100)->make()->each(function ($userTest) use ($users, $tests, $exams){
            $userTest->user_id = $users->random()->id;
            $userTest->test_id  = $tests->random()->id;
            $userTest->exam_id = $exams->random()->id;
            $userTest->save();
        });
    }
}
