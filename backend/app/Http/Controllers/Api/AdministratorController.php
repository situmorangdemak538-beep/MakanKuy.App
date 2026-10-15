<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Restaurant;
use App\Models\Category;
use App\Models\Reservation;

class AdministratorController extends Controller
{
    public function dashboard()
    {
        $totalPengguna = User::count();
        $totalRestoran = Restaurant::count();
        $totalKategori = Category::count();
        $totalReservasi = Reservation::count();

        $restoranPending = Restaurant::where('status', 'pending')->count();
        $restoranApproved = Restaurant::where('status', 'approved')->count();
        $restoranRejected = Restaurant::where('status', 'rejected')->count();

        return response()->json([
            'message' => 'Dashboard administrator berhasil diambil',
            'data' => [
                'total_pengguna' => $totalPengguna,
                'total_restoran' => $totalRestoran,
                'total_kategori' => $totalKategori,
                'total_reservasi' => $totalReservasi,
                'restoran' => [
                    'pending' => $restoranPending,
                    'approved' => $restoranApproved,
                    'rejected' => $restoranRejected,
                ],
            ],
        ]);
    }
}