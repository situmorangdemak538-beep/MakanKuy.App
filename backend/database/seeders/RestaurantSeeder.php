<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class RestaurantSeeder extends Seeder
{
    public function run()
    {
        DB::table('restaurants')->insert([
            [
                'nama' => 'Restoran Padang Sederhana',
                'kategori' => 'Masakan Padang',
                'alamat' => 'Jl. Sudirman No. 123, Jakarta',
                'rating' => 4.5,
                'jam_buka' => '10:00',
                'harga_rata_rata' => 25000,
                'gambar' => 'padang.jpg',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'nama' => 'Warung Nasi Goreng Pak Joko',
                'kategori' => 'Makanan Lokal',
                'alamat' => 'Jl. Gatot Subroto No. 45, Jakarta',
                'rating' => 4.8,
                'jam_buka' => '17:00',
                'harga_rata_rata' => 15000,
                'gambar' => 'nasigoreng.jpg',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
    }
}