<?php

namespace Database\Factories;

use App\Models\Course;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Resource>
 */
class ResourceFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $courses = Course::all();
        return [
            'course_id' => $courses->random()->id, // We take a random id from all the courses
            'type' => $this->faker->randomElement(['document', 'activity', 'link']),
            'name' => $this->faker->sentence(3),
            'description' => $this->faker->paragraph(),
            'limit_date' => $this->faker->dateTimeBetween('now', '+1 month'),
            'url' => $this->faker->url(),
        ];
    }
}
