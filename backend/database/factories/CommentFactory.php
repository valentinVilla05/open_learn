<?php

namespace Database\Factories;

use App\Models\User;
use App\Models\Resource;
use App\Models\Comment;
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
      $resources = Resource::all();
      $users = User::all();

        return [
          'user_id' => $users->random()->id,
          'resource_id' => $resources->random()->id,
          'comment' => $this->faker->sentence(10),
        ];
    }
}
