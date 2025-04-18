<?php

namespace Database\Seeders;

use App\Models\Calification;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class CalificationSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Calification::factory()->count(20)->create();
    }
}
