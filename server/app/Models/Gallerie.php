<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Gallerie extends Model
{
    use HasFactory;
    protected $guarded = [];

    protected $table = 'galleries';

    public function article()
    {
        return $this->belongsTo(Article::class);
    }
}