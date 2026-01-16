<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DetalleVenta extends Model
{
    protected $table = 'detalles_venta'; // Forzamos el nombre por si Laravel se confunde

    protected $fillable = [
        'id_venta', 'tipo_item', 'id_servicio', 'id_producto',
        'nombre_item', 'codigo_afectacion_igv', 'porcentaje_igv', 'codigo_unidad_medida',
        'cantidad', 'valor_unitario', 'precio_unitario', 'igv_total_linea', 'subtotal'
    ];
}
