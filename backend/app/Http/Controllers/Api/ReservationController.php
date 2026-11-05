<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Reservation;
use App\Models\Restaurant;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class ReservationController extends Controller
{
    // Menampilkan reservasi sesuai peran pengguna.
    public function index(Request $request)
    {
        $user = $request->user();

        $query = Reservation::with('restaurant');

        if ($user->role === 'customer') {
            $query->where('user_id', $user->id);
        } elseif ($user->role === 'admin_resto') {
            $query->whereHas('restaurant', function ($restaurantQuery) use ($user) {
                $restaurantQuery->where('user_id', $user->id);
            });
        } elseif ($user->role !== 'administrator') {
            return response()->json([
                'message' => 'Anda tidak memiliki akses.',
            ], 403);
        }

        return response()->json([
            'message' => 'Daftar reservasi berhasil diambil',
            'data' => $query->latest()->get(),
        ]);
    }

    // Menampilkan detail reservasi sesuai hak akses.
    public function show(Request $request, $id)
    {
        $user = $request->user();

        $query = Reservation::with('restaurant')->where('id', $id);

        if ($user->role === 'customer') {
            $query->where('user_id', $user->id);
        } elseif ($user->role === 'admin_resto') {
            $query->whereHas('restaurant', function ($restaurantQuery) use ($user) {
                $restaurantQuery->where('user_id', $user->id);
            });
        } elseif ($user->role !== 'administrator') {
            return response()->json([
                'message' => 'Anda tidak memiliki akses.',
            ], 403);
        }

        $reservation = $query->first();

        if (!$reservation) {
            return response()->json([
                'message' => 'Reservasi tidak ditemukan',
            ], 404);
        }

        return response()->json([
            'message' => 'Detail reservasi berhasil diambil',
            'data' => $reservation,
        ]);
    }

    // Membuat reservasi baru dari pelanggan.
    public function store(Request $request)
    {
        if ($request->user()->role !== 'customer') {
            return response()->json([
                'message' => 'Hanya pelanggan yang dapat membuat reservasi.',
            ], 403);
        }

        $validated = $request->validate([
            'restaurant_id' => 'required|exists:restaurants,id',
            'tanggal' => 'required|date',
            'end_date' => 'nullable|date|after_or_equal:tanggal',
            'jam' => 'required|date_format:H:i',
            'jumlah_orang' => 'required|integer|min:1|max:30',
            'exclusive' => 'sometimes|boolean',
            'table_label' => 'nullable|string|max:255',
            'customer_name' => 'nullable|string|max:255',
            'phone' => 'nullable|string|max:30',
            'note' => 'nullable|string',
            'whatsapp' => 'sometimes|boolean',
            'preorder_text' => 'nullable|string',
            'preorder_total' => 'sometimes|integer|min:0',
            'discount_percent' => 'sometimes|integer|min:0|max:100',
        ]);

        $restaurant = Restaurant::where('id', $validated['restaurant_id'])
            ->where('status', 'approved')
            ->first();

        if (!$restaurant) {
            return response()->json([
                'message' => 'Restoran tidak ditemukan atau belum disetujui.',
            ], 422);
        }

        $validated['code'] = 'MK-TRN-' . Str::upper(Str::random(8));
        $validated['user_id'] = $request->user()->id;
        $validated['status'] = 'pending';

        $reservation = Reservation::create($validated);
        $reservation->load('restaurant');

        return response()->json([
            'message' => 'Reservasi berhasil dibuat',
            'data' => $reservation,
        ], 201);
    }

    // Mengubah status reservasi oleh admin restoran pemiliknya.
    public function updateStatus(Request $request, $id)
    {
        $user = $request->user();

        $reservation = Reservation::where('id', $id)
            ->whereHas('restaurant', function ($query) use ($user) {
                $query->where('user_id', $user->id);
            })
            ->first();

        if (!$reservation) {
            return response()->json([
                'message' => 'Reservasi tidak ditemukan atau bukan milik restoran Anda.',
            ], 404);
        }

        $validated = $request->validate([
            'status' => 'required|in:confirmed,completed,cancelled',
        ]);

        $reservation->update([
            'status' => $validated['status'],
        ]);

        $reservation->load('restaurant');

        return response()->json([
            'message' => 'Status reservasi berhasil diperbarui',
            'data' => $reservation,
        ]);
    }

    // Menghapus reservasi milik pelanggan yang sedang login.
    public function destroy(Request $request, $id)
    {
        if ($request->user()->role !== 'customer') {
            return response()->json([
                'message' => 'Hanya pelanggan yang dapat membatalkan reservasi.',
            ], 403);
        }

        $reservation = Reservation::where('id', $id)
            ->where('user_id', $request->user()->id)
            ->first();

        if (!$reservation) {
            return response()->json([
                'message' => 'Reservasi tidak ditemukan',
            ], 404);
        }

        $reservation->update([
            'status' => 'cancelled',
        ]);

        return response()->json([
            'message' => 'Reservasi berhasil dibatalkan',
        ]);
    }
}
