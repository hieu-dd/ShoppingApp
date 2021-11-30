package com.example.spos_v2.models

data class AddProductRequest(
    val sku: String,
    val selectPromotionId: Int? = null,
    val quantity: Double = 1.0,
)