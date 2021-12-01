package com.example.spos_v2.cart

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

object NativeMethodChannel {
    const val CHANNEL_FLUTTER = "channel.flutter"
    private lateinit var methodChannel: MethodChannel

    fun configureChannel(flutterEngine: FlutterEngine) {
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_FLUTTER)
    }

    fun refreshCart() {
        methodChannel.invokeMethod("refreshCart", null)
    }
}