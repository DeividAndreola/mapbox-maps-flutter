import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/pigeons/navigation_interface.g.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/src/main/kotlin/com/mapbox/maps/mapbox_maps/pigeons/NavigationInterfaces.kt',
    kotlinOptions: KotlinOptions(
      package: 'com.mapbox.maps.mapbox_maps.pigeons',
    ),
  ),
)

// ============================================================================
// ENUMS
// ============================================================================

enum NavigationState {
  idle,
  freeDrive,
  activeGuidance,
  arrived,
  stopped,
}

enum CameraMode {
  idle,
  overview,
  following,
}

enum VoiceUnits {
  imperial,
  metric,
}

enum ManeuverType {
  turn,
  newName,
  depart,
  arrive,
  merge,
  onRamp,
  offRamp,
  fork,
  endOfRoad,
  continue_,
  roundabout,
  rotary,
  roundaboutTurn,
  notification,
  exitRoundabout,
  exitRotary,
}

enum ManeuverModifier {
  uturn,
  sharpRight,
  right,
  slightRight,
  straight,
  slightLeft,
  left,
  sharpLeft,
}

enum RerouteState {
  idle,
  fetching,
  interrupted,
}

// ============================================================================
// DATA CLASSES - ROUTE OPTIONS
// ============================================================================

/// Comprehensive route request options
class RouteOptions {
  RouteOptions({
    required this.coordinates,
    this.profile,
    this.alternatives,
    this.language,
    this.voiceInstructions,
    this.bannerInstructions,
    this.voiceUnits,
    this.steps,
    this.continueStraight,
    this.waypointNames,
    this.waypointIndices,
    this.exclude,
    this.include,
    this.enableRefresh,
    this.walkingSpeed,
    this.maxHeight,
    this.maxWidth,
    this.maxWeight,
  });

  /// List of coordinates as "lon,lat;lon,lat" string
  final String coordinates;

  /// Routing profile: driving-traffic, driving, walking, cycling
  final String? profile;

  /// Whether to return alternative routes
  final bool? alternatives;

  /// Language for instructions (e.g., "en", "es", "pt")
  final String? language;

  /// Include voice instructions
  final bool? voiceInstructions;

  /// Include banner instructions
  final bool? bannerInstructions;

  /// Units for voice instructions
  final VoiceUnits? voiceUnits;

  /// Include step-by-step instructions
  final bool? steps;

  /// Continue in same direction of travel
  final bool? continueStraight;

  /// Semicolon-separated list of waypoint names
  final String? waypointNames;

  /// Semicolon-separated indices for waypoints (vs pass-through)
  final String? waypointIndices;

  /// Exclude road types (e.g., "toll,ferry")
  final String? exclude;

  /// Include road types
  final String? include;

  /// Enable route refresh for live traffic
  final bool? enableRefresh;

  /// Walking speed in m/s
  final double? walkingSpeed;

  /// Max vehicle height in meters
  final double? maxHeight;

  /// Max vehicle width in meters
  final double? maxWidth;

  /// Max vehicle weight in metric tons
  final double? maxWeight;
}

/// Navigation session configuration
class NavigationOptions {
  NavigationOptions({
    this.enableReroute,
    this.rerouteThreshold,
    this.enableFasterRoute,
    this.fasterRouteDetectionInterval,
    this.initialCameraMode,
    this.defaultPadding,
  });

  /// Automatically reroute when off-route
  final bool? enableReroute;

  /// Deviation threshold in meters to trigger reroute
  final double? rerouteThreshold;

  /// Detect and suggest faster routes
  final bool? enableFasterRoute;

  /// Interval to check for faster routes (in seconds)
  final int? fasterRouteDetectionInterval;

  /// Initial camera mode
  final CameraMode? initialCameraMode;

  /// Default camera padding (top, left, bottom, right)
  final CameraPadding? defaultPadding;
}

class CameraPadding {
  CameraPadding({
    required this.top,
    required this.left,
    required this.bottom,
    required this.right,
  });

  final double top;
  final double left;
  final double bottom;
  final double right;
}

// ============================================================================
// DATA CLASSES - VISUAL CUSTOMIZATION (Sprint 2)
// ============================================================================

