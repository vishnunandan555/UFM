package com.ufm.tracker.ufm

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        UpiIntegration.registerWith(
            flutterEngine.dartExecutor.binaryMessenger,
            applicationContext
        ) { this }
    }
}
