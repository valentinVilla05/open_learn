<?php

namespace Database\Seeders;

use App\Models\User;
use Database\Factories\UserFactory;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // We create an user Admin
        User::factory()->create([
            'name' => 'Admin',
            'email' => 'admin@open.es',
            'rol' => 'admin',
            'password'=> bcrypt('password'),
        ]);
        // We create 5 users teachers using state to assign them the teacher rol
        User::factory(5)->state([
            'rol' => 'teacher',
        ])->create();
    }
}
