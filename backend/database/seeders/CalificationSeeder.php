<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Exam;
use App\Models\Calification;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class CalificationSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $users = User::all();
        $exams = Exam::all();
        Calification::factory()->count(10)->make()->each(function ($calification) use ($users, $exams) {
            do {
                $user_id = $users->random()->id;
                $exam_id = $exams->random()->id;
                $exists = Calification::where('user_id', $user_id)->where('exam_id', $exam_id)->exists();
            } while ($exists);

            $calification->user_id = $user_id;
            $calification->exam_id = $exam_id;
            $calification->save();
        });
    }
}
