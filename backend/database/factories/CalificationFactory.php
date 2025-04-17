<?php

namespace Database\Factories;

use App\Models\User;
use App\Models\Exam;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Calification>
 */
class CalificationFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $users = User::all();
        $exams = Exam::all();
        return [
            'user_id' => $users->random()->id,
            'exam_id' => $exams->random()->id,
            'calification' => $this->faker->randomFloat(2, 0, 10),
            'attempted_at' => $this->faker->dateTimeBetween('-1 year', 'now'),
        ];
    }
}
