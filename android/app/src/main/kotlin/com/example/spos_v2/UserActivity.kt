package com.example.spos_v2

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.AppCompatButton
import androidx.lifecycle.lifecycleScope
import com.example.spos_v2.MainActivity.Companion.APP_NAME
import com.example.spos_v2.models.CustomerProfile
import vn.teko.terra.core.android.terra.TerraApp
import kotlin.random.Random

class UserActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_user)
        val terraApp = TerraApp.getInstance(APP_NAME)
        val button = findViewById<AppCompatButton>(R.id.btnUpdate)
        button.setOnClickListener {
            lifecycleScope.launchWhenStarted {
                val r = Random.nextInt(100);
                val result = terraApp.getTerraBus().request(
                    "USER_PROFILE_SET_SELECT_CUSTOMER",
                    CustomerProfile("1", "1", "Hieu $r", "0943310394", "Address $r"),
                    CustomerProfile::class.java
                )
                if (result.isSuccess()) {
                    finish()
                }
            }
        }
    }
}