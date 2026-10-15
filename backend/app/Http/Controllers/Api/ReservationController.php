<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Reservation;
use Illuminate\Http\Request;

class ReservationController extends Controller
{
    public function index(Request $request)
    {
        $reservations = Reservation::where('user_id', $request->user()->id)->get();

        return response()->json([
            'message' => 'Daftar reservasi berhasil diambil',
            'data' => $reservations,
        ]);
    }

    public function show(Request $request, $id)
    {
        $reservation = Reservation::where('id', $id)
            ->where('user_id', $request->user()->id)
            ->first();

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

    public function store(Request $request)
    {
        $request->validate([
            'restaurant_id' => 'required|exists:restaurants,id',
            'tanggal' => 'required|date',
            'jam' => 'required',
            'jumlah_orang' => 'required|integer|min:1',
        ]);

        $reservation = Reservation::create([
            'user_id' => $request->user()->id,
            'restaurant_id' => $request->restaurant_id,
            'tanggal' => $request->tanggal,
            'jam' => $request->jam,
            'jumlah_orang' => $request->jumlah_orang,
            'status' => 'pending',
        ]);

        return response()->json([
            'message' => 'Reservasi berhasil dibuat',
            'data' => $reservation,
        ], 201);
    }

    public function updateStatus(Request $request, $id)
    {
        $reservation = Reservation::find($id);

        if (!$reservation) {
            return response()->json([
                'message' => 'Reservasi tidak ditemukan',
            ], 404);
        }

        $request->validate([
            'status' => 'required|in:pending,confirmed,completed,cancelled',
        ]);

        $reservation->update([
            'status' => $request->status,
        ]);

        return response()->json([
            'message' => 'Status reservasi berhasil diperbarui',
            'data' => $reservation,
        ]);
    }

    public function destroy(Request $request, $id)
    {
        $reservation = Reservation::where('id', $id)
            ->where('user_id', $request->user()->id)
            ->first();

        if (!$reservation) {
            return response()->json([
                'message' => 'Reservasi tidak ditemukan',
            ], 404);
        }

        $reservation->delete();

        return response()->json([
            'message' => 'Reservasi berhasil dihapus',
        ]);
    }
}