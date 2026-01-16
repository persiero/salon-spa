<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ArchivoSunat extends Model
{
    protected $table = 'archivos_sunat';

    protected $fillable = [
        'id_comprobante', 'nombre_archivo', 'estado', 
        'contenido_error', 'fecha_procesamiento'
    ];
}
