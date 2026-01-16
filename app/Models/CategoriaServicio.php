<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class CategoriaServicio extends Model
{
    use SoftDeletes;

    protected $table = 'categorias_servicio'; // Laravel suele buscar "categoria_servicios"

    protected $fillable = [
        'nombre', 'descripcion', 'activo'
    ];

    public function servicios()
    {
        return $this->hasMany(Servicio::class, 'id_categoria_servicio');
    }
}
