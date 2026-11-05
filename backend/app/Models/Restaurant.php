<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Restaurant extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'nama',
        'alamat',
        'kategori',
        'deskripsi',
        'foto',
        'gambar',
        'rating',
        'harga_rata_rata',
        'jam_buka',
        'jam_tutup',
        'harga_min',
        'harga_max',
        'latitude',
        'longitude',
        'status',
    ];

    // Restoran dimiliki oleh satu akun pengguna.
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function menus()
    {
        return $this->hasMany(Menu::class);
    }

    public function reservations()
    {
        return $this->hasMany(Reservation::class);
    }

    public function reviews()
    {
        return $this->hasMany(Review::class);
    }
}
