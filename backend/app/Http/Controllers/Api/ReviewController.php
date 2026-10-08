<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Review;
use Illuminate\Http\Request;

class ReviewController extends Controller
{
    public function index($restaurant_id)
    {
        $reviews = Review::where('restaurant_id', $restaurant_id)->get();

        return response()->json([
            'message' => 'Daftar review berhasil diambil',
            'data' => $reviews,
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'restaurant_id' => 'required|exists:restaurants,id',
            'rating' => 'required|integer|min:1|max:5',
            'komentar' => 'nullable|string',
        ]);

        $review = Review::create([
            'user_id' => $request->user()->id,
            'restaurant_id' => $request->restaurant_id,
            'rating' => $request->rating,
            'komentar' => $request->komentar,
        ]);

        return response()->json([
            'message' => 'Review berhasil ditambahkan',
            'data' => $review,
        ], 201);
    }
}