<?php

namespace Database\Seeders;

use App\Models\User;
// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // We call the seeders which will create the data.
        $this->call([
            UserSeeder::class,
            CourseSeeder::class,
            InscriptionSeeder::class,
            ResourceSeeder::class,
            ExamSeeder::class,
            QuestionSeeder::class,
            UserTestSeeder::class,
            CalificationSeeder::class,
            CommentSeeder::class,
            CertificateSeeder::class,

        ]);
    }
}
