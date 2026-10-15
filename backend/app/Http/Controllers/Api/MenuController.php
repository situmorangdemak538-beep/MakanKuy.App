<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Menu;
use Illuminate\Http\Request;

class MenuController extends Controller
{
    public function index($restaurant_id)
    {
        $menus = Menu::where('restaurant_id', $restaurant_id)->get();

        return response()->json([
            'message' => 'Daftar menu berhasil diambil',
            'data' => $menus,
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'restaurant_id' => 'required|exists:restaurants,id',
            'nama' => 'required|string|max:255',
            'harga' => 'required|integer',
            'gambar' => 'nullable|string',
            'kategori' => 'nullable|string|max:255',
        ]);

        $menu = Menu::create($request->all());

        return response()->json([
            'message' => 'Menu berhasil ditambahkan',
            'data' => $menu,
        ], 201);
    }

    public function update(Request $request, $id)
    {
        $menu = Menu::find($id);

        if (!$menu) {
            return response()->json([
                'message' => 'Menu tidak ditemukan',
            ], 404);
        }

        $menu->update($request->all());

        return response()->json([
            'message' => 'Menu berhasil diperbarui',
            'data' => $menu,
        ]);
    }

    public function destroy($id)
    {
        $menu = Menu::find($id);

        if (!$menu) {
            return response()->json([
                'message' => 'Menu tidak ditemukan',
            ], 404);
        }

        $menu->delete();

        return response()->json([
            'message' => 'Menu berhasil dihapus',
        ]);
    }
}