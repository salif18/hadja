<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Gallerie extends Model
{
    use HasFactory;
    protected $guarded = [];
    // protected $fillable = [
    //     'article_id',
    //     'img_path'
    // ];
    protected $table = 'galleries';  // Ajoutez cette ligne
    public function article()
    {
        return $this->belongsTo(Article::class);
    }
}
