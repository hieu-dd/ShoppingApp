package com.example.spos_v2.cart

import android.content.Context
import com.example.spos_v2.models.AddProductRequest
import vn.teko.cart.core.CartFactory
import vn.teko.cart.core.CartManager
import vn.teko.cart.core.cartConfig
import vn.teko.cart.core.util.ktor.GetTokenCallback
import vn.teko.cart.core.util.ktor.OAuthCallback
import vn.teko.cart.core.util.ktor.RefreshTokenCallback
import vn.teko.cart.domain.model.CartItemEntity
import vn.teko.terra.core.android.bus.TerraBus
import vn.teko.terra.core.android.bus.TerraBusResult
import vn.teko.terra.core.android.bus.event.EventOptions
import vn.teko.terra.core.android.bus.subscriber.Subscriber
import vn.teko.terra.core.android.terra.TerraApp

class CartBus(
    private val cartManager: CartManager,
    private val terraApp: TerraApp
) {
    init {
        subscribeAddItem()
    }

    private fun subscribeAddItem() {
        terraApp.getTerraBus().subscribeAddItemEvent(object : Subscriber<AddProductRequest, CartItemEntity>() {
            override suspend fun handle(
                event: AddProductRequest,
                options: EventOptions,
            ): TerraBusResult<CartItemEntity> {
                val result = cartManager.addItem(
                    sku = event.sku,
                    selectPromotionId = event.selectPromotionId,
                    quantity = event.quantity,
                )
                return if (result.isSuccess()) {
                    TerraBusResult.success(result.get())
                } else {
                    TerraBusResult.failure(result.exception())
                }
            }
        })
    }


    companion object {
        @JvmStatic
        fun getInstance(
            context: Context,
            terraApp: TerraApp,
        ) = CartBus(
            CartFactory.create(
                context,
                cartConfig {
                    tenant = "vnshop"
                    baseUrl = "https://carts-beta.stag.tekoapis.net"
                    this.terminal = "vnshop"
                    this.channel = "vnshop"
                    this.channelType = "online"
                    this.channelId = 6
                    this.logEnable = true
                },
                object : OAuthCallback {
                    override fun getToken(callback: GetTokenCallback) {
                        callback.onSuccess(null)
                    }

                    override fun refreshToken(callback: RefreshTokenCallback) {
                        callback.onSuccess()
                    }
                }
            ),

            terraApp,
        )
    }
}

internal fun TerraBus.subscribeAddItemEvent(subscriber: Subscriber<AddProductRequest, CartItemEntity>) {
    subscribeRequest("CART_ADD_PRODUCT", subscriber)
}