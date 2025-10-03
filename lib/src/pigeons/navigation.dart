part of mapbox_maps_flutter;

class NavigationInterface {
  /// Constructor for [NavigationInterface].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  NavigationInterface({BinaryMessenger? binaryMessenger, String messageChannelSuffix = ''})
      : pigeonVar_binaryMessenger = binaryMessenger,
        pigeonVar_messageChannelSuffix = messageChannelSuffix.isNotEmpty ? '.$messageChannelSuffix' : '';
  final BinaryMessenger? pigeonVar_binaryMessenger;

  static const MessageCodec<Object?> pigeonChannelCodec = _NavigationCodec();

  final String pigeonVar_messageChannelSuffix;

  Future<bool> setRoute(RouteOptions options) async {
    final String pigeonVar_channelName = 'dev.flutter.pigeon.mapbox_maps_flutter.NavigationInterface.setRoute$pigeonVar_messageChannelSuffix';

    final BasicMessageChannel<Object?> pigeonVar_channel = BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );

    final Future<Object?> pigeonVar_sendFuture = pigeonVar_channel.send(<Object?>[options]);

    final List<Object?>? pigeonVar_replyList = await pigeonVar_sendFuture as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else {
      return true;
    }
  }
}

class _NavigationCodec extends StandardMessageCodec {
  const _NavigationCodec();

  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is RouteOptions) {
      buffer.putUint8(200);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 200:
        return RouteOptions.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

/// Defines route request parameters for the Mapbox Directions API.
///
/// This class is used to configure a route request and includes methods
/// for serialization and deserialization, allowing it to be passed
/// between different parts of an application, such as platform channels.
class RouteOptions {
  RouteOptions({
    this.baseUrl,
    this.user,
    this.profile = 'mapbox/driving-traffic',
    this.coordinates,
    this.alternatives,
    this.language,
    this.radiuses,
    this.bearings,
    this.avoidManeuverRadius,
    this.layers,
    this.continueStraight,
    this.roundaboutExits,
    this.geometries,
    this.overview,
    this.steps,
    this.annotations,
    this.exclude,
    this.include,
    this.voiceInstructions,
    this.bannerInstructions,
    this.voiceUnits,
    this.approaches,
    this.waypointIndices,
    this.waypointNames,
    this.waypointTargets,
    this.waypointsPerRoute,
    this.alleyBias,
    this.walkingSpeed,
    this.walkwayBias,
    this.snappingIncludeClosures,
    this.snappingIncludeStaticClosures,
    this.arriveBy,
    this.departAt,
    this.maxHeight,
    this.maxWidth,
    this.maxWeight,
    this.enableRefresh,
    this.computeTollCost,
    this.metadata,
    this.paymentMethods,
    this.suppressVoiceInstructionLocalNames,
    this.intersectionLinkFormOfWay,
    this.intersectionLinkGeometry,
    this.intersectionLinkAccess,
    this.intersectionLinkElevated,
    this.intersectionLinkBridge,
    this.notifications,
  });

  /// Base URL for the request.
  String? baseUrl;

  /// The user parameter of the request, e.g., "mapbox".
  String? user;

  /// The routing profile to use, e.g., "mapbox/driving-traffic".
  String? profile;

  /// A semicolon-separated list of {longitude},{latitude} coordinate pairs.
  String? coordinates;

  /// Whether to try to return alternative routes.
  bool? alternatives;

  /// The language of returned turn-by-turn text instructions.
  String? language;

  /// A semicolon-separated list of radii in meters for snapping coordinates.
  String? radiuses;

  /// A semicolon-separated list of bearings.
  String? bearings;

  /// Radius in meters to avoid significant maneuvers from the starting point.
  double? avoidManeuverRadius;

  /// A semicolon-separated list of road layers for each coordinate.
  String? layers;

  /// If true, the route will continue in the same direction of travel.
  bool? continueStraight;

  /// Whether to emit instructions at roundabout exits.
  bool? roundaboutExits;

  /// The format of the returned geometry, e.g., "polyline6".
  String? geometries;

  /// The requested type of overview geometry, e.g., "full".
  String? overview;

  /// Whether to return steps and turn-by-turn instructions.
  bool? steps;

  /// A comma-separated list of annotations to return, e.g., "duration".
  String? annotations;

  /// A comma-separated list of road types or points to exclude.
  String? exclude;

  /// A comma-separated list of road types to include.
  String? include;

  /// Whether to return SSML marked-up text for voice guidance.
  bool? voiceInstructions;

  /// Whether to return banner objects associated with route steps.
  bool? bannerInstructions;

  /// Units for voice instructions ("imperial" or "metric").
  String? voiceUnits;

  /// A semicolon-separated list indicating the side of the road for approaching a waypoint.
  String? approaches;

  /// A semicolon-separated list of coordinate indices to be treated as waypoints.
  String? waypointIndices;

  /// A semicolon-separated list of custom names for waypoints.
  String? waypointNames;

  /// A semicolon-separated list of coordinate pairs for drop-off locations.
  String? waypointTargets;

  /// If true, waypoints are returned within each route object.
  bool? waypointsPerRoute;

  /// A bias towards or against using alleys. Range: -1.0 to 1.0.
  double? alleyBias;

  /// The walking speed in meters per second.
  double? walkingSpeed;

  /// A bias towards or against using walkways. Range: -1.0 to 1.0.
  double? walkwayBias;

  /// A list of booleans affecting snapping to live-traffic closures.
  String? snappingIncludeClosures;

  /// A list of booleans affecting snapping to long-term static closures.
  String? snappingIncludeStaticClosures;

  /// The desired arrival time (ISO-8601 format).
  String? arriveBy;

  /// The desired departure time (ISO-8601 format).
  String? departAt;

  /// The maximum vehicle height in meters.
  double? maxHeight;

  /// The maximum vehicle width in meters.
  double? maxWidth;

  /// The maximum vehicle weight in metric tons.
  double? maxWeight;

  /// Whether the routes should be refreshable.
  bool? enableRefresh;

  /// Whether to return calculated toll costs.
  bool? computeTollCost;

  /// Whether the response should contain versioning metadata.
  bool? metadata;

  /// A comma-separated list of payment methods to filter by.
  String? paymentMethods;

  /// If true, voice instructions will omit local names when the language doesn't match the region.
  bool? suppressVoiceInstructionLocalNames;

  /// Whether to return "form of way" values for roads at intersections.
  bool? intersectionLinkFormOfWay;

  /// Road classes for which to include intersection geometry.
  String? intersectionLinkGeometry;

  /// Whether to return "access" values for roads at intersections.
  bool? intersectionLinkAccess;

  /// Whether to return "elevated" status for roads at intersections.
  bool? intersectionLinkElevated;

  /// Whether to return "bridge" status for roads at intersections.
  bool? intersectionLinkBridge;

  /// Which notifications the response should contain.
  String? notifications;

  List<Object?> _toList() {
    return <Object?>[
      baseUrl,
      user,
      profile,
      coordinates,
      alternatives,
      language,
      radiuses,
      bearings,
      avoidManeuverRadius,
      layers,
      continueStraight,
      roundaboutExits,
      geometries,
      overview,
      steps,
      annotations,
      exclude,
      include,
      voiceInstructions,
      bannerInstructions,
      voiceUnits,
      approaches,
      waypointIndices,
      waypointNames,
      waypointTargets,
      waypointsPerRoute,
      alleyBias,
      walkingSpeed,
      walkwayBias,
      snappingIncludeClosures,
      snappingIncludeStaticClosures,
      arriveBy,
      departAt,
      maxHeight,
      maxWidth,
      maxWeight,
      enableRefresh,
      computeTollCost,
      metadata,
      paymentMethods,
      suppressVoiceInstructionLocalNames,
      intersectionLinkFormOfWay,
      intersectionLinkGeometry,
      intersectionLinkAccess,
      intersectionLinkElevated,
      intersectionLinkBridge,
      notifications,
    ];
  }

  Object encode() {
    return _toList();
  }

  static RouteOptions decode(Object result) {
    result as List<Object?>;
    return RouteOptions(
      baseUrl: result[0] as String?,
      user: result[1] as String?,
      profile: result[2] as String?,
      coordinates: result[3] as String?,
      alternatives: result[4] as bool?,
      language: result[5] as String?,
      radiuses: result[6] as String?,
      bearings: result[7] as String?,
      avoidManeuverRadius: result[8] as double?,
      layers: result[9] as String?,
      continueStraight: result[10] as bool?,
      roundaboutExits: result[11] as bool?,
      geometries: result[12] as String?,
      overview: result[13] as String?,
      steps: result[14] as bool?,
      annotations: result[15] as String?,
      exclude: result[16] as String?,
      include: result[17] as String?,
      voiceInstructions: result[18] as bool?,
      bannerInstructions: result[19] as bool?,
      voiceUnits: result[20] as String?,
      approaches: result[21] as String?,
      waypointIndices: result[22] as String?,
      waypointNames: result[23] as String?,
      waypointTargets: result[24] as String?,
      waypointsPerRoute: result[25] as bool?,
      alleyBias: result[26] as double?,
      walkingSpeed: result[27] as double?,
      walkwayBias: result[28] as double?,
      snappingIncludeClosures: result[29] as String?,
      snappingIncludeStaticClosures: result[30] as String?,
      arriveBy: result[31] as String?,
      departAt: result[32] as String?,
      maxHeight: result[33] as double?,
      maxWidth: result[34] as double?,
      maxWeight: result[35] as double?,
      enableRefresh: result[36] as bool?,
      computeTollCost: result[37] as bool?,
      metadata: result[38] as bool?,
      paymentMethods: result[39] as String?,
      suppressVoiceInstructionLocalNames: result[40] as bool?,
      intersectionLinkFormOfWay: result[41] as bool?,
      intersectionLinkGeometry: result[42] as String?,
      intersectionLinkAccess: result[43] as bool?,
      intersectionLinkElevated: result[44] as bool?,
      intersectionLinkBridge: result[45] as bool?,
      notifications: result[46] as String?,
    );
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (other is! RouteOptions || other.runtimeType != runtimeType) {
      return false;
    }
    if (identical(this, other)) {
      return true;
    }
    return baseUrl == other.baseUrl &&
        user == other.user &&
        profile == other.profile &&
        coordinates == other.coordinates &&
        alternatives == other.alternatives &&
        language == other.language &&
        radiuses == other.radiuses &&
        bearings == other.bearings &&
        avoidManeuverRadius == other.avoidManeuverRadius &&
        layers == other.layers &&
        continueStraight == other.continueStraight &&
        roundaboutExits == other.roundaboutExits &&
        geometries == other.geometries &&
        overview == other.overview &&
        steps == other.steps &&
        annotations == other.annotations &&
        exclude == other.exclude &&
        include == other.include &&
        voiceInstructions == other.voiceInstructions &&
        bannerInstructions == other.bannerInstructions &&
        voiceUnits == other.voiceUnits &&
        approaches == other.approaches &&
        waypointIndices == other.waypointIndices &&
        waypointNames == other.waypointNames &&
        waypointTargets == other.waypointTargets &&
        waypointsPerRoute == other.waypointsPerRoute &&
        alleyBias == other.alleyBias &&
        walkingSpeed == other.walkingSpeed &&
        walkwayBias == other.walkwayBias &&
        snappingIncludeClosures == other.snappingIncludeClosures &&
        snappingIncludeStaticClosures == other.snappingIncludeStaticClosures &&
        arriveBy == other.arriveBy &&
        departAt == other.departAt &&
        maxHeight == other.maxHeight &&
        maxWidth == other.maxWidth &&
        maxWeight == other.maxWeight &&
        enableRefresh == other.enableRefresh &&
        computeTollCost == other.computeTollCost &&
        metadata == other.metadata &&
        paymentMethods == other.paymentMethods &&
        suppressVoiceInstructionLocalNames == other.suppressVoiceInstructionLocalNames &&
        intersectionLinkFormOfWay == other.intersectionLinkFormOfWay &&
        intersectionLinkGeometry == other.intersectionLinkGeometry &&
        intersectionLinkAccess == other.intersectionLinkAccess &&
        intersectionLinkElevated == other.intersectionLinkElevated &&
        intersectionLinkBridge == other.intersectionLinkBridge &&
        notifications == other.notifications;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => Object.hashAll(_toList());
}
