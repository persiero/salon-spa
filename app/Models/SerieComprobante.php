<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SerieComprobante extends Model
{
    protected $table = 'series_comprobante';

    protected $fillable = [
        'id_tipo_comprobante', 'serie', 'correlativo_actual', 'activo'
    ];

    public function tipo()
    {
        return $this->belongsTo(TipoComprobante::class, 'id_tipo_comprobante');
    }
}
