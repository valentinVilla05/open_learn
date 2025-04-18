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
            $inscription->user_id = $users->random()->id;
            $inscription->course_id = $courses->random()->id;
            $inscription->save();
        });
    }
}
