<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class OrderItem extends Model
{
    use HasFactory;
    protected $guarded = [];

    protected $table = 'orders_items';  // Ajoutez cette ligne

    public function orders()
    {
        return $this->belongsTo(Order::class);
    }
}