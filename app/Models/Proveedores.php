<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Proveedores extends Model
{
    use HasFactory;

    protected $fillable = [
         'name',          // Nombre o Razón Social del proveedor
         'rfc',           // RFC o identificador fiscal
         'contact_name',  // Nombre de la persona de contacto
         'email',         // Correo electrónico de contacto
         'phone',         // Teléfono de contacto
         'address',       // Dirección fiscal o comercial
         'website',       // Sitio web del proveedor (opcional)
         'is_active',     // Para saber si el proveedor está activo o no
    ];

    protected $casts = [
        'is_active' => 'boolean', // Convierte el valor a true/false
    ];
}
