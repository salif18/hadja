<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('orders', function (Blueprint $table) {
            $table->id();
            $table->string("userId");
            $table->string("deliberyId")->nullable();
            $table->string("address");
            $table->double("latitude");
            $table->double("longitude");
            $table->double("deliveryLat")->nullable();
            $table->double("deliveryLong")->nullable();
            $table->string("telephone");
            $table->integer("total");
            $table->string("statut_of_delibery")->default("En attente");
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('orders');
    }
};
