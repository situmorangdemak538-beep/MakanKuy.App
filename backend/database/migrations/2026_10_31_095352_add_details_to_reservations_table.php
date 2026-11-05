
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('reservations', function (Blueprint $table) {
            $table->string('code')->nullable()->unique();
            $table->date('end_date')->nullable();
            $table->boolean('exclusive')->default(false);
            $table->string('table_label')->nullable();
            $table->string('customer_name')->nullable();
            $table->string('phone')->nullable();
            $table->text('note')->nullable();
            $table->boolean('whatsapp')->default(true);
            $table->text('preorder_text')->nullable();
            $table->unsignedInteger('preorder_total')->default(0);
            $table->unsignedInteger('discount_percent')->default(0);
        });
    }

    public function down(): void
    {
        Schema::table('reservations', function (Blueprint $table) {
            $table->dropUnique(['code']);

            $table->dropColumn([
                'code',
                'end_date',
                'exclusive',
                'table_label',
                'customer_name',
                'phone',
                'note',
                'whatsapp',
                'preorder_text',
                'preorder_total',
                'discount_percent',
            ]);
        });
    }
};
