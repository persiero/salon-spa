<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Estilista extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'nombre', 'especialidad', 'telefono', 'activo'
    ];
}
