import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'example.dart';

class LaneGuidanceExample extends StatefulWidget implements Example {
  const LaneGuidanceExample({super.key});

  @override
  final Widget leading = const Icon(Icons.call_split);
  @override
  final String title = 'Lane Guidance';
  @override
  final String subtitle = 'Visual lane indicators for complex intersections';

  @override
  State<LaneGuidanceExample> createState() => _LaneGuidanceExampleState();
}

class _LaneGuidanceExampleState extends State<LaneGuidanceExample> {
  MapboxMap? _mapboxMap;
  NavigationController? _navigation;

  LaneInfo? _currentLaneInfo;
  RouteProgress? _currentProgress;

  // Complex route with intersections
  static const _startCoords = '-122.4194,37.7749';
  static const _endCoords = '-122.2711,37.8044';

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

    // Listen to progress for lane info
    _navigation!.routeProgressStream.listen((event) {
      setState(() {
        _currentProgress = event.progress;
        _currentLaneInfo = event.progress.currentStep?.laneInfo;
      });
    });
  }

  Future<void> _startNavigation() async {
    if (_navigation == null) return;

    try {
      await _navigation!.setRoute(
        RouteOptions(
          coordinates: '$_startCoords;$_endCoords',
          profile: 'mapbox/driving-traffic',
          alternatives: false,
          voiceInstructions: true,
          bannerInstructions: true,
          steps: true, // Ensure we get detailed steps
        ),
      );

      await _navigation!.startNavigation(
        NavigationOptions(
          enableReroute: true,
          initialCameraMode: CameraMode.following,
        ),
      );
    } catch (e) {
      debugPrint('Failed to start navigation: $e');
    }
  }

  Future<void> _stopNavigation() async {
    if (_navigation == null) return;
    await _navigation!.stopNavigation();
    setState(() {
      _currentLaneInfo = null;
      _currentProgress = null;
    });
  }

  String _formatDistance(double meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
    return '${meters.toStringAsFixed(0)} m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            onMapCreated: _onMapCreated,
            cameraOptions: CameraOptions(
              center: Point(coordinates: Position(-122.4194, 37.7749)),
              zoom: 12.0,
            ),
          ),

          // Lane Guidance Overlay
          if (_currentLaneInfo != null)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Current instruction
                  if (_currentProgress?.currentStep?.instruction != null)
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          _currentProgress!.currentStep!.instruction!,
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),

                  // Lane guidance widget
                  Center(
                    child: LaneGuidanceView(
                      laneInfo: _currentLaneInfo!,
                      style: LaneGuidanceStyle(
                        laneWidth: 70.0,
                        laneHeight: 90.0,
                        activeLaneColor: const Color(0xFF2196F3),
                        backgroundColor: Colors.white,
                        elevation: 8.0,
                        padding: const EdgeInsets.all(16.0),
                      ),
                    ),
                  ),

                  // Distance to maneuver
                  if (_currentProgress?.currentStep?.distanceToManeuver != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'In ${_formatDistance(_currentProgress!.currentStep!.distanceToManeuver!)}',
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

          // Info Card when no lane info
          if (_currentLaneInfo == null && _currentProgress != null)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Card(
                color: Colors.blue.shade50,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue),
                      SizedBox(height: 8),
                      Text(
                        'Lane guidance will appear at complex intersections',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Continue navigating to see lane indicators',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Controls
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Demo Button - Show sample lane info
                if (_currentLaneInfo == null && _currentProgress == null)
                  Card(
                    color: Colors.amber.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Lane Guidance Demo',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Start navigation to see real lane guidance, or view sample:',
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                // Demo lane info
                                _currentLaneInfo = LaneInfo(
                                  lanes: [
                                    Lane(
                                      valid: false,
                                      active: false,
                                      directions: ['left'],
                                    ),
                                    Lane(
                                      valid: true,
                                      active: true,
                                      directions: ['straight'],
                                    ),
                                    Lane(
                                      valid: true,
                                      active: false,
                                      directions: ['straight', 'right'],
                                    ),
                                  ],
                                  activeDirection: 'straight',
                                );
                              });
                            },
                            icon: const Icon(Icons.preview),
                            label: const Text('Show Sample Lane Guidance'),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 8),

                // Start/Stop Button
                ElevatedButton.icon(
                  onPressed: _currentProgress == null
                      ? _startNavigation
                      : _stopNavigation,
                  icon: Icon(
                      _currentProgress == null ? Icons.play_arrow : Icons.stop),
                  label: Text(_currentProgress == null
                      ? 'Start Navigation'
                      : 'Stop Navigation'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
