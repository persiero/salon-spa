<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Comprobante extends Model
{
    protected $fillable = [
        'id_venta', 'id_tipo_comprobante', 'id_serie_comprobante', 'id_estado_comprobante',
        'numero', 'fecha_emision', 'fecha_envio',
        'receptor_tipo_doc', 'receptor_numero_doc', 'receptor_razon_social', 'receptor_direccion',
        'xml_firmado', 'cdr_sunat', 'hash', 'qr',
        'total_operaciones_gravadas', 'total_igv', 'total_venta',
        'contingencia', 'observaciones'
    ];

    // Relación con el archivo de control SFS
    public function archivosSunat()
    {
        return $this->hasMany(ArchivoSunat::class, 'id_comprobante');
    }
    
    public function tipoComprobante()
    {
        return $this->belongsTo(TipoComprobante::class, 'id_tipo_comprobante');
    }
}
