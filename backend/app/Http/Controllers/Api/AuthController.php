<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\Rule;

class AuthController extends Controller
{
    // Registrasi akun baru.
    // Role yang boleh didaftarkan hanya customer dan admin_resto.
    // Administrator tidak boleh dibuat melalui registrasi umum.
    public function register(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|string|min:6',
            'role' => [
                'required',
                Rule::in(['customer', 'admin_resto']),
            ],
        ]);

        $user = User::create([
            'name' => $validated['name'],
            'email' => $validated['email'],
            'password' => $validated['password'],
            'role' => $validated['role'],
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'message' => 'Registrasi berhasil',
            'user' => $user,
            'token' => $token,
        ], 201);
    }

    // Login: memeriksa email, password, dan role.
    public function login(Request $request)
    {
        $validated = $request->validate([
            'email' => 'required|email',
            'password' => 'required|string',
            'role' => [
                'required',
                Rule::in(['customer', 'admin_resto', 'administrator']),
            ],
        ]);

        if (!Auth::attempt([
            'email' => $validated['email'],
            'password' => $validated['password'],
        ])) {
            return response()->json([
                'message' => 'Email atau password salah.',
            ], 401);
        }

        $user = User::where('email', $validated['email'])->first();

        if ($user->role !== $validated['role']) {
            Auth::logout();

            return response()->json([
                'message' => 'Role yang dipilih tidak sesuai dengan akun.',
            ], 403);
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'message' => 'Login berhasil',
            'user' => $user,
            'token' => $token,
        ], 200);
    }

    // Logout.
    public function logout(Request $request)
    {
        $token = $request->user()->currentAccessToken();

        if ($token) {
            $token->delete();
        }

        return response()->json([
            'message' => 'Logout berhasil',
        ]);
    }

    // Mengambil profil pengguna.
    public function profile(Request $request)
    {
        return response()->json([
            'user' => $request->user(),
        ]);
    }

    // Memperbarui nama dan nomor telepon.
    public function updateProfile(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'phone' => 'nullable|string|max:20',
        ]);

        $user = $request->user();

        $user->name = $validated['name'];
        $user->phone = $validated['phone'] ?? null;
        $user->save();

        return response()->json([
            'message' => 'Profil berhasil diperbarui.',
            'user' => $user,
        ], 200);
    }
}