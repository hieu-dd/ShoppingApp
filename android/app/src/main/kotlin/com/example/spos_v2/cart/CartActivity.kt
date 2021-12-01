package com.example.spos_v2.cart

import android.content.Context
import android.content.Intent
import androidx.annotation.NonNull
import androidx.lifecycle.lifecycleScope
import com.example.spos_v2.MainActivity.Companion.APP_NAME
import com.example.spos_v2.cart.NativeMethodChannel.CHANNEL_FLUTTER
import com.google.gson.Gson
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.first
import vn.teko.android.core.util.instancesmanager.AppIdentifier
import vn.teko.apollo.extension.getApolloTheme
import vn.teko.cart.core.infrastructure.cart.data.getOrNull
import vn.teko.terra.core.android.terra.TerraApp

class CartActivity : FlutterActivity(), AppIdentifier {
    private lateinit var terraApp: TerraApp
    val cartBus = CartBus.getInstance()

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        NativeMethodChannel.configureChannel(flutterEngine)
        terraApp = TerraApp.initializeApp(this@CartActivity.application, APP_NAME)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL_FLUTTER
        ).setMethodCallHandler { call, result ->

            when (call.method) {
                "getCart" -> lifecycleScope.launchWhenStarted {
                    result.success(getCart())
                }
                "updateItem" -> lifecycleScope.launchWhenStarted {
                    val arguments = call.arguments as Map<*, *>
                    result.success(
                        updateItem(
                            arguments["id"] as String,
                            arguments["quantity"] as? Int,
                            arguments["selected"] as? Boolean
                        )
                    )
                }
                "updateSeller" -> lifecycleScope.launchWhenStarted {
                    val arguments = call.arguments as Map<*, *>
                    result.success(
                        updateItemsBySeller(
                            arguments["id"] as Int,
                            arguments["selected"] as Boolean
                        )
                    )
                }
                "getApolloTheme" -> {
                    result.success(Gson().toJson(this@CartActivity.getApolloTheme()))
                }

                else -> result.notImplemented()
            }
        }
        lifecycleScope.launchWhenStarted {
            cartBus?.getCartFlow()?.collect {
                it.getOrNull()?.let {
                    NativeMethodChannel.refreshCart()
                }
            }
        }
    }

    private suspend fun getCart(): String {
        val cartFlow = CartBus.getInstance()?.getCartFlow()?.first()
        return cartFlow?.getOrNull()?.let {
            Gson().toJson(it)
        }.orEmpty()
    }

    private suspend fun updateItem(id: String, quantity: Int?, selected: Boolean?): Boolean {
        return CartBus.getInstance()?.updateItem(id, quantity, selected)?.isSuccess() ?: false
    }

    private suspend fun updateItemsBySeller(id: Int, selected: Boolean): Boolean {
        return CartBus.getInstance()?.updateItemsBySeller(id, selected)?.isSuccess() ?: false
    }

    override val appIdentifier: String = APP_NAME

    companion object {
        fun createDefaultIntent(launchContext: Context): Intent {
            return NewEngineIntentBuilder(CartActivity::class.java).build(launchContext)
        }
    }
}