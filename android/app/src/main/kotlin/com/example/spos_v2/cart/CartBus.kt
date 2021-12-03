package com.example.spos_v2.cart

import android.content.Context
import com.example.spos_v2.models.AddProductRequest
import com.example.spos_v2.models.CustomerProfile
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
        cartManager.refreshCart()
        subscribeAddItem()
        subscribeSelectCustomerProfile()
    }

    fun getCartFlow() = cartManager.getCartFlow()

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

    private fun subscribeSelectCustomerProfile() {
        terraApp.getTerraBus().subscribeSelectCustomerProfile(object : Subscriber<CustomerProfile, Unit>() {
            override suspend fun handle(
                event: CustomerProfile,
                options: EventOptions,
            ): TerraBusResult<Unit> {
                NativeMethodChannel.setCustomer(
                    mapOf(
                        "id" to event.id,
                        "name" to event.name,
                        "customerProfileId" to event.customerProfileId,
                        "phone" to event.phone,
                        "fullAddress" to event.fullAddress,
                    )
                )
                return TerraBusResult.success(Unit)
            }
        })
    }

    suspend fun updateItem(lineId: String, quantity: Int?, selected: Boolean?) = cartManager.updateItem(
        lineId,
        quantity = quantity?.toDouble(),
        selected = selected,
        null,
        null,
        null,
        null
    )

    suspend fun updateItemsBySeller(id: Int, selected: Boolean) = cartManager.updateItemsBySeller(id, selected)


    companion object {
        private var instance: CartBus? = null

        @JvmStatic
        fun getInstance() = instance

        @JvmStatic
        fun getInstance(
            context: Context,
            terraApp: TerraApp,
        ): CartBus {
            if (instance == null) {
                instance = CartBus(
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
            return instance!!
        }
    }
}

internal fun TerraBus.subscribeAddItemEvent(subscriber: Subscriber<AddProductRequest, CartItemEntity>) {
    subscribeRequest("CART_ADD_PRODUCT", subscriber)
}

internal fun TerraBus.subscribeSelectCustomerProfile(subscriber: Subscriber<CustomerProfile, Unit>) {
    subscribeRequest("USER_PROFILE_SET_SELECT_CUSTOMER", subscriber)
}
