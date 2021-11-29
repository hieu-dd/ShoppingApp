package com.example.spos_v2

import android.os.Bundle
import android.os.PersistableBundle
import androidx.appcompat.app.AppCompatActivity
import kotlinx.coroutines.*
import vn.teko.discovery.core.TerraDiscovery
import vn.teko.discovery.core.model.api.request.DiscoveryRequestBuilder
import vn.teko.discovery.event.manager.DiscoveryManager
import vn.teko.terra.core.android.terra.TerraApp
import com.example.spos_v2.cart.CartActivity

class MainActivity : AppCompatActivity() {

    private lateinit var terraApp: TerraApp

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        terraApp = TerraApp.initializeApp(this@MainActivity.application, APP_NAME)
        TerraDiscovery.getInstance(terraApp = terraApp)
        DiscoveryManager.getInstance(terraApp)
        DiscoveryRequestBuilder.setTerminalCode("CP01")
        startActivity(
            CartActivity.createDefaultIntent(this)
        );
    }

    companion object {
        const val APP_NAME = "SPOS_v2"
    }
}
