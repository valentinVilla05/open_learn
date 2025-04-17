<?php

namespace Database\Factories;

use App\Models\User;
use App\Models\Course;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Certificate>
 */
class CertificateFactory extends Factory
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
        return [
            'user_id' => $users->random()->id,
            'course_id' => $courses->random()->id,
            'certificate_code' => $this->faker->unique()->bothify('CERT-##??##??##??'),
            'ending_date' => $this->faker->dateTimeBetween('-1 year', 'now'),
        ];
    }
}
