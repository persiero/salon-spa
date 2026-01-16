<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TipoComprobante extends Model
{
    protected $table = 'tipos_comprobante';

    protected $fillable = [
        'codigo_sunat', 'descripcion', 'genera_xml'
    ];
}
