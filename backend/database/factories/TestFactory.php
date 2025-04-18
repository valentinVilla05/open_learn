<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Test>
 */
class TestFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'statement' => $this->faker->sentence(),
            'correct_answer' => $this->faker->word(),
            'incorrect_answer_1' => $this->faker->word(),
            'incorrect_answer_2' => $this->faker->word(),
            'incorrect_answer_3' => $this->faker->word(),
        ];
    }
}
