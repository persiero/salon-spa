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
        // 1. Métodos de Pago
        Schema::create('metodos_pago', function (Blueprint $table) {
            $table->id();
            $table->string('nombre', 100)->unique();
            $table->string('descripcion')->nullable();
            $table->boolean('activo')->default(true);
            $table->timestamps();
        });

        // 2. Tipos de Comprobante (Con la bandera para SFS)
        Schema::create('tipos_comprobante', function (Blueprint $table) {
            $table->id();
            $table->string('codigo_sunat', 2)->unique(); // 01, 03, 00
            $table->string('descripcion', 100);
            $table->boolean('genera_xml')->default(true); // 1=SFS, 0=Interno
            $table->timestamps();
        });

        // 3. Estados del Comprobante
        Schema::create('estados_comprobante', function (Blueprint $table) {
            $table->id();
            $table->string('nombre', 50)->unique();
            $table->string('descripcion')->nullable();
            $table->timestamps();
        });

        // 4. Afectaciones IGV
        Schema::create('afectaciones_igv', function (Blueprint $table) {
            $table->id();
            $table->string('codigo_sunat', 2)->unique();
            $table->string('nombre', 100);
            $table->boolean('gravado')->default(false);
            $table->decimal('porcentaje_igv', 5, 2)->nullable();
            $table->timestamps();
        });

        // 5. Unidades SUNAT
        Schema::create('unidades_sunat', function (Blueprint $table) {
            $table->id();
            $table->string('codigo_sunat', 5)->unique();
            $table->string('descripcion', 100);
            $table->string('tipo', 50)->nullable(); // Producto/Servicio
            $table->timestamps();
        });

        // 6. Configuración del Negocio
        Schema::create('config_negocio', function (Blueprint $table) {
            $table->id();
            $table->string('nombre_comercial');
            $table->string('direccion');
            $table->string('telefono', 50)->nullable();
            $table->string('email', 150)->nullable();
            $table->string('ruc', 11)->nullable();
            $table->boolean('precio_incluye_igv')->default(true);
            $table->timestamps();
        });

        // 7. Configuración Tributaria
        Schema::create('config_tributaria', function (Blueprint $table) {
            $table->id();
            $table->decimal('igv_porcentaje', 5, 2)->default(18.00);
            $table->boolean('emision_automatica_cpe')->default(true);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('catalogs_tables');
    }
};
