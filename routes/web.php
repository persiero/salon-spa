<?php

use App\Http\Controllers\ProfileController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\Admin\VentaController;

// --- ZONA PÚBLICA (Futuro) ---
Route::get('/', function () {
    return view('welcome');
});

// --- ZONA ADMIN (Protegida) ---
Route::middleware(['auth', 'verified']) // Requiere login
    ->prefix('admin')                   // La URL será /admin/...
    ->name('admin.')                    // Las rutas se llamarán admin.ventas...
    ->group(function () {

    // Dashboard: salon-spa.test/admin/dashboard
    Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');

    // Módulos
    Route::resource('ventas', VentaController::class);
    // Route::resource('inventario', InventarioController::class);
});

Route::get('/dashboard', function () {
    return view('dashboard');
})->middleware(['auth', 'verified'])->name('dashboard');

Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
});

require __DIR__.'/auth.php';
