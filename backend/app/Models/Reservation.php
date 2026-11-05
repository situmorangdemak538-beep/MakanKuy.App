<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Reservation extends Model
{
    use HasFactory;

    protected $fillable = [
        'code',
        'user_id',
        'restaurant_id',
        'tanggal',
        'end_date',
        'jam',
        'jumlah_orang',
        'status',
        'exclusive',
        'table_label',
        'customer_name',
        'phone',
        'note',
        'whatsapp',
        'preorder_text',
        'preorder_total',
        'discount_percent',
    ];

    protected function casts(): array
    {
        return [
            'tanggal' => 'date',
            'end_date' => 'date',
            'exclusive' => 'boolean',
            'whatsapp' => 'boolean',
            'preorder_total' => 'integer',
            'discount_percent' => 'integer',
            'jumlah_orang' => 'integer',
        ];
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function restaurant()
    {
        return $this->belongsTo(Restaurant::class);
    }
}