package com.ufm.tracker.ufm

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.net.Uri
import android.util.Base64
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

class UpiIntegration(
    private val context: Context,
    private val activityProvider: () -> Activity?
) : MethodChannel.MethodCallHandler {

    companion object {
        const val CHANNEL = "com.ufm.tracker.ufm/upi"

        val WHITELISTED_PACKAGES = setOf(
            "com.google.android.apps.nbu.paisa.user",
            "com.phonepe.app",
            "net.one97.paytm",
            "in.org.npci.upiapp",
            "in.amazon.mShop.android.shopping",
            "com.dreamplug.androidapp",
            "com.naviapp",
            "in.supermoney",
            "money.super.payments",
            "com.ufm.fakeupi"
        )

        fun registerWith(
            messenger: BinaryMessenger,
            context: Context,
            activityProvider: () -> Activity?
        ) {
            val channel = MethodChannel(messenger, CHANNEL)
            val instance = UpiIntegration(context, activityProvider)
            channel.setMethodCallHandler(instance)
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getCompatibleApps" -> handleGetCompatibleApps(result)
            "launchPayment" -> {
                val packageName = call.argument<String>("packageName")
                val paymentUri = call.argument<String>("paymentUri")
                if (packageName.isNullOrBlank() || paymentUri.isNullOrBlank()) {
                    result.error(
                        "INVALID_ARGUMENTS",
                        "packageName and paymentUri must not be blank",
                        null
                    )
                    return
                }
                handleLaunchPayment(packageName, paymentUri, result)
            }
            else -> result.notImplemented()
        }
    }

    private fun handleGetCompatibleApps(result: MethodChannel.Result) {
        try {
            val pm = context.packageManager
            val upiIntent = Intent(Intent.ACTION_VIEW, Uri.parse("upi://pay"))
            val resolveInfos = pm.queryIntentActivities(upiIntent, PackageManager.MATCH_DEFAULT_ONLY)

            val appsList = mutableListOf<Map<String, Any?>>()
            val seenPackages = mutableSetOf<String>()

            for (info in resolveInfos) {
                val pkg = info.activityInfo.packageName
                if (WHITELISTED_PACKAGES.contains(pkg) && !seenPackages.contains(pkg)) {
                    seenPackages.add(pkg)
                    val appName = info.loadLabel(pm).toString()
                    val iconBase64 = try {
                        encodeDrawableToBase64(info.loadIcon(pm))
                    } catch (_: Exception) {
                        null
                    }
                    appsList.add(
                        mapOf(
                            "packageName" to pkg,
                            "appName" to appName,
                            "iconBase64" to iconBase64,
                            "isTestApp" to (pkg == "com.ufm.fakeupi")
                        )
                    )
                }
            }

            // Direct fallback verification for whitelisted packages
            for (pkg in WHITELISTED_PACKAGES) {
                if (!seenPackages.contains(pkg)) {
                    try {
                        val appInfo = pm.getApplicationInfo(pkg, 0)
                        seenPackages.add(pkg)
                        val appName = pm.getApplicationLabel(appInfo).toString()
                        val iconBase64 = try {
                            encodeDrawableToBase64(pm.getApplicationIcon(appInfo))
                        } catch (_: Exception) {
                            null
                        }
                        appsList.add(
                            mapOf(
                                "packageName" to pkg,
                                "appName" to appName,
                                "iconBase64" to iconBase64,
                                "isTestApp" to (pkg == "com.ufm.fakeupi")
                            )
                        )
                    } catch (_: PackageManager.NameNotFoundException) {
                        // Package not installed, skip
                    }
                }
            }

            result.success(appsList)
        } catch (e: Exception) {
            result.error("DISCOVERY_FAILED", e.localizedMessage, null)
        }
    }

    private fun handleLaunchPayment(
        packageName: String,
        paymentUri: String,
        result: MethodChannel.Result
    ) {
        val activity = activityProvider()
        if (activity == null) {
            result.success(
                mapOf(
                    "status" to "failed",
                    "errorMessage" to "Activity unavailable to launch payment intent"
                )
            )
            return
        }

        try {
            val uri = Uri.parse(paymentUri)
            val intent = Intent(Intent.ACTION_VIEW, uri).apply {
                `package` = packageName
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            if (intent.resolveActivity(context.packageManager) == null) {
                result.success(
                    mapOf(
                        "status" to "appNotFound",
                        "errorMessage" to "App not found or cannot resolve UPI intent: $packageName"
                    )
                )
                return
            }
            activity.startActivity(intent)
            result.success(mapOf("status" to "launched"))
        } catch (e: ActivityNotFoundException) {
            result.success(
                mapOf(
                    "status" to "appNotFound",
                    "errorMessage" to e.localizedMessage
                )
            )
        } catch (e: SecurityException) {
            result.success(
                mapOf(
                    "status" to "failed",
                    "errorMessage" to "Security exception: ${e.localizedMessage}"
                )
            )
        } catch (e: Exception) {
            result.success(
                mapOf(
                    "status" to "failed",
                    "errorMessage" to (e.localizedMessage ?: "Unknown launch failure")
                )
            )
        }
    }

    private fun encodeDrawableToBase64(drawable: Drawable): String? {
        val bitmap = if (drawable is BitmapDrawable && drawable.bitmap != null) {
            drawable.bitmap
        } else {
            val width = if (drawable.intrinsicWidth > 0) drawable.intrinsicWidth else 96
            val height = if (drawable.intrinsicHeight > 0) drawable.intrinsicHeight else 96
            val bmp = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
            val canvas = Canvas(bmp)
            drawable.setBounds(0, 0, canvas.width, canvas.height)
            drawable.draw(canvas)
            bmp
        }
        val stream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 90, stream)
        val bytes = stream.toByteArray()
        return Base64.encodeToString(bytes, Base64.NO_WRAP)
    }
}
