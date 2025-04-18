<?php

namespace Database\Seeders;

use App\Models\Inscription;
use App\Models\User;
use App\Models\Course;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class InscriptionSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $users = User::all();
        $courses = Course::all();

        // Create inscriptions assigning a random course and user in each one
        Inscription::factory()->count(20)->make()->each(function ($inscription) use ($users, $courses) {
            do {
                $user_id = $users->random()->id;
                $course_id = $courses->random()->id;
                $exists = Inscription::where('user_id', $user_id)
                                     ->where('course_id', $course_id)
                                     ->exists();
            } while ($exists); // WE have to check if the inscription already exists because it has to be unique
        
            $inscription->user_id = $user_id;
            $inscription->course_id = $course_id;
            $inscription->save();
        });
    }
}
