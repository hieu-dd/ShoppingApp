package com.example.spos_v2

import android.os.Bundle
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.ListView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.AppCompatButton
import androidx.lifecycle.lifecycleScope
import com.example.spos_v2.cart.CartActivity
import com.example.spos_v2.cart.CartBus
import com.example.spos_v2.discovery.SearchDiscoveryProductRequest
import com.example.spos_v2.discovery.SearchDiscoveryProductResponse
import com.example.spos_v2.models.AddProductRequest
import vn.teko.apollo.ApolloTheme
import vn.teko.apollo.config.toApolloConfiguration
import vn.teko.cart.domain.model.CartItemEntity
import vn.teko.discovery.core.TerraDiscovery
import vn.teko.discovery.core.model.DiscoveryProduct
import vn.teko.discovery.core.model.api.request.DiscoveryRequestBuilder
import vn.teko.discovery.event.manager.DiscoveryManager
import vn.teko.terra.core.android.terra.TerraApp

class MainActivity : AppCompatActivity() {

    private lateinit var terraApp: TerraApp
    var skus = listOf<String>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        terraApp = TerraApp.initializeApp(this@MainActivity.application, APP_NAME)
        initApolloInstance(terraApp.getConfig("apollo").config, APP_NAME)
        CartBus.getInstance(this, terraApp)
        TerraDiscovery.getInstance(terraApp = terraApp)
        DiscoveryManager.getInstance(terraApp)
        DiscoveryRequestBuilder.setTerminalCode("vnshop")
        val btnGoCart = findViewById<AppCompatButton>(R.id.btnGoCart)
        val listView = findViewById<ListView>(R.id.products)

        btnGoCart.setOnClickListener {
            startActivity(
                CartActivity.createDefaultIntent(this)
            )
        }

        lifecycleScope.launchWhenStarted {
            skus = getProducts().map { it.productInfo.sku }
            val adapter = ArrayAdapter<String>(this@MainActivity, android.R.layout.simple_list_item_1, skus)
            listView.adapter = adapter
        }

        listView.onItemClickListener = AdapterView.OnItemClickListener { parent, view, position, id ->
            lifecycleScope.launchWhenStarted {
                val result = terraApp.getTerraBus()
                    .request(
                        "CART_ADD_PRODUCT",
                        AddProductRequest(skus[position]),
                        CartItemEntity::class.java
                    )
                Toast.makeText(this@MainActivity, "Add product ${result.isSuccess()}", Toast.LENGTH_LONG).show()
            }
        }
    }

    companion object {
        const val APP_NAME = "SPOS_v2"
    }

    private suspend fun getProducts(): List<DiscoveryProduct> {
        return try {
            val result = terraApp.getTerraBus().request(
                "DISCOVERY_SEARCH_PRODUCT",
                SearchDiscoveryProductRequest(""),
                SearchDiscoveryProductResponse::class.java
            )
            result.getOrNull()?.result?.products.orEmpty()
        } catch (e: Throwable) {
            emptyList()
        }
    }

    fun initApolloInstance(config: String, appName: String): ApolloTheme {
        val apolloConfig = config.toApolloConfiguration()

        return ApolloTheme.createInstance(
            appName,
            apolloConfig.data.apolloColorTheme
        )
    }
}
