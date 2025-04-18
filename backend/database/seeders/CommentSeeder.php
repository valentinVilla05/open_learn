<?php

namespace Database\Seeders;

use App\Models\Comment;
use App\Models\User;
use App\Models\Resource;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class CommentSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // We create a collection
        $comments = collect();

        // We are gonna create 20 comments
        for($i = 1; $i <= 20; $i++){
            $comment = Comment::factory()->make(); // We dont use "create" because we dont want to save the comment yet

            // If the collectio is not empty there are a 50% chance to get a response
            if ($comments->isNotEmpty() && rand(0, 1)) {
                $comment->response_id = $comments->random()->id;
            } else $comment->response_id = null;

            //Finally we save the comment in the database
            $comment->save();

            $comments->push($comment); // Add the comment to the collections

        }
    }
}
