<?php

namespace Database\Factories;

use App\Models\Course;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Exam>
 */
class ExamFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $courses= Course::all();
        return [
            'course_id' => $courses->random()->id,
            'title' => $this->faker->sentence(3),
            'is_active' => $this->faker->boolean(),
        ];
    }
}
