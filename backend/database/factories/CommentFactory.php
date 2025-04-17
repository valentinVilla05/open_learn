<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Comment>
 */
class CommentFactory extends Factory
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
          'resource_id' => $this->faker->numberBetween(1, 20),
          'response_id' => $this->faker->numberBetween(1, 20),
          'comment' => $this->faker->sentence(10),
        ];
    }
}
