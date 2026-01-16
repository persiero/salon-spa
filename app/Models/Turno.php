<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Turno extends Model
{
    protected $fillable = [
        'id_cliente', 'id_estilista', 'fecha_inicio', 'fecha_fin', 'estado', 'observaciones'
    ];

    public function cliente()
    {
        return $this->belongsTo(Cliente::class, 'id_cliente');
    }

    public function estilista()
    {
        return $this->belongsTo(Estilista::class, 'id_estilista');
    }

    // Relación Muchos a Muchos con Servicios
    // Esto te permite hacer: $turno->servicios y obtener la lista con sus precios
    public function servicios()
    {
        return $this->belongsToMany(Servicio::class, 'turno_servicio', 'id_turno', 'id_servicio')
                    ->withPivot('precio_aplicado')
                    ->withTimestamps();
    }
}
