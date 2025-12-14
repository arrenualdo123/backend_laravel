<?php

namespace Database\Seeders;

use App\Models\Proveedores;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class ProveedoresSeeder extends Seeder
{
     public function run(): void
    {
        Proveedores::create([
            'name' => 'Tecnologías del Futuro S.A. de C.V.',
            'rfc' => 'TFU010203XYZ',
            'contact_name' => 'Ana Torres',
            'email' => 'contacto@tecfuturo.com',
            'phone' => '3312345678',
            'address' => 'Av. Innovación 123, Col. Tecnológica, Guadalajara, Jalisco',
            'website' => 'https://tecfuturo.com',
            'is_active' => true,
        ]);

        Proveedores::create([
            'name' => 'OfiTodo S. de R.L.',
            'rfc' => 'OFI951120ABC',
            'contact_name' => 'Carlos Ramírez',
            'email' => 'ventas@ofitodo.mx',
            'phone' => '5598765432',
            'address' => 'Calle Reforma 456, Centro, Ciudad de México',
            'website' => 'https://ofitodo.mx',
            'is_active' => true,
        ]);

        Proveedores::create([
            'name' => 'Logística Express Mexicana',
            'rfc' => 'LEM100515DEF',
            'contact_name' => 'Sofía Herrera',
            'email' => 'sofia.herrera@logmex.com',
            'phone' => '8112349876',
            'address' => 'Parque Industrial 789, Apodaca, Nuevo León',
            'website' => 'https://logmex.com',
            'is_active' => true,
        ]);

        Proveedores::create([
            'name' => 'Aceros del Norte',
            'rfc' => 'ANO880808GHI',
            'contact_name' => 'Javier Morales',
            'email' => 'jmorales@acerosnorte.com',
            'phone' => '6625551234',
            'address' => 'Blvd. Kino 101, Hermosillo, Sonora',
            'website' => null,
            'is_active' => true,
        ]);

        Proveedores::create([
            'name' => 'Proveedora del Sureste (Inactivo)',
            'rfc' => 'PSU050607JKL',
            'contact_name' => 'Lucía Fernández',
            'email' => 'info@provesureste.com',
            'phone' => '9998887766',
            'address' => 'Calle 60 210, Mérida, Yucatán',
            'website' => 'https://provesureste.com',
            'is_active' => false,
        ]);
    }
}
