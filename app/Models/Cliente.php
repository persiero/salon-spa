<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Cliente extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'nombre', 'apellido', 'tipo_documento', 'numero_documento',
        'direccion', 'telefono', 'email'
    ];

    public function ventas()
    {
        return $this->hasMany(Venta::class, 'id_cliente');
    }
}
