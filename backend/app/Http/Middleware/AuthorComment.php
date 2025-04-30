<?php

namespace App\Http\Middleware;

use App\Models\Comment;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class AuthorComment
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        $comment_id = $request->route('id');
        $comment = Comment::find($comment_id);

        if(!$comment){
            return response()->json(['error' => 'Comment not found'], 404);
        }

        if($request->user()->id !== $comment->user_id){
            return response()->json(['error' => 'Unauthorized'], 403);
        }
        
        return $next($request);
    }
}
