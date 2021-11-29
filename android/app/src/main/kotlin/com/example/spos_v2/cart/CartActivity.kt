package com.example.spos_v2.cart

import androidx.annotation.NonNull
import com.example.spos_v2.MainActivity.Companion.APP_NAME
import com.example.spos_v2.discovery.SearchDiscoveryProductRequest
import com.example.spos_v2.discovery.SearchDiscoveryProductResponse
import com.google.gson.Gson
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import vn.teko.discovery.core.TerraDiscovery
import vn.teko.discovery.core.model.api.request.DiscoveryRequestBuilder
import vn.teko.discovery.event.manager.DiscoveryManager
import vn.teko.terra.core.android.terra.TerraApp
import android.content.Context
import android.content.Intent

class CartActivity : FlutterActivity() {
    private lateinit var terraApp: TerraApp

    private val _mainScope = CoroutineScope(Dispatchers.Main)

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        terraApp = TerraApp.initializeApp(this@CartActivity.application, APP_NAME)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "course.flutter.dev/products"
        ).setMethodCallHandler { call, result ->
            if (call.method == "getProducts") {
                _mainScope.launch {
                    val res = withContext(Dispatchers.IO) {
                        getProducts()
                    }
                    result.success(res)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    suspend fun getProducts(): String {
        return try {
            val result = terraApp.getTerraBus().request(
                "DISCOVERY_SEARCH_PRODUCT",
                SearchDiscoveryProductRequest(""),
                SearchDiscoveryProductResponse::class.java
            )
            result.getOrNull()?.result?.products?.let {
                Gson().toJson(it)
            }.orEmpty()
        } catch (e: Throwable) {
            println("caught exception: $e")
            e.message.toString()
        }
    }

    companion object {
        fun createDefaultIntent(launchContext: Context): Intent {
            return NewEngineIntentBuilder(CartActivity::class.java).build(launchContext)
        }
    }
}