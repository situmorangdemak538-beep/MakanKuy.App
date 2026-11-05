```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('restaurants', function (Blueprint $table) {
            $table->text('deskripsi')->nullable();
            $table->string('foto')->nullable();
            $table->time('jam_tutup')->nullable();
            $table->integer('harga_min')->nullable();
            $table->integer('harga_max')->nullable();
            $table->decimal('latitude', 10, 7)->nullable();
            $table->decimal('longitude', 10, 7)->nullable();
            $table->enum('status', ['pending', 'approved', 'rejected'])
                  ->default('pending');
        });
    }

    public function down(): void
    {
        Schema::table('restaurants', function (Blueprint $table) {
            $table->dropColumn([
                'deskripsi',
                'foto',
                'jam_tutup',
                'harga_min',
                'harga_max',
                'latitude',
                'longitude',
                'status',
            ]);
        });
    }
};
