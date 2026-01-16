<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Venta extends Model
{
    protected $fillable = [
        'id_cliente', 'id_turno', 'id_caja', 'fecha',
        'op_gravadas', 'op_exoneradas', 'op_inafectas', 'monto_igv', 'total',
        'estado'
    ];

    // Relaciones
    public function cliente()
    {
        return $this->belongsTo(Cliente::class, 'id_cliente');
    }

    public function detalles()
    {
        return $this->hasMany(DetalleVenta::class, 'id_venta');
    }

    public function pagos()
    {
        return $this->hasMany(Pago::class, 'id_venta');
    }

    // Relación clave con Facturación: Una venta tiene UN comprobante
    public function comprobante()
    {
        return $this->hasOne(Comprobante::class, 'id_venta');
    }
}
