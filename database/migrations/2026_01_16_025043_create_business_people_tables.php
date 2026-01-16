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
        // 1. Clientes
        Schema::create('clientes', function (Blueprint $table) {
            $table->id();
            $table->string('nombre', 150);
            $table->string('apellido', 150)->nullable();
            $table->string('tipo_documento', 20)->nullable(); // DNI, RUC
            $table->string('numero_documento', 20)->nullable()->index();
            $table->string('direccion')->nullable();
            $table->string('telefono', 50)->nullable();
            $table->string('email', 150)->nullable();
            $table->softDeletes(); // deleted_at
            $table->timestamps();
        });

        // 2. Estilistas
        Schema::create('estilistas', function (Blueprint $table) {
            $table->id();
            $table->string('nombre', 150);
            $table->string('especialidad', 150)->nullable();
            $table->string('telefono', 50)->nullable();
            $table->boolean('activo')->default(true);
            $table->softDeletes();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('business_people_tables');
    }
};
