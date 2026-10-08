<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class PasswordController extends Controller
{
    public function forgotPassword(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
        ]);

        $user = User::where('email', $request->email)->first();

        if (!$user) {
            return response()->json([
                'message' => 'Email tidak ditemukan',
            ], 404);
        }

        $token = Str::random(60);

        $user->remember_token = $token;
        $user->save();

        return response()->json([
            'message' => 'Token reset password berhasil dibuat',
            'token' => $token,
        ]);
    }

    public function resetPassword(Request $request)
    {
        $request->validate([
            'token' => 'required',
            'password' => 'required|min:8',
        ]);

        $user = User::where('remember_token', $request->token)->first();

        if (!$user) {
            return response()->json([
                'message' => 'Token reset password tidak valid',
            ], 400);
        }

        $user->password = Hash::make($request->password);
        $user->remember_token = null;
        $user->save();

        return response()->json([
            'message' => 'Password berhasil direset',
        ]);
    }
}