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
        // 1. Categorías
        Schema::create('categorias_servicio', function (Blueprint $table) {
            $table->id();
            $table->string('nombre', 150)->unique();
            $table->string('descripcion')->nullable();
            $table->boolean('activo')->default(true);
            $table->softDeletes();
            $table->timestamps();
        });

        // 2. Servicios
        Schema::create('servicios', function (Blueprint $table) {
            $table->id();
            // Relaciones FK
            $table->foreignId('id_categoria_servicio')->nullable()->constrained('categorias_servicio')->nullOnDelete();
            $table->foreignId('id_afectacion_igv')->constrained('afectaciones_igv');
            $table->foreignId('id_unidad_sunat')->constrained('unidades_sunat');
            
            $table->string('nombre', 150);
            $table->decimal('precio', 10, 2);
            $table->integer('duracion_minutos')->nullable();
            $table->boolean('activo')->default(true);
            $table->softDeletes();
            $table->timestamps();
        });

        // 3. Productos
        Schema::create('productos', function (Blueprint $table) {
            $table->id();
            $table->foreignId('id_afectacion_igv')->constrained('afectaciones_igv');
            $table->foreignId('id_unidad_sunat')->constrained('unidades_sunat');
            
            $table->string('nombre', 150)->index();
            $table->string('descripcion')->nullable();
            $table->decimal('precio', 10, 2);
            $table->integer('stock_actual')->default(0);
            $table->integer('stock_minimo')->default(0);
            $table->boolean('activo')->default(true);
            $table->softDeletes();
            $table->timestamps();
        });

        // 4. Movimientos Inventario
        Schema::create('movimientos_inventario', function (Blueprint $table) {
            $table->id();
            $table->foreignId('id_producto')->constrained('productos')->restrictOnDelete();
            $table->foreignId('id_usuario')->nullable()->constrained('users')->nullOnDelete();
            
            $table->enum('tipo', ['entrada', 'salida_venta', 'salida_consumo', 'ajuste']);
            $table->integer('cantidad');
            $table->string('motivo')->nullable();
            $table->string('referencia', 100)->nullable(); // Nro Comprobante proveedor, etc
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('services_inventory_tables');
    }
};
