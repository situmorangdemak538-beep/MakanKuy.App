<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Restaurant;
use App\Models\Menu;
use App\Models\Reservation;

class AdminController extends Controller
{
    public function dashboard()
    {
        $totalRestoran = Restaurant::count();
        $totalMenu = Menu::count();
        $totalReservasi = Reservation::count();

        $reservasiPending = Reservation::where('status', 'pending')->count();
        $reservasiConfirmed = Reservation::where('status', 'confirmed')->count();
        $reservasiCompleted = Reservation::where('status', 'completed')->count();
        $reservasiCancelled = Reservation::where('status', 'cancelled')->count();

        return response()->json([
            'message' => 'Dashboard admin berhasil diambil',
            'data' => [
                'total_restoran' => $totalRestoran,
                'total_menu' => $totalMenu,
                'total_reservasi' => $totalReservasi,
                'reservasi' => [
                    'pending' => $reservasiPending,
                    'confirmed' => $reservasiConfirmed,
                    'completed' => $reservasiCompleted,
                    'cancelled' => $reservasiCancelled,
                ],
            ],
        ]);
    }
}