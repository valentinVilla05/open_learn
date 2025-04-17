<?php

namespace Database\Factories;

use App\Models\User;
use App\Models\Course;
use App\Models\Exam;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\UserTest>
 */
class UserTestFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $users = User::all();
        $courses = Course::all();
        $exams = Exam::all();
        return [
            'user_id' => $users->random()->id,
            'test_id' => $courses->random()->id,
            'exam_id' => $exams->random()->id,
            'user_answer' => $this->faker->word(),
            'is_correct' => $this->faker->boolean(),
        ];
    }
}
