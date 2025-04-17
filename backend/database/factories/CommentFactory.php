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
      // We generate a random number to decide if the comment get a response or not
      $hasResponse = $this->faker->boolean(30); // 30% chance
      // In case the comment has a response, we get a random comment id
      $responseId = $hasResponse ? Comment::pluck('id')->random() : null;

        return [
          'user_id' => $users->random()->id,
          'resource_id' => $resources->random()->id,
          'response_id' => $responseId,
          'comment' => $this->faker->sentence(10),
        ];
    }
}
