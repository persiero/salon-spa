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
        // --- MÓDULO OPERATIVO ---

        // 1. Cajas
        Schema::create('cajas', function (Blueprint $table) {
            $table->id();
            $table->foreignId('id_usuario_apertura')->constrained('users');
            $table->foreignId('id_usuario_cierre')->nullable()->constrained('users');
            $table->dateTime('fecha_apertura');
            $table->dateTime('fecha_cierre')->nullable();
            $table->decimal('monto_apertura', 10, 2)->default(0);
            $table->decimal('monto_cierre', 10, 2)->nullable();
            $table->enum('estado', ['abierta', 'cerrada'])->default('abierta');
            $table->timestamps();
        });

        // 2. Turnos
        Schema::create('turnos', function (Blueprint $table) {
            $table->id();
            $table->foreignId('id_cliente')->constrained('clientes');
            $table->foreignId('id_estilista')->constrained('estilistas');
            $table->dateTime('fecha_inicio');
            $table->dateTime('fecha_fin')->nullable();
            $table->string('estado', 30)->default('en_atencion');
            $table->text('observaciones')->nullable();
            $table->timestamps();
        });

        // 3. Turno - Servicios (Detalle del turno)
        Schema::create('turno_servicio', function (Blueprint $table) {
            $table->id();
            $table->foreignId('id_turno')->constrained('turnos')->cascadeOnDelete();
            $table->foreignId('id_servicio')->constrained('servicios');
            $table->decimal('precio_aplicado', 10, 2); // Precio pactado en ese momento
            $table->timestamps();
        });

        // 4. Ventas
        Schema::create('ventas', function (Blueprint $table) {
            $table->id();
            $table->foreignId('id_cliente')->nullable()->constrained('clientes');
            $table->foreignId('id_turno')->nullable()->constrained('turnos');
            $table->foreignId('id_caja')->constrained('cajas');
            $table->dateTime('fecha');
            
            // Snapshots Totales
            $table->decimal('op_gravadas', 10, 2)->default(0);
            $table->decimal('op_exoneradas', 10, 2)->default(0);
            $table->decimal('op_inafectas', 10, 2)->default(0);
            $table->decimal('monto_igv', 10, 2)->default(0);
            $table->decimal('total', 10, 2);
            
            $table->enum('estado', ['pagada', 'anulada'])->default('pagada');
            $table->timestamps();
        });

        // 5. Detalles Venta
        Schema::create('detalles_venta', function (Blueprint $table) {
            $table->id();
            $table->foreignId('id_venta')->constrained('ventas')->cascadeOnDelete();
            $table->enum('tipo_item', ['servicio', 'producto']);
            
            $table->foreignId('id_servicio')->nullable()->constrained('servicios');
            $table->foreignId('id_producto')->nullable()->constrained('productos');
            
            // Snapshot del Ítem (Inmutabilidad)
            $table->string('nombre_item');
            $table->string('codigo_afectacion_igv', 10);
            $table->decimal('porcentaje_igv', 5, 2);
            $table->string('codigo_unidad_medida', 10);
            
            $table->integer('cantidad');
            $table->decimal('valor_unitario', 10, 2); // Sin IGV
            $table->decimal('precio_unitario', 10, 2); // Con IGV
            $table->decimal('igv_total_linea', 10, 2);
            $table->decimal('subtotal', 10, 2);
            
            $table->timestamps();
        });

        // 6. Pagos
        Schema::create('pagos', function (Blueprint $table) {
            $table->id();
            $table->foreignId('id_venta')->constrained('ventas')->cascadeOnDelete();
            $table->foreignId('id_metodo_pago')->constrained('metodos_pago');
            $table->decimal('monto', 10, 2);
            $table->string('referencia', 100)->nullable();
            $table->dateTime('fecha');
            $table->timestamps();
        });

        // --- MÓDULO FACTURACIÓN (SFS) ---

        // 7. Series
        Schema::create('series_comprobante', function (Blueprint $table) {
            $table->id();
            $table->foreignId('id_tipo_comprobante')->constrained('tipos_comprobante');
            $table->string('serie', 4); // F001
            $table->integer('correlativo_actual')->default(0);
            $table->boolean('activo')->default(true);
            $table->unique(['id_tipo_comprobante', 'serie']);
            $table->timestamps();
        });

        // 8. Comprobantes
        Schema::create('comprobantes', function (Blueprint $table) {
            $table->id();
            $table->foreignId('id_venta')->constrained('ventas');
            $table->foreignId('id_tipo_comprobante')->constrained('tipos_comprobante');
            $table->foreignId('id_serie_comprobante')->constrained('series_comprobante');
            $table->foreignId('id_estado_comprobante')->constrained('estados_comprobante');
            
            $table->string('numero', 20)->unique(); // F001-000021
            $table->dateTime('fecha_emision');
            $table->dateTime('fecha_envio')->nullable();
            
            // Snapshot Receptor
            $table->string('receptor_tipo_doc', 20)->nullable();
            $table->string('receptor_numero_doc', 20)->nullable();
            $table->string('receptor_razon_social')->nullable();
            $table->string('receptor_direccion')->nullable();
            
            // Datos SFS
            $table->mediumText('xml_firmado')->nullable(); // Guardaremos ruta o base64
            $table->mediumText('cdr_sunat')->nullable();
            $table->string('hash')->nullable();
            $table->text('qr')->nullable();
            
            // Totales espejo
            $table->decimal('total_operaciones_gravadas', 10, 2)->nullable();
            $table->decimal('total_igv', 10, 2)->nullable();
            $table->decimal('total_venta', 10, 2);
            
            $table->boolean('contingencia')->default(false);
            $table->text('observaciones')->nullable();
            $table->timestamps();
        });

        // 9. Configuración Facturador Local
        Schema::create('config_facturador', function (Blueprint $table) {
            $table->id();
            $table->string('nombre_pc')->nullable();
            $table->string('ruta_data');
            $table->string('ruta_firma');
            $table->string('ruta_rpta');
            $table->string('ruta_repo')->nullable();
            $table->boolean('activo')->default(true);
            $table->timestamps();
        });

        // 10. Archivos SUNAT (Control de intercambio SFS)
        Schema::create('archivos_sunat', function (Blueprint $table) {
            $table->id();
            $table->foreignId('id_comprobante')->constrained('comprobantes')->cascadeOnDelete();
            $table->string('nombre_archivo');
            $table->enum('estado', ['generado', 'enviado_sfs', 'procesado_ok', 'procesado_error'])->default('generado');
            $table->text('contenido_error')->nullable();
            $table->dateTime('fecha_procesamiento')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('operations_and_invoicing_tables');
    }
};
