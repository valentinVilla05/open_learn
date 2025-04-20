<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CheckRole
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next, $rol): Response
    {
        $user = $request->user(); // We get the user
        if (!$user || !$user->isAdmin()) {
            return response()->json(['message' => 'Unauthorized'], 401); // If there isn't a user authenticated or the user isn't an admin, we return a message with a 401 status    
        }
        return $next($request);
    }
}
