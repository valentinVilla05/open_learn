<?php

namespace Database\Factories;

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
        return [
            'user_id' => $this->faker->numberBetween(1, 6),
            'course_id' => $this->faker->numberBetween(1, 10),
            'certificate_code' => $this->faker->unique()->bothify('CERT-##??##??##??'),
            'ending_date' => $this->faker->dateTimeBetween('-1 year', 'now'),
        ];
    }
}
