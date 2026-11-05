<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        DB::statement("
            ALTER TABLE users
            MODIFY role ENUM('customer', 'admin_resto', 'administrator')
            NOT NULL DEFAULT 'customer'
        ");
    }

    public function down(): void
    {
        DB::statement("
            ALTER TABLE users
            MODIFY role ENUM('customer', 'admin_resto')
            NOT NULL DEFAULT 'customer'
        ");
    }
};