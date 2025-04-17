<?php

namespace Database\Factories;

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
        return [
            'user_id' => $this->faker->numberBetween(1, 6),
            'exam_id' => $this->faker->numberBetween(1, 10),
            'calification' => $this->faker->randomFloat(2, 0, 10),
            'attempted_at' => $this->faker->dateTimeBetween('-1 year', 'now'),
        ];
    }
}
