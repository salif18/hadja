<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Article extends Model
{
    use HasFactory;
    protected $guarded =[];
    // protected $fillable = [
    //     'product_id',
    //     'name',
    //     'img',
    //     'categorie',
    //     'desc',
    //     'price',
    //     'stock',
    //     'likes',
    //     'disLikes'
    // ];

    public function galleries()
    {
        return $this->hasMany(Gallerie::class);
    }
}
