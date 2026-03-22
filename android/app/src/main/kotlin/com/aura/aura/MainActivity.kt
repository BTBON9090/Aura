package com.aura.aura

import android.content.Intent
import android.net.Uri
import android.os.Build
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.aura.aura/file_utils"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "openFileLocation" -> {
                    val filePath = call.argument<String>("path")
                    if (filePath != null) {
                        val success = openFileLocation(filePath)
                        result.success(success)
                    } else {
                        result.error("INVALID_ARGUMENT", "Path is required", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun openFileLocation(filePath: String): Boolean {
        return try {
            val file = File(filePath)
            if (!file.exists()) {
                return false
            }

            val intent = Intent(Intent.ACTION_VIEW)
            
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                val uri = FileProvider.getUriForFile(
                    this,
                    "${applicationContext.packageName}.fileprovider",
                    file
                )
                intent.setDataAndType(uri, "image/*")
                intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            } else {
                intent.setDataAndType(Uri.fromFile(file), "image/*")
            }
            
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }
}