/// Configuration for route line appearance
class RouteLineOptions {
  RouteLineOptions({
    this.primaryRouteColor,
    this.alternativeRouteColor,
    this.traveledRouteColor,
    this.routeLineWidth,
    this.alternativeRouteLineWidth,
    this.trafficUnknownColor,
    this.trafficLowColor,
    this.trafficModerateColor,
    this.trafficHeavyColor,
    this.trafficSevereColor,
    this.enableTrafficColors,
    this.enableVanishingRouteLine,
  });

  /// Primary route color (ARGB as int)
  final int? primaryRouteColor;

  /// Alternative routes color
  final int? alternativeRouteColor;

  /// Color for traveled portion of route
  final int? traveledRouteColor;

  /// Width of primary route line
  final double? routeLineWidth;

  /// Width of alternative route lines
  final double? alternativeRouteLineWidth;

  /// Traffic congestion colors
  final int? trafficUnknownColor;
  final int? trafficLowColor;
  final int? trafficModerateColor;
  final int? trafficHeavyColor;
  final int? trafficSevereColor;

  /// Enable traffic-based coloring
  final bool? enableTrafficColors;

  /// Enable vanishing route line (traveled portion fades)
  final bool? enableVanishingRouteLine;
}

/// Configuration for maneuver arrow appearance
class ManeuverArrowOptions {
  ManeuverArrowOptions({
    this.arrowColor,
    this.arrowBorderColor,
    this.arrowBorderWidth,
    this.arrowShaftLength,
    this.arrowHeadLength,
  });

  /// Arrow fill color (ARGB)
  final int? arrowColor;

  /// Arrow border color (ARGB)
  final int? arrowBorderColor;

  /// Border width in pixels
  final double? arrowBorderWidth;

  /// Length of arrow shaft
  final double? arrowShaftLength;

  /// Length of arrow head
  final double? arrowHeadLength;
}

/// Camera animation configuration
class CameraAnimationOptions {
  CameraAnimationOptions({
    this.duration,
    this.maxDuration,
  });

  /// Animation duration in milliseconds
  final int? duration;

  /// Maximum duration in milliseconds
  final int? maxDuration;
}

/// Lane guidance information for an intersection
class LaneInfo {
  LaneInfo({
    required this.lanes,
    this.activeDirection,
  });

  /// List of lanes at this intersection
  final List<Lane> lanes;

  /// Primary active direction (e.g., "straight", "left")
  final String? activeDirection;
}

/// Individual lane information
class Lane {
  Lane({
    required this.valid,
    required this.active,
    required this.directions,
  });

  /// Whether this lane can be used
  final bool valid;

  /// Whether this lane should be used
  final bool active;

  /// Possible directions from this lane (straight, left, right, slight_left, etc.)
  final List<String> directions;
}

// ============================================================================
// DATA CLASSES - PROGRESS & STATE
// ============================================================================

/// Real-time route progress information
class RouteProgress {
  RouteProgress({
    required this.distanceRemaining,
    required this.durationRemaining,
    required this.distanceTraveled,
    required this.fractionTraveled,
    this.currentStepIndex,
    this.currentLegIndex,
    this.upcomingStepIndex,
    this.currentStep,
    this.upcomingStep,
    this.currentRoadName,
    this.currentSpeedLimit,
    this.congestionLevel,
  });

  /// Distance remaining to destination in meters
  final double distanceRemaining;

  /// Time remaining to destination in seconds
  final double durationRemaining;

  /// Distance traveled so far in meters
  final double distanceTraveled;

  /// Fraction of route traveled (0.0 to 1.0)
  final double fractionTraveled;

  /// Index of current step
  final int? currentStepIndex;

  /// Index of current leg
  final int? currentLegIndex;

  /// Index of upcoming step
  final int? upcomingStepIndex;

  /// Current step details
  final RouteStep? currentStep;

  /// Upcoming step details
  final RouteStep? upcomingStep;

  /// Current road/street name
  final String? currentRoadName;

  /// Current speed limit in km/h (null if unknown)
  final double? currentSpeedLimit;

  /// Traffic congestion level: unknown, low, moderate, heavy, severe
  final String? congestionLevel;
}

class RouteStep {
  RouteStep({
    required this.distance,
    required this.duration,
    this.name,
    this.instruction,
    this.maneuverType,
    this.maneuverModifier,
    this.distanceToManeuver,
    this.estimatedTimeToManeuver,
    this.exitNumbers,
    this.laneInfo,
  });

  /// Distance of this step in meters
  final double distance;

  /// Duration of this step in seconds
  final double duration;

  /// Street/road name
  final String? name;

  /// Human-readable instruction
  final String? instruction;

  /// Type of maneuver
  final ManeuverType? maneuverType;

  /// Modifier for maneuver
  final ManeuverModifier? maneuverModifier;

  /// Distance to the maneuver in meters
  final double? distanceToManeuver;

  /// Time to the maneuver in seconds
  final double? estimatedTimeToManeuver;

  /// Exit numbers (for roundabouts/intersections)
  final String? exitNumbers;

  /// Lane guidance information (Sprint 2)
  final LaneInfo? laneInfo;
}

/// Banner instruction for visual guidance
class BannerInstruction {
  BannerInstruction({
    required this.primaryText,
    this.secondaryText,
    this.distanceToManeuver,
    this.maneuverType,
    this.maneuverModifier,
    this.drivingSide,
    this.degrees,
  });

  /// Main instruction text
  final String primaryText;

  /// Additional instruction text
  final String? secondaryText;

  /// Distance to maneuver in meters
  final double? distanceToManeuver;

  /// Type of maneuver
  final ManeuverType? maneuverType;

  /// Modifier for maneuver
  final ManeuverModifier? maneuverModifier;

  /// Driving side: left or right
  final String? drivingSide;

  /// Heading change in degrees
  final double? degrees;
}

/// Voice instruction for audio guidance
class VoiceInstruction {
  VoiceInstruction({
    required this.announcement,
    required this.ssmlAnnouncement,
    this.distanceAlongGeometry,
  });

  /// Plain text announcement
  final String announcement;

  /// SSML-formatted announcement
  final String ssmlAnnouncement;

  /// Distance along geometry where this should be announced
  final double? distanceAlongGeometry;
}

/// Alternative route information
class RouteAlternative {
  RouteAlternative({
    required this.id,
    required this.distance,
    required this.duration,
    this.distanceDelta,
    this.durationDelta,
  });

  /// Alternative route identifier
  final String id;

  /// Total distance in meters
  final double distance;

  /// Total duration in seconds
  final double duration;

  /// Distance difference from current route
  final double? distanceDelta;

  /// Duration difference from current route
  final double? durationDelta;
}

/// Location with enhanced matching data
class EnhancedLocation {
  EnhancedLocation({
    required this.latitude,
    required this.longitude,
    this.bearing,
    this.speed,
    this.altitude,
    this.accuracy,
    this.timestamp,
    this.isMatched,
    this.roadName,
  });

  final double latitude;
  final double longitude;
  final double? bearing;
  final double? speed;
  final double? altitude;
  final double? accuracy;
  final int? timestamp;
  final bool? isMatched;
  final String? roadName;
}

// ============================================================================
// DATA CLASSES - EVENTS
// ============================================================================

class RouteProgressEvent {
  RouteProgressEvent({
    required this.progress,
    required this.timestamp,
  });

  final RouteProgress progress;
  final int timestamp;
}

class RerouteEvent {
  RerouteEvent({
    required this.reason,
    required this.state,
    this.newRoute,
  });

  final String reason;
  final RerouteState state;
  final RouteAlternative? newRoute;
}

class ArrivalEvent {
  ArrivalEvent({
    required this.finalDestination,
    this.waypointIndex,
  });

  final bool finalDestination;
  final int? waypointIndex;
}

class OffRouteEvent {
  OffRouteEvent({
    required this.distanceFromRoute,
    required this.timestamp,
  });

  final double distanceFromRoute;
  final int timestamp;
}

class NavigationStateEvent {
  NavigationStateEvent({
    required this.state,
    required this.timestamp,
  });

  final NavigationState state;
  final int timestamp;
}

// ============================================================================
// HOST API - Main Navigation Interface
// ============================================================================

@HostApi()
abstract class NavigationInterface {
  // -------------------------------------------------------------------------
  // Navigation Session Management
  // -------------------------------------------------------------------------

