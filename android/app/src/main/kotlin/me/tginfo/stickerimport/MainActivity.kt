package me.tginfo.stickerimport

import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.net.Uri
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.content.FileProvider.getUriForFile
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.util.*

class MainActivity : FlutterActivity() {
    private val CHANNEL = "me.tginfo.stickerexport/DrKLOIntent"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // This method is invoked on the main thread.
            call, result ->
            if (call.method == "sendDrKLOIntent") {
                val paths: ArrayList<String>? = call.argument("paths")
                val emoji: ArrayList<String>? = call.argument("emoji")
                val isAnimated: Boolean? = call.argument("isAnimated")
                val packageName: String? = call.argument("package")
                val res = sendDrKLOIntent(paths, emoji, isAnimated, packageName)

                result.success(1)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun sendDrKLOIntent(paths: ArrayList<String>?, emoji: ArrayList<String>?, isAnimated: Boolean?, packageName: String?) {
        val intent = Intent("org.telegram.messenger.CREATE_STICKER_PACK")
        if (isAnimated == true) {
            intent.type = "image/*"
        } else {
            intent.type = "application/x-tgsticker"
         }


        val resInfoList: List<ResolveInfo> = context.packageManager.queryIntentActivities(intent, PackageManager.MATCH_DEFAULT_ONLY)
        Log.i("PACKAGES LIST", resInfoList.toString())

        val files = ArrayList<Uri>()
        for (i in paths!!.indices) {
            val f = getUriForFile(context, "me.tginfo.fileprovider", File(paths[i]))
            Log.i("FILE EXISTS", File(paths[i]).exists().toString())

            for (resolveInfo in resInfoList) {
                val packageName: String = resolveInfo.activityInfo.packageName
                context.grantUriPermission(packageName, f, Intent.FLAG_GRANT_READ_URI_PERMISSION)
            }

            files.add(f)
        }


        Log.i("STICKER URIS", files.toString())

        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        intent.putExtra(Intent.EXTRA_STREAM, files)
        intent.putExtra("STICKER_EMOJIS", emoji)
        intent.putExtra("IMPORTER", packageName)

        startActivity(intent)
    }
}