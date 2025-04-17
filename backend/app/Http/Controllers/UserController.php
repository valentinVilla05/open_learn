<?php

namespace App\Http\Controllers;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;


class UserController extends Controller
{
    // Add a login method to give a token to the user
    public function login(Request $request)
    {
        $data = $request->validate([
            "email" => "required|email",
            "password" => "required"
        ]);

        if (!Auth::attempt($data)) {
            return response()->json([['message' => 'Invalid email or password'], 401]);
        }
        $user = Auth::user();
        $auth_token = $user->createToken('auth_token')->plainTextToken; // We create the token 
        return response()->json(['message' => 'Login successful', 
        'token_type:' => 'Bearer', 
        'auth_token' => $auth_token], 200);
    }

    public function showAllUsers()
    {
        $users = User::all();
        return response()->json($users, 200); // Return the users in JSON with 200 status
    }
    public function showUserById($id)
    {
        $user = User::find($id);
        return response()->json($user, 200); // Return the user in JSON with 200 status
    }
    public function createUser(Request $request)
    {
        try {
            $data = $request->validate([
                'name' => 'required|string|max:255',
                'email' => 'required|string|email|max:255|unique:users',
                'password' => 'required|string|min:8',
            ]);
            $data['password'] = Hash::make($data['password']);
            $data['rol'] = $request->input('rol', 'student');
            $data['register_date'] = now();

            $user = User::create($data);
            return response()->json([
                'message' => 'The user was created successfully.',
                'user' => $user
            ], 201); // Return the new user with a 201 status
        } catch (\Exception $e) {
            return response()->json(['message' => $e->getMessage()], 500);
        }
    }
    public function updateUser(Request $request, $id)
    {
        try {
            $user = User::findOrFail($id);

            $data = $request->validate([
                'rol' => 'nullable|string|in:admin,teacher,student',
            ]);

            $user->update($data);
            return response()->json(['message' => 'The user was updated.'], 200); // Return the updated user with a 200 status
        } catch (\Exception $e) {
            return response()->json(['message' => $e->getMessage()], 500);
        }
    }

    public function deleteUser(Request $request, $id)
    {
        try {
            $user = User::findOrFail($id);
            $user->delete();

            return response()->json(['message' => 'The user was deleted successfully'], 200); // Return the deleted user with a 200 status   
        } catch (\Exception $e) {
            return response()->json(['message' => $e->getMessage()], 500);
        }
    }
}
