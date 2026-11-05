<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Restaurant;
use Illuminate\Http\Request;

class RestaurantController extends Controller
{
    // Menampilkan daftar restoran.
    public function index(Request $request)
    {
        $query = Restaurant::query();

        if ($request->search) {
            $query->where('nama', 'like', '%' . $request->search . '%');
        }

        if ($request->kategori) {
            $query->where('kategori', $request->kategori);
        }

        if ($request->sort == 'nama') {
            $query->orderBy('nama');
        } else {
            $query->latest();
        }

        return response()->json([
            'message' => 'Daftar restaurant berhasil diambil',
            'data' => $query->get(),
        ]);
    }

    // Menampilkan detail restoran.
    public function show($id)
    {
        $restaurant = Restaurant::find($id);

        if (!$restaurant) {
            return response()->json([
                'message' => 'Restaurant tidak ditemukan',
            ], 404);
        }

        return response()->json([
            'message' => 'Detail restaurant berhasil diambil',
            'data' => $restaurant,
        ]);
    }

    // Admin Restoran membuat restorannya sendiri.
    public function store(Request $request)
    {
        $user = $request->user();

        // Memastikan satu admin hanya memiliki satu restoran.
        if ($user->restaurant()->exists()) {
            return response()->json([
                'message' => 'Akun Anda sudah memiliki restoran.',
            ], 422);
        }

        $validated = $request->validate([
            'nama' => 'required|string|max:255',
            'alamat' => 'required|string|max:255',
            'kategori' => 'required|string|max:255',
            'deskripsi' => 'nullable|string',
            'foto' => 'nullable|string',
            'gambar' => 'nullable|string',
            'rating' => 'nullable|numeric',
            'harga_rata_rata' => 'nullable|integer',
            'jam_buka' => 'required',
            'jam_tutup' => 'nullable',
            'harga_min' => 'nullable|integer',
            'harga_max' => 'nullable|integer',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
        ]);

        $validated['user_id'] = $user->id;
        $validated['status'] = 'pending';

        $restaurant = Restaurant::create($validated);

        return response()->json([
            'message' => 'Restaurant berhasil didaftarkan dan menunggu persetujuan administrator.',
            'data' => $restaurant,
        ], 201);
    }

    // Admin hanya dapat mengubah restoran miliknya.
    public function update(Request $request, $id)
    {
        $restaurant = Restaurant::where('id', $id)
            ->where('user_id', $request->user()->id)
            ->first();

        if (!$restaurant) {
            return response()->json([
                'message' => 'Restaurant tidak ditemukan atau bukan milik Anda.',
            ], 404);
        }

        $validated = $request->validate([
            'nama' => 'sometimes|required|string|max:255',
            'alamat' => 'sometimes|required|string|max:255',
            'kategori' => 'sometimes|required|string|max:255',
            'deskripsi' => 'nullable|string',
            'foto' => 'nullable|string',
            'gambar' => 'nullable|string',
            'rating' => 'nullable|numeric',
            'harga_rata_rata' => 'nullable|integer',
            'jam_buka' => 'sometimes|required',
            'jam_tutup' => 'nullable',
            'harga_min' => 'nullable|integer',
            'harga_max' => 'nullable|integer',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
        ]);

        $restaurant->update($validated);

        return response()->json([
            'message' => 'Restaurant berhasil diperbarui',
            'data' => $restaurant,
        ]);
    }

    // Admin hanya dapat menghapus restoran miliknya.
    public function destroy(Request $request, $id)
    {
        $restaurant = Restaurant::where('id', $id)
            ->where('user_id', $request->user()->id)
            ->first();

        if (!$restaurant) {
            return response()->json([
                'message' => 'Restaurant tidak ditemukan atau bukan milik Anda.',
            ], 404);
        }

        $restaurant->delete();

        return response()->json([
            'message' => 'Restaurant berhasil dihapus',
        ]);
    }

    // Administrator menyetujui restoran.
    public function approve($id)
    {
        $restaurant = Restaurant::find($id);

        if (!$restaurant) {
            return response()->json([
                'message' => 'Restaurant tidak ditemukan',
            ], 404);
        }

        $restaurant->update([
            'status' => 'approved',
        ]);

        return response()->json([
            'message' => 'Restaurant berhasil disetujui',
            'data' => $restaurant,
        ]);
    }

    // Administrator menolak restoran.
    public function reject($id)
    {
        $restaurant = Restaurant::find($id);

        if (!$restaurant) {
            return response()->json([
                'message' => 'Restaurant tidak ditemukan',
            ], 404);
        }

        $restaurant->update([
            'status' => 'rejected',
        ]);

        return response()->json([
            'message' => 'Restaurant berhasil ditolak',
            'data' => $restaurant,
        ]);
    }
}
