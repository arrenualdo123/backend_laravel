<?php

namespace Database\Seeders;

use App\Models\Product;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class ProductSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Product::create([
            'name' => 'Resistencia Electrica Modelo X100',
            'description' => 'Resistencia electrica de alta eficiencia para sistemas de calefaccion.',
            'price' => 49.99,
            'stock' => 150,
        ]);

         Product::create([
            'name' => 'Led 100w Blanco Frio',
            'description' => 'Bombilla LED de 100w con luz blanca fría.',
            'price' => 29.99,
            'stock' => 200,
        ]);

        //Product::factory()->count(50)->create();
    }
}
