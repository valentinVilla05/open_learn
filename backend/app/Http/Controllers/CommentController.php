<?php

namespace App\Http\Controllers;

use App\Models\Comment;
use Illuminate\Http\Request;

class CommentController extends Controller
{
    public function showAllComments()
    {
        $comments = Comment::all();
        return response()->json($comments, 200);
    }

    public function showCommentsByResource($resource_id)
    {
        $comments = Comment::where('resource_id', $resource_id)
                    ->whereNull('response_id') // Get the main comments
                    ->with('replies.replies.replies') // Number of replies that take
                    ->get();

        return response()->json($comments, 200);

    }
    public function showCommentByUserId($user_id)
    {
        $comment = Comment::where('user_id', $user_id)->get();
        return response()->json($comment, 200);
    }

    public function createComment(Request $request){
        $data = $request->validate([
            'user_id' => 'required|integer',
            'resource_id' => 'required|integer',
            'response_id' => 'nullable|integer',
            'comment' => 'required|string',
        ]);

        $comment = Comment::create($data);
        return response()->json(['message' => 'The comment was created succesfully'], 200);
    }

    public function updateComment(Request $request, $id){
        $comment = Comment::findOrFail($id);

        $data = $request->validate([
            'comment' => 'string',
        ]);

        $comment->update($data);
        return response()->json(['message' => 'The comment was updated succesfully'], 200);
    }

    public function deleteComment($id){
        $comment = Comment::findOrFail($id);
        $comment->delete();
        return response()->json(['message' => 'The comment was deleted succesfully'], 200);
    }
}