  /// Start a navigation session with options
  @async
  bool startNavigation(NavigationOptions options);

  /// Stop the current navigation session
  @async
  bool stopNavigation();

  /// Pause navigation (keep session alive but stop guidance)
  @async
  bool pauseNavigation();

  /// Resume paused navigation
  @async
  bool resumeNavigation();

  /// Get current navigation state
  NavigationState getNavigationState();

  // -------------------------------------------------------------------------
  // Route Management
  // -------------------------------------------------------------------------

  /// Request and set a route
  @async
  bool setRoute(RouteOptions options);

  /// Clear current route
  @async
  bool clearRoute();

  /// Request route alternatives
  @async
  List<RouteAlternative> getRouteAlternatives();

  /// Select an alternative route by ID
  @async
  bool selectAlternativeRoute(String routeId);

  // -------------------------------------------------------------------------
  // Progress & State Queries
  // -------------------------------------------------------------------------

  /// Get current route progress (returns null if no active route)
  RouteProgress? getCurrentProgress();

  /// Get current location with map matching
  EnhancedLocation? getCurrentLocation();

  // -------------------------------------------------------------------------
  // Camera Control
  // -------------------------------------------------------------------------

  /// Set camera mode
  void setCameraMode(CameraMode mode);

  /// Get current camera mode
  CameraMode getCameraMode();

  /// Update camera padding
  void setCameraPadding(CameraPadding padding);

  // -------------------------------------------------------------------------
  // Voice & Instructions
  // -------------------------------------------------------------------------

  /// Mute or unmute voice instructions
  void setVoiceMuted(bool muted);

  /// Check if voice is muted
  bool isVoiceMuted();

  /// Set voice language (e.g., "en", "es", "pt")
  void setVoiceLanguage(String languageCode);

  /// Set voice units
  void setVoiceUnits(VoiceUnits units);

  // -------------------------------------------------------------------------
  // Event Registration
  // -------------------------------------------------------------------------

  /// Register for route progress events
  void registerProgressObserver();

  /// Unregister from route progress events
  void unregisterProgressObserver();

  /// Register for banner instruction events
  void registerBannerObserver();

  /// Unregister from banner instruction events
  void unregisterBannerObserver();

  /// Register for voice instruction events
  void registerVoiceObserver();

  /// Unregister from voice instruction events
  void unregisterVoiceObserver();

  /// Register for reroute events
  void registerRerouteObserver();

  /// Unregister from reroute events
  void unregisterRerouteObserver();

  /// Register for arrival events
  void registerArrivalObserver();

  /// Unregister from arrival events
  void unregisterArrivalObserver();

  /// Register for off-route events
  void registerOffRouteObserver();

  /// Unregister from off-route events
  void unregisterOffRouteObserver();

  // -------------------------------------------------------------------------
  // Visual Customization (Sprint 2)
  // -------------------------------------------------------------------------

  /// Set route line styling options
  void setRouteLineOptions(RouteLineOptions options);

  /// Get current route line options
  RouteLineOptions getRouteLineOptions();

  /// Set maneuver arrow styling options
  void setManeuverArrowOptions(ManeuverArrowOptions options);

  /// Get current maneuver arrow options
  ManeuverArrowOptions getManeuverArrowOptions();

  /// Set camera mode with animation
  void setCameraModeAnimated(CameraMode mode, CameraAnimationOptions options);
}

// ============================================================================
// FLUTTER API - Events from Android to Dart
// ============================================================================

@FlutterApi()
abstract class NavigationEventListener {
  /// Called when route progress updates
  void onRouteProgress(RouteProgressEvent event);

  /// Called when banner instruction should be displayed
  void onBannerInstruction(BannerInstruction instruction);

  /// Called when voice instruction should be spoken
  void onVoiceInstruction(VoiceInstruction instruction);

  /// Called during reroute process
  void onReroute(RerouteEvent event);

  /// Called when arriving at waypoint or destination
  void onArrival(ArrivalEvent event);

  /// Called when driver goes off route
  void onOffRoute(OffRouteEvent event);

  /// Called when navigation state changes
  void onNavigationStateChanged(NavigationStateEvent event);
}
