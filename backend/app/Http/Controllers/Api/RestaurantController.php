<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Restaurant;
use Illuminate\Http\Request;

class RestaurantController extends Controller
{
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

    public function store(Request $request)
    {
        $request->validate([
            'nama' => 'required|string|max:255',
            'alamat' => 'nullable|string',
            'kategori' => 'nullable|string|max:255',
            'deskripsi' => 'nullable|string',
            'foto' => 'nullable|string',
            'jam_buka' => 'nullable',
            'jam_tutup' => 'nullable',
            'harga_min' => 'nullable|integer',
            'harga_max' => 'nullable|integer',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
        ]);

        $restaurant = Restaurant::create($request->all());

        return response()->json([
            'message' => 'Restaurant berhasil ditambahkan',
            'data' => $restaurant,
        ], 201);
    }

    public function update(Request $request, $id)
    {
        $restaurant = Restaurant::find($id);

        if (!$restaurant) {
            return response()->json([
                'message' => 'Restaurant tidak ditemukan',
            ], 404);
        }

        $restaurant->update($request->all());

        return response()->json([
            'message' => 'Restaurant berhasil diperbarui',
            'data' => $restaurant,
        ]);
    }

    public function destroy($id)
    {
        $restaurant = Restaurant::find($id);

        if (!$restaurant) {
            return response()->json([
                'message' => 'Restaurant tidak ditemukan',
            ], 404);
        }

        $restaurant->delete();

        return response()->json([
            'message' => 'Restaurant berhasil dihapus',
        ]);
    }

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