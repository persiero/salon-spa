<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ConfigFacturador extends Model
{
    protected $table = 'config_facturador';

    protected $fillable = [
        'nombre_pc', 'ruta_data', 'ruta_firma', 'ruta_rpta', 'ruta_repo', 'activo'
    ];
}
