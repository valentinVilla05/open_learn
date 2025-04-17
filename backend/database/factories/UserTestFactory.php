<?php

namespace Database\Factories;

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
        return [
            'user_id' => $this->faker->numberBetween(1, 6),
            'test_id' => $this->faker->numberBetween(1, 100),
            'exam_id' => $this->faker->numberBetween(1, 10),
            'user_answer' => $this->faker->word(),
            'is_correct' => $this->faker->boolean(),
        ];
    }
}
