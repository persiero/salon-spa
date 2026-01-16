<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Servicio extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'id_categoria_servicio', 'id_afectacion_igv', 'id_unidad_sunat',
        'nombre', 'precio', 'duracion_minutos', 'activo'
    ];

    // Relación: Un servicio pertenece a una categoría
    public function categoria()
    {
        return $this->belongsTo(CategoriaServicio::class, 'id_categoria_servicio');
    }
}
