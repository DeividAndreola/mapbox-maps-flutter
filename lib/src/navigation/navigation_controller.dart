part of mapbox_maps_flutter;

/// High-level navigation controller for managing navigation sessions.
///
/// This controller provides a Flutter-friendly API for the Mapbox Navigation SDK,
/// handling the platform channel communication and providing reactive streams
/// for navigation events.
///
/// Example usage:
/// ```dart
/// final navigation = NavigationController();
///
/// // Set up a route with waypoints
/// await navigation.setRoute(
///   RouteOptions(
///     coordinates: '-122.4,37.8;-122.5,37.9',
///     profile: 'driving-traffic',
///     alternatives: true,
///     voiceInstructions: true,
///     bannerInstructions: true,
///   ),
/// );
///
/// // Start navigation
/// await navigation.startNavigation(
///   NavigationOptions(
///     enableReroute: true,
///     initialCameraMode: CameraMode.following,
///   ),
/// );
///
/// // Listen to progress updates
/// navigation.routeProgressStream.listen((progress) {
///   print('Distance remaining: ${progress.distanceRemaining}m');
///   print('ETA: ${progress.durationRemaining}s');
/// });
///
/// // Listen to voice instructions
/// navigation.voiceInstructionsStream.listen((instruction) {
///   print('Say: ${instruction.announcement}');
/// });
///
/// // Stop navigation when done
/// await navigation.stopNavigation();
/// ```
class NavigationController {
  NavigationController({String? channelSuffix})
      : _interface =
            NavigationInterface(messageChannelSuffix: channelSuffix ?? ''),
        _eventListener = _NavigationEventListenerImpl() {
    NavigationEventListener.setUp(_eventListener,
        messageChannelSuffix: channelSuffix ?? '');
    _setupEventListeners();
  }

  final NavigationInterface _interface;
  final _NavigationEventListenerImpl _eventListener;

  // Event stream controllers
  final StreamController<RouteProgressEvent> _progressController =
      StreamController<RouteProgressEvent>.broadcast();
  final StreamController<BannerInstruction> _bannerController =
      StreamController<BannerInstruction>.broadcast();
  final StreamController<VoiceInstruction> _voiceController =
      StreamController<VoiceInstruction>.broadcast();
  final StreamController<RerouteEvent> _rerouteController =
      StreamController<RerouteEvent>.broadcast();
  final StreamController<ArrivalEvent> _arrivalController =
      StreamController<ArrivalEvent>.broadcast();
  final StreamController<OffRouteEvent> _offRouteController =
      StreamController<OffRouteEvent>.broadcast();
  final StreamController<NavigationStateEvent> _stateController =
      StreamController<NavigationStateEvent>.broadcast();

  /// Stream of route progress updates.
  ///
  /// Emits progress updates during active navigation, including:
  /// - Distance and time remaining
  /// - Current step information
  /// - Speed limits and road names
  /// - Traffic congestion levels
  Stream<RouteProgressEvent> get routeProgressStream =>
      _progressController.stream;

  /// Stream of banner instructions for visual guidance.
  ///
  /// Emits instructions that should be displayed to the user.
  Stream<BannerInstruction> get bannerInstructionsStream =>
      _bannerController.stream;

  /// Stream of voice instructions for audio guidance.
  ///
  /// Emits instructions that should be spoken to the user.
  Stream<VoiceInstruction> get voiceInstructionsStream =>
      _voiceController.stream;

  /// Stream of reroute events.
  ///
  /// Emits when the user goes off route and rerouting is triggered.
  Stream<RerouteEvent> get rerouteStream => _rerouteController.stream;

  /// Stream of arrival events.
  ///
  /// Emits when the user arrives at a waypoint or destination.
  Stream<ArrivalEvent> get arrivalStream => _arrivalController.stream;

  /// Stream of off-route events.
  ///
  /// Emits when the user deviates from the route.
  Stream<OffRouteEvent> get offRouteStream => _offRouteController.stream;

  /// Stream of navigation state changes.
  ///
  /// Emits when navigation state transitions (e.g., idle -> active -> arrived).
  Stream<NavigationStateEvent> get navigationStateStream =>
      _stateController.stream;

  /// Start a navigation session with the given options.
  ///
  /// This initializes the navigation session and begins tracking location.
  /// You must call [setRoute] before starting navigation.
  ///
  /// Returns `true` if navigation started successfully.
  Future<bool> startNavigation(NavigationOptions options) async {
    try {
      _registerAllObservers();
      return await _interface.startNavigation(options);
    } catch (e) {
      developer.log('Failed to start navigation: $e',
          name: 'NavigationController');
      rethrow;
    }
  }

  /// Stop the current navigation session.
  ///
  /// This ends the navigation session and clears the route.
  /// Location tracking will stop.
  ///
  /// Returns `true` if navigation stopped successfully.
  Future<bool> stopNavigation() async {
    try {
      _unregisterAllObservers();
      return await _interface.stopNavigation();
    } catch (e) {
      developer.log('Failed to stop navigation: $e',
          name: 'NavigationController');
      rethrow;
    }
  }

  /// Pause navigation without ending the session.
  ///
  /// Location tracking continues but guidance is paused.
  /// Call [resumeNavigation] to continue guidance.
  Future<bool> pauseNavigation() async {
    try {
      return await _interface.pauseNavigation();
    } catch (e) {
      developer.log('Failed to pause navigation: $e',
          name: 'NavigationController');
      rethrow;
    }
  }

  /// Resume paused navigation.
  ///
  /// Guidance will resume from the current location.
  Future<bool> resumeNavigation() async {
    try {
      return await _interface.resumeNavigation();
    } catch (e) {
      developer.log('Failed to resume navigation: $e',
          name: 'NavigationController');
      rethrow;
    }
  }

  /// Get the current navigation state.
  Future<NavigationState> getNavigationState() async {
    return await _interface.getNavigationState();
  }

  /// Set a route for navigation.
  ///
  /// This requests route directions from the Mapbox Directions API
  /// and prepares the route for navigation.
  ///
  /// Example:
  /// ```dart
  /// await navigation.setRoute(
  ///   RouteOptions(
  ///     coordinates: '-122.4,37.8;-122.5,37.9;-122.6,38.0',
  ///     profile: 'driving-traffic',
  ///     alternatives: true,
  ///     voiceInstructions: true,
  ///     bannerInstructions: true,
  ///     waypointNames: 'Start;Middle;End',
  ///     waypointIndices: '0;2', // First and last are waypoints
  ///   ),
  /// );
  /// ```
  ///
  /// Returns `true` if the route was set successfully.
  Future<bool> setRoute(RouteOptions options) async {
    try {
      return await _interface.setRoute(options);
    } catch (e) {
      developer.log('Failed to set route: $e', name: 'NavigationController');
      rethrow;
    }
  }

  /// Clear the current route.
  ///
  /// This removes the route from the map and resets navigation state.
  Future<bool> clearRoute() async {
    try {
      return await _interface.clearRoute();
    } catch (e) {
      developer.log('Failed to clear route: $e', name: 'NavigationController');
      rethrow;
    }
  }

  /// Get available alternative routes.
  ///
  /// Returns a list of alternative routes if alternatives were requested
  /// in [RouteOptions].
  Future<List<RouteAlternative>> getRouteAlternatives() async {
    try {
      return await _interface.getRouteAlternatives();
    } catch (e) {
      developer.log('Failed to get alternatives: $e',
          name: 'NavigationController');
      rethrow;
    }
  }

  /// Select an alternative route by ID.
  ///
  /// The route ID comes from [RouteAlternative.id].
  Future<bool> selectAlternativeRoute(String routeId) async {
    try {
      return await _interface.selectAlternativeRoute(routeId);
    } catch (e) {
      developer.log('Failed to select alternative: $e',
          name: 'NavigationController');
      rethrow;
    }
  }

  /// Get the current route progress.
  ///
  /// Returns `null` if there is no active route.
  Future<RouteProgress?> getCurrentProgress() async {
    return await _interface.getCurrentProgress();
  }

  /// Get the current location with map matching data.
  ///
  /// Returns `null` if location is not available.
  Future<EnhancedLocation?> getCurrentLocation() async {
    return await _interface.getCurrentLocation();
  }

  /// Set the camera mode.
  ///
  /// Available modes:
  /// - [CameraMode.idle] - Camera does not follow user
  /// - [CameraMode.overview] - Shows entire route
  /// - [CameraMode.following] - Follows user with perspective
  void setCameraMode(CameraMode mode) {
    try {
      _interface.setCameraMode(mode);
    } catch (e) {
      developer.log('Failed to set camera mode: $e',
          name: 'NavigationController');
      rethrow;
    }
  }

  /// Get the current camera mode.
  Future<CameraMode> getCameraMode() async {
    return await _interface.getCameraMode();
  }

  /// Update camera padding.
  ///
  /// Padding is used to ensure important map elements are visible
  /// when UI overlays are present.
  void setCameraPadding(CameraPadding padding) {
    try {
      _interface.setCameraPadding(padding);
    } catch (e) {
      developer.log('Failed to set camera padding: $e',
          name: 'NavigationController');
      rethrow;
    }
  }

  /// Mute or unmute voice instructions.
  void setVoiceMuted(bool muted) {
    try {
      _interface.setVoiceMuted(muted);
    } catch (e) {
      developer.log('Failed to set voice muted: $e',
          name: 'NavigationController');
      rethrow;
    }
  }

  /// Check if voice instructions are muted.
  Future<bool> isVoiceMuted() async {
    return await _interface.isVoiceMuted();
  }

  /// Set the language for voice instructions.
  ///
  /// Uses ISO 639-1 language codes (e.g., "en", "es", "pt", "fr").
  void setVoiceLanguage(String languageCode) {
    try {
      _interface.setVoiceLanguage(languageCode);
    } catch (e) {
      developer.log('Failed to set voice language: $e',
          name: 'NavigationController');
      rethrow;
    }
  }

  /// Set the units for voice instructions.
  void setVoiceUnits(VoiceUnits units) {
    try {
      _interface.setVoiceUnits(units);
    } catch (e) {
      developer.log('Failed to set voice units: $e',
          name: 'NavigationController');
      rethrow;
    }
  }

  /// Set options for the route line.
  void setRouteLineOptions(RouteLineOptions options) {
    try {
      _interface.setRouteLineOptions(options);
    } catch (e) {
      developer.log('Failed to set route line options: $e',
          name: 'NavigationController');
      rethrow;
    }
  }

  /// Set options for the maneuver arrow.
  void setManeuverArrowOptions(ManeuverArrowOptions options) {
    try {
      _interface.setManeuverArrowOptions(options);
    } catch (e) {
      developer.log('Failed to set maneuver arrow options: $e',
          name: 'NavigationController');
      rethrow;
    }
  }

  /// Set the camera mode with animation options.
  void setCameraModeAnimated(CameraMode mode, CameraAnimationOptions options) {
    try {
      _interface.setCameraModeAnimated(mode, options);
    } catch (e) {
      developer.log('Failed to set camera mode animated: $e',
          name: 'NavigationController');
      rethrow;
    }
  }

  /// Dispose of this controller and clean up resources.
  ///
  /// Call this when you're done with navigation to free resources.
  void dispose() {
    _unregisterAllObservers();
    _progressController.close();
    _bannerController.close();
    _voiceController.close();
    _rerouteController.close();
    _arrivalController.close();
    _offRouteController.close();
    _stateController.close();
  }

  // Private methods

  void _setupEventListeners() {
    _eventListener.onProgressCallback =
        (event) => _progressController.add(event);
    _eventListener.onBannerCallback =
        (instruction) => _bannerController.add(instruction);
    _eventListener.onVoiceCallback =
        (instruction) => _voiceController.add(instruction);
    _eventListener.onRerouteCallback = (event) => _rerouteController.add(event);
    _eventListener.onArrivalCallback = (event) => _arrivalController.add(event);
    _eventListener.onOffRouteCallback =
        (event) => _offRouteController.add(event);
    _eventListener.onStateCallback = (event) => _stateController.add(event);
  }

  void _registerAllObservers() {
    _interface.registerProgressObserver();
    _interface.registerBannerObserver();
    _interface.registerVoiceObserver();
    _interface.registerRerouteObserver();
    _interface.registerArrivalObserver();
    _interface.registerOffRouteObserver();
  }

  void _unregisterAllObservers() {
    _interface.unregisterProgressObserver();
    _interface.unregisterBannerObserver();
    _interface.unregisterVoiceObserver();
    _interface.unregisterRerouteObserver();
    _interface.unregisterArrivalObserver();
    _interface.unregisterOffRouteObserver();
  }
}

/// Internal implementation of NavigationEventListener for receiving events from native code.
class _NavigationEventListenerImpl implements NavigationEventListener {
  void Function(RouteProgressEvent)? onProgressCallback;
  void Function(BannerInstruction)? onBannerCallback;
  void Function(VoiceInstruction)? onVoiceCallback;
  void Function(RerouteEvent)? onRerouteCallback;
  void Function(ArrivalEvent)? onArrivalCallback;
  void Function(OffRouteEvent)? onOffRouteCallback;
  void Function(NavigationStateEvent)? onStateCallback;

  @override
  void onRouteProgress(RouteProgressEvent event) {
    onProgressCallback?.call(event);
  }

  @override
  void onBannerInstruction(BannerInstruction instruction) {
    onBannerCallback?.call(instruction);
  }

  @override
  void onVoiceInstruction(VoiceInstruction instruction) {
    onVoiceCallback?.call(instruction);
  }

  @override
  void onReroute(RerouteEvent event) {
    onRerouteCallback?.call(event);
  }

  @override
  void onArrival(ArrivalEvent event) {
    onArrivalCallback?.call(event);
  }

  @override
  void onOffRoute(OffRouteEvent event) {
    onOffRouteCallback?.call(event);
  }

  @override
  void onNavigationStateChanged(NavigationStateEvent event) {
    onStateCallback?.call(event);
  }
}
