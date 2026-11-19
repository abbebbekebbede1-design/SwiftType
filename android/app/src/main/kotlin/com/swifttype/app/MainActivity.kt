package com.swifttype.app

import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
  private val channelName = "com.swifttype/ime"
  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
      when (call.method) {
        "setAmharicLayout" -> {
          val layout = call.argument<String>("layout") ?: "Layout 2"
          getSharedPreferences("swifttype_ime", MODE_PRIVATE).edit().putString("amharic_layout", layout).apply()
          result.success(true)
        }
        "openImeSettings" -> {
          startActivity(Intent(Settings.ACTION_INPUT_METHOD_SETTINGS))
          result.success(true)
        }
        else -> result.notImplemented()
      }
    }
  }
}
