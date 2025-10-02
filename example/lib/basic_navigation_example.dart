import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'example.dart';

class BasicNavigationExample extends StatefulWidget implements Example {
  const BasicNavigationExample({super.key});

  @override
  final Widget leading = const Icon(Icons.navigation);
  @override
  final String title = 'Basic Navigation';
  @override
  final String subtitle =
      'Turn-by-turn navigation with route, voice, and progress';

  @override
  State<BasicNavigationExample> createState() => _BasicNavigationExampleState();
}

class _BasicNavigationExampleState extends State<BasicNavigationExample> {
  MapboxMap? _mapboxMap;
  NavigationController? _navigation;

  RouteProgress? _currentProgress;
  NavigationState _navState = NavigationState.idle;
  bool _isVoiceMuted = false;

  // Example coordinates: San Francisco to Oakland
  static const _startCoords = '-122.4194,37.7749'; // SF
  static const _endCoords = '-122.2711,37.8044'; // Oakland

  @override
  void dispose() {
    _navigation?.dispose();
    super.dispose();
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
    _navigation = NavigationController();
    _setupNavigation();
  }

  void _setupNavigation() {
    if (_navigation == null) return;

    // Listen to progress updates
    _navigation!.routeProgressStream.listen((event) {
      setState(() {
        _currentProgress = event.progress;
      });
    });

    // Listen to voice instructions
    _navigation!.voiceInstructionsStream.listen((instruction) {
      debugPrint('Voice: ${instruction.announcement}');
    });

    // Listen to banner instructions
    _navigation!.bannerInstructionsStream.listen((instruction) {
      debugPrint('Banner: ${instruction.primaryText}');
    });

    // Listen to navigation state changes
    _navigation!.navigationStateStream.listen((event) {
      setState(() {
        _navState = event.state;
      });
    });

    // Listen to arrival events
    _navigation!.arrivalStream.listen((event) {
      if (event.finalDestination) {
        _showDialog('Arrived!', 'You have reached your destination');
      }
    });
  }

  Future<void> _startNavigation() async {
    if (_navigation == null) return;

    try {
      // 1. Set the route
      await _navigation!.setRoute(
        RouteOptions(
          coordinates: '$_startCoords;$_endCoords',
          profile: 'mapbox/driving-traffic',
          alternatives: true,
          voiceInstructions: true,
          bannerInstructions: true,
          language: 'en',
          voiceUnits: VoiceUnits.imperial,
        ),
      );

      // 2. Start navigation
      await _navigation!.startNavigation(
        NavigationOptions(
          enableReroute: true,
          rerouteThreshold: 50.0,
          enableFasterRoute: true,
          initialCameraMode: CameraMode.following,
        ),
      );

      _showDialog('Navigation Started', 'Route set successfully');
    } catch (e) {
      _showDialog('Error', 'Failed to start navigation: $e');
    }
  }

  Future<void> _stopNavigation() async {
    if (_navigation == null) return;

    try {
      await _navigation!.stopNavigation();
      setState(() {
        _currentProgress = null;
      });
      _showDialog('Navigation Stopped', 'Navigation session ended');
    } catch (e) {
      _showDialog('Error', 'Failed to stop navigation: $e');
    }
  }

  void _toggleVoice() {
    if (_navigation == null) return;
    setState(() {
      _isVoiceMuted = !_isVoiceMuted;
    });
    _navigation!.setVoiceMuted(_isVoiceMuted);
  }

  void _toggleCamera() {
    if (_navigation == null) return;
    final currentMode = _navigation!.getCameraMode();
    final newMode = currentMode == CameraMode.following
        ? CameraMode.overview
        : CameraMode.following;
    _navigation!.setCameraMode(newMode);
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatDistance(double meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
    return '${meters.toStringAsFixed(0)} m';
  }

  String _formatDuration(double seconds) {
    final minutes = (seconds / 60).floor();
    if (minutes >= 60) {
      final hours = (minutes / 60).floor();
      final mins = minutes % 60;
      return '${hours}h ${mins}m';
    }
    return '${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map
          MapWidget(
            onMapCreated: _onMapCreated,
            cameraOptions: CameraOptions(
              center: Point(coordinates: Position(-122.4194, 37.7749)),
              zoom: 12.0,
            ),
          ),

          // Progress Card
          if (_currentProgress != null)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Navigation Progress',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Distance Remaining'),
                              Text(
                                _formatDistance(
                                    _currentProgress!.distanceRemaining),
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Time Remaining'),
                              Text(
                                _formatDuration(
                                    _currentProgress!.durationRemaining),
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (_currentProgress!.currentRoadName != null)
                        Text(
                          'On: ${_currentProgress!.currentRoadName}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      if (_currentProgress!.currentSpeedLimit != null)
                        Text(
                          'Speed Limit: ${_currentProgress!.currentSpeedLimit!.toStringAsFixed(0)} km/h',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: _currentProgress!.fractionTraveled,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Control Buttons
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _navState == NavigationState.idle
                            ? _startNavigation
                            : _stopNavigation,
                        icon: Icon(_navState == NavigationState.idle
                            ? Icons.play_arrow
                            : Icons.stop),
                        label: Text(_navState == NavigationState.idle
                            ? 'Start Navigation'
                            : 'Stop Navigation'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _toggleVoice,
                        icon: Icon(
                            _isVoiceMuted ? Icons.volume_off : Icons.volume_up),
                        label: Text(_isVoiceMuted ? 'Unmute' : 'Mute'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _toggleCamera,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Toggle View'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // State Indicator
          Positioned(
            top: 16,
            right: 16,
            child: Chip(
              label: Text(_navState.name.toUpperCase()),
              backgroundColor: _navState == NavigationState.activeGuidance
                  ? Colors.green
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
