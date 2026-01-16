<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Caja extends Model
{
    protected $fillable = [
        'id_usuario_apertura', 'id_usuario_cierre',
        'fecha_apertura', 'fecha_cierre',
        'monto_apertura', 'monto_cierre',
        'estado'
    ];

    public function usuarioApertura()
    {
        return $this->belongsTo(User::class, 'id_usuario_apertura');
    }

    public function ventas()
    {
        return $this->hasMany(Venta::class, 'id_caja');
    }
}
