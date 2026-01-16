<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TurnoServicio extends Model
{
    protected $table = 'turno_servicio';

    protected $fillable = [
        'id_turno', 'id_servicio', 'precio_aplicado'
    ];
}
