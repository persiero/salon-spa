<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class EstadoComprobante extends Model
{
    protected $table = 'estados_comprobante';
    protected $fillable = ['nombre', 'descripcion'];
}
