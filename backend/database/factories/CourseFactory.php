<?php

namespace Database\Factories;

use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Course>
 */
class CourseFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'teacher_id' => User::where('rol', 'teacher')->inRandomOrder()->first()->id,
            'title' => $this->faker->sentence(2),
            'description' => $this->faker->paragraph(),
            'privacy' => $this->faker->randomElement(['private', 'public']),
            'image' => $this->faker->imageUrl(),
            'max_students' => $this->faker->numberBetween(1, 100),
            'subject' => $this->faker->word(),
            'duration' => $this->faker->randomElement(['10 horas','20 horas', '30 horas']),
        ];
    }
}
