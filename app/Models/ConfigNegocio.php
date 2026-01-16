<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ConfigNegocio extends Model
{
    protected $table = 'config_negocio';

    protected $fillable = [
        'nombre_comercial', 'direccion', 'telefono', 'email', 'ruc', 'precio_incluye_igv'
    ];
}
