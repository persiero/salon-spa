<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // 1. Crear tabla ROLES
        Schema::create('roles', function (Blueprint $table) {
            $table->id();
            $table->string('nombre', 100)->unique();
            $table->string('descripcion')->nullable();
            $table->timestamps();
        });

        // 2. Insertar Roles iniciales (Seeds rápidos)
        DB::table('roles')->insert([
            ['nombre' => 'administrador', 'descripcion' => 'Acceso total'],
            ['nombre' => 'encargado', 'descripcion' => 'Gestión operativa'],
            ['nombre' => 'cajero', 'descripcion' => 'Ventas y caja'],
        ]);

        // 3. Modificar tabla USERS (la que creó Breeze)
        Schema::table('users', function (Blueprint $table) {
            // Agregamos la FK id_rol
            $table->foreignId('id_rol')->after('id')->nullable()->constrained('roles');
            $table->boolean('activo')->default(true)->after('password');
            $table->string('apellido')->nullable()->after('name');
            // SoftDeletes por si borras un empleado
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('roles_and_update_users');
    }
};
