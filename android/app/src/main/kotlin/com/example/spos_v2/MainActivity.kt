package com.example.spos_v2

import androidx.annotation.NonNull
import com.example.spos_v2.discovery.SearchDiscoveryProductRequest
import com.example.spos_v2.discovery.SearchDiscoveryProductResponse
import com.google.gson.Gson
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import vn.teko.discovery.core.TerraDiscovery
import vn.teko.discovery.core.model.api.request.DiscoveryRequestBuilder
import vn.teko.discovery.event.manager.DiscoveryManager
import vn.teko.terra.core.android.terra.TerraApp

class MainActivity : FlutterActivity() {
    private lateinit var terraApp: TerraApp

    private val _mainScope = CoroutineScope(Dispatchers.Main)

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        terraApp = TerraApp.initializeApp(this@MainActivity.application, APP_NAME)
        TerraDiscovery.getInstance(terraApp = terraApp)
        DiscoveryManager.getInstance(terraApp)
        DiscoveryRequestBuilder.setTerminalCode("CP01")
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "course.flutter.dev/products").setMethodCallHandler { call, result ->
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
        const val APP_NAME = "SPOS_v2"
    }
}
