<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;

class UserController extends Controller
{
    public function index()
    {
        $users = User::select(
            'id',
            'name',
            'email',
            'role',
            'blocked',
            'created_at'
        )->get();

        return response()->json([
            'message' => 'Daftar pengguna berhasil diambil',
            'data' => $users,
        ]);
    }

    public function block($id)
    {
        $user = User::find($id);

        if (!$user) {
            return response()->json([
                'message' => 'Pengguna tidak ditemukan',
            ], 404);
        }

        $user->blocked = true;
        $user->save();

        return response()->json([
            'message' => 'Pengguna berhasil diblokir',
        ]);
    }

    public function destroy($id)
    {
        $user = User::find($id);

        if (!$user) {
            return response()->json([
                'message' => 'Pengguna tidak ditemukan',
            ], 404);
        }

        $user->delete();

        return response()->json([
            'message' => 'Pengguna berhasil dihapus',
        ]);
    }
}