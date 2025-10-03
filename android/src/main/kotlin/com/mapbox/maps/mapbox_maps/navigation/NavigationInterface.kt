package com.mapbox.maps.mapbox_maps.navigation

import com.mapbox.api.directions.v5.models.RouteOptions
import com.mapbox.maps.mapbox_maps.pigeons.FlutterError
import io.flutter.Log
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MessageCodec

private fun wrapResult(result: Any?): List<Any?> {
  return listOf(result)
}

private fun wrapError(exception: Throwable): List<Any?> {
  return if (exception is FlutterError) {
    listOf(
      exception.code,
      exception.message,
      exception.details
    )
  } else {
    listOf(
      exception.javaClass.simpleName,
      exception.toString(),
      "Cause: " + exception.cause + ", Stacktrace: " + Log.getStackTraceString(exception)
    )
  }
}

interface NavigationInterface {
  fun setRoute(options: RouteOptions, callback: (Result<Unit>) -> Unit)

  companion object {
    /** The codec used by NavigationInterface. */
    val codec: MessageCodec<Any?> by lazy {
      NavigationMessageCodec()
    }

    /** Sets up an instance of `NavigationInterface` to handle messages through the `binaryMessenger`. */
    @JvmOverloads
    fun setUp(
      binaryMessenger: BinaryMessenger,
      api: NavigationInterface?,
      messageChannelSuffix: String = ""
    ) {
      val separatedMessageChannelSuffix =
        if (messageChannelSuffix.isNotEmpty()) ".$messageChannelSuffix" else ""
      run {
        val channel = BasicMessageChannel<Any?>(
          binaryMessenger,
          "dev.flutter.pigeon.mapbox_maps_flutter.NavigationInterface.setRoute$separatedMessageChannelSuffix",
          codec
        )
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val routeOptionsArg = args[0] as RouteOptions

            api.setRoute(routeOptionsArg) { result: Result<Unit> ->
              val error = result.exceptionOrNull()

              Log.i("NavigationInterface", "setRoute: $result")

              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                reply.reply(wrapResult(true))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
    }
  }
}