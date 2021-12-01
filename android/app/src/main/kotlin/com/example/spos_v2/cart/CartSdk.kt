package com.example.spos_v2.cart

class CartSdk(private val cartBus: CartBus, private val delegate: CartDelegate) {

    fun getCartBus() = cartBus

    fun getCartDelegate() = delegate

    companion object {
        private lateinit var instance: CartSdk

        @JvmStatic
        fun createInstance(cartBus: CartBus, delegate: CartDelegate): CartSdk {
            instance = CartSdk(cartBus, delegate);
            return instance;
        }

        @JvmStatic
        fun getInstance() = instance;
    }
}