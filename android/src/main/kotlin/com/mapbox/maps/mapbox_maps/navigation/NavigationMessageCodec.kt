package com.mapbox.maps.mapbox_maps.navigation

import com.mapbox.api.directions.v5.models.RouteOptions
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

/**
 * Creates a RouteOptions instance from a list of properties.
 *
 * This function is designed to decode a list serialized from a corresponding
 * Dart class, ensuring the order and types of elements are perfectly matched.
 *
 * @param list The list of properties, typically from a Flutter platform channel.
 * @return A new instance of RouteOptions.
 */
fun fromListToRouteOptions(list: List<Any?>): RouteOptions {
  val builder = RouteOptions.builder()

  // IMPORTANT: The index of each item MUST match the order in the Dart `encode` method.
  (list[0] as? String)?.let { builder.baseUrl(it) }
  (list[1] as? String)?.let { builder.user(it) }
  (list[2] as? String)?.let { builder.profile(it) }
  (list[3] as? String)?.let { builder.coordinates(it) }
  (list[4] as? Boolean)?.let { builder.alternatives(it) }
  (list[5] as? String)?.let { builder.language(it) }
  (list[6] as? String)?.let { builder.radiuses(it) }
  (list[7] as? String)?.let { builder.bearings(it) }
  (list[8] as? Double)?.let { builder.avoidManeuverRadius(it) }
  (list[9] as? String)?.let { builder.layers(it) }
  (list[10] as? Boolean)?.let { builder.continueStraight(it) }
  (list[11] as? Boolean)?.let { builder.roundaboutExits(it) }
  (list[12] as? String)?.let { builder.geometries(it) }
  (list[13] as? String)?.let { builder.overview(it) }
  (list[14] as? Boolean)?.let { builder.steps(it) }
  (list[15] as? String)?.let { builder.annotations(it) }
  (list[16] as? String)?.let { builder.exclude(it) }
  (list[17] as? String)?.let { builder.include(it) }
  (list[18] as? Boolean)?.let { builder.voiceInstructions(it) }
  (list[19] as? Boolean)?.let { builder.bannerInstructions(it) }
  (list[20] as? String)?.let { builder.voiceUnits(it) }
  (list[21] as? String)?.let { builder.approaches(it) }
  (list[22] as? String)?.let { builder.waypointIndices(it) }
  (list[23] as? String)?.let { builder.waypointNames(it) }
  (list[24] as? String)?.let { builder.waypointTargets(it) }
  (list[25] as? Boolean)?.let { builder.waypointsPerRoute(it) }
  (list[26] as? Double)?.let { builder.alleyBias(it) }
  (list[27] as? Double)?.let { builder.walkingSpeed(it) }
  (list[28] as? Double)?.let { builder.walkwayBias(it) }
  (list[29] as? String)?.let { builder.snappingIncludeClosures(it) }
  (list[30] as? String)?.let { builder.snappingIncludeStaticClosures(it) }
  (list[31] as? String)?.let { builder.arriveBy(it) }
  (list[32] as? String)?.let { builder.departAt(it) }
  (list[33] as? Double)?.let { builder.maxHeight(it) }
  (list[34] as? Double)?.let { builder.maxWidth(it) }
  (list[35] as? Double)?.let { builder.maxWeight(it) }
  (list[36] as? Boolean)?.let { builder.enableRefresh(it) }
  (list[37] as? Boolean)?.let { builder.computeTollCost(it) }
  (list[38] as? Boolean)?.let { builder.metadata(it) }
  (list[39] as? String)?.let { builder.paymentMethods(it) }
  (list[40] as? Boolean)?.let { builder.suppressVoiceInstructionLocalNames(it) }
  (list[41] as? Boolean)?.let { builder.intersectionLinkFormOfWay(it) }
  (list[42] as? String)?.let { builder.intersectionLinkGeometry(it) }
  (list[43] as? Boolean)?.let { builder.intersectionLinkAccess(it) }
  (list[44] as? Boolean)?.let { builder.intersectionLinkElevated(it) }
  (list[45] as? Boolean)?.let { builder.intersectionLinkBridge(it) }
  (list[46] as? String)?.let { builder.notifications(it) }

  return builder.build()
}

/**
 * Serializes a RouteOptions instance into a list of its properties.
 *
 * This function is designed to encode an object for use with a corresponding
 * Dart decoder, ensuring the order and types of elements are perfectly matched.
 *
 * @return A list of properties that can be serialized.
 */
fun RouteOptions.toList(): List<Any?> {
  // IMPORTANT: The order of properties here MUST match the order
  // in the fromListToRouteOptions function and the Dart decode method.
  return listOf(
    baseUrl(),
    user(),
    profile(),
    coordinates(),
    alternatives(),
    language(),
    radiuses(),
    bearings(),
    avoidManeuverRadius(),
    layers(),
    continueStraight(),
    roundaboutExits(),
    geometries(),
    overview(),
    steps(),
    annotations(),
    exclude(),
    include(),
    voiceInstructions(),
    bannerInstructions(),
    voiceUnits(),
    approaches(),
    waypointIndices(),
    waypointNames(),
    waypointTargets(),
    waypointsPerRoute(),
    alleyBias(),
    walkingSpeed(),
    walkwayBias(),
    snappingIncludeClosures(),
    snappingIncludeStaticClosures(),
    arriveBy(),
    departAt(),
    maxHeight(),
    maxWidth(),
    maxWeight(),
    enableRefresh(),
    computeTollCost(),
    metadata(),
    paymentMethods(),
    suppressVoiceInstructionLocalNames(),
    intersectionLinkFormOfWay(),
    intersectionLinkGeometry(),
    intersectionLinkAccess(),
    intersectionLinkElevated(),
    intersectionLinkBridge(),
    notifications()
  )
}

open class NavigationMessageCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
//      151.toByte() -> {
//        return (readValue(buffer) as? List<Any?>)?.let {
//          PointDecoder.fromList(it)
//        }
//      }
//
//      152.toByte() -> {
//        return (readValue(buffer) as? List<Any?>)?.let {
//          FeatureDecoder.fromList(it)
//        }
//      }
//
//      191.toByte() -> {
//        return (readValue(buffer) as? List<Any?>)?.let {
//          NavigationLocation.fromList(it)
//        }
//      }
//
//      192.toByte() -> {
//        return (readValue(buffer) as Long?)?.let {
//          RouteProgressState.ofRaw(it.toInt())
//        }
//      }
//
//      193.toByte() -> {
//        return (readValue(buffer) as Long?)?.let {
//          RoadObjectLocationType.ofRaw(it.toInt())
//        }
//      }
//
//      194.toByte() -> {
//        return (readValue(buffer) as? List<Any?>)?.let {
//          RoadObject.fromList(it)
//        }
//      }
//
//      195.toByte() -> {
//        return (readValue(buffer) as? List<Any?>)?.let {
//          RoadObjectDistanceInfo.fromList(it)
//        }
//      }
//
//      196.toByte() -> {
//        return (readValue(buffer) as? List<Any?>)?.let {
//          UpcomingRoadObject.fromList(it)
//        }
//      }
//
//      197.toByte() -> {
//        return (readValue(buffer) as? List<Any?>)?.let {
//          RouteProgress.fromList(it)
//        }
//      }
//
//      198.toByte() -> {
//        return (readValue(buffer) as Long?)?.let {
//          NavigationCameraState.ofRaw(it.toInt())
//        }
//      }
//
//      199.toByte() -> {
//        return (readValue(buffer) as? List<Any?>)?.let {
//          Waypoint.fromList(it)
//        }
//      }

      200.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          fromListToRouteOptions(it)
        }
      }

      else -> super.readValueOfType(type, buffer)
    }
  }

  override fun writeValue(stream: ByteArrayOutputStream, value: Any?) {
    when (value) {
//      is Point -> {
//        stream.write(151)
//        writeValue(stream, value.toList())
//      }
//
//      is Feature -> {
//        stream.write(152)
//        writeValue(stream, value.toList())
//      }
//
//      is NavigationLocation -> {
//        stream.write(191)
//        writeValue(stream, value.toList())
//      }
//
//      is RouteProgressState -> {
//        stream.write(192)
//        writeValue(stream, value.raw)
//      }
//
//      is RoadObjectLocationType -> {
//        stream.write(193)
//        writeValue(stream, value.raw)
//      }
//
//      is RoadObject -> {
//        stream.write(194)
//        writeValue(stream, value.toList())
//      }
//
//      is RoadObjectDistanceInfo -> {
//        stream.write(195)
//        writeValue(stream, value.toList())
//      }
//
//      is UpcomingRoadObject -> {
//        stream.write(196)
//        writeValue(stream, value.toList())
//      }
//
//      is RouteProgress -> {
//        stream.write(197)
//        writeValue(stream, value.toList())
//      }
//
//      is NavigationCameraState -> {
//        stream.write(198)
//        writeValue(stream, value.raw)
//      }
//
//      is Waypoint -> {
//        stream.write(199)
//        writeValue(stream, value.toList())
//      }

      is RouteOptions -> {
        stream.write(200)
        writeValue(stream, value.toList())
      }

      else -> super.writeValue(stream, value)
    }
  }
}