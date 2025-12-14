<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class ProveedoresController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
         // Se aplica la misma lógica: solo mostrar los activos.
        $providers = Providers::where('is_active', true)->get();
        return response()->json([
            'success' => true,
            'data' => $providers
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
         // Adaptamos las reglas de validación al modelo de Proveedor.
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'rfc' => 'required|string|max:13|unique:providers,rfc',
            'contact_name' => 'nullable|string|max:255',
            'email' => 'required|email|max:255|unique:providers,email',
            'phone' => 'required|string|max:20',
            'address' => 'nullable|string',
            'website' => 'nullable|url',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $provider = Providers::create($request->all());

        return response()->json([
            'success' => true,
            'data' => $provider,
            'message' => 'Proveedor creado exitosamente.'
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
         // Usamos find() para manejar manualmente el error 404.
        $provider = Providers::find($id);

        if (!$provider) {
            return response()->json([
                'success' => false,
                'message' => 'Proveedor no encontrado.'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'data' => $provider
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $provider = Providers::find($id);

        if (!$provider) {
            return response()->json([
                'success' => false,
                'message' => 'Proveedor no encontrado.'
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'name' => 'sometimes|string|max:255',
            'rfc' => ['sometimes', 'string', 'max:13', Rule::unique('providers')->ignore($provider->id)],
            'contact_name' => 'sometimes|nullable|string|max:255',
            'email' => ['sometimes', 'email', 'max:255', Rule::unique('providers')->ignore($provider->id)],
            'phone' => 'sometimes|string|max:20',
            'address' => 'sometimes|nullable|string',
            'website' => 'sometimes|nullable|url',
            'is_active' => 'sometimes|boolean',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $provider->update($request->all());

        return response()->json([
            'success' => true,
            'data' => $provider,
            'message' => 'Proveedor actualizado exitosamente.'
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
         $provider = Providers::find($id);

        if (!$provider) {
            return response()->json([
                'success' => false,
                'message' => 'Proveedor no encontrado.'
            ], 404);
        }

        $provider->delete();

        return response()->json([
            'success' => true,
            'message' => 'Proveedor eliminado exitosamente.'
        ]);
    }
}
