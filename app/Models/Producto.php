<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Producto extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'id_afectacion_igv', 'id_unidad_sunat',
        'nombre', 'descripcion', 'precio', 'stock_actual', 'stock_minimo', 'activo'
    ];
    
    // Si necesitas ver el historial de movimientos de este producto
    public function movimientos()
    {
        return $this->hasMany(MovimientoInventario::class, 'id_producto');
    }
}
