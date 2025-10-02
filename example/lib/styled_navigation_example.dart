import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'example.dart';

class StyledNavigationExample extends StatefulWidget implements Example {
  const StyledNavigationExample({super.key});

  @override
  final Widget leading = const Icon(Icons.palette);
  @override
  final String title = 'Styled Navigation';
  @override
  final String subtitle =
      'Custom route colors, traffic visualization, and animations';

  @override
  State<StyledNavigationExample> createState() =>
      _StyledNavigationExampleState();
}

class _StyledNavigationExampleState extends State<StyledNavigationExample> {
  MapboxMap? _mapboxMap;
  NavigationController? _navigation;

  String _currentStyle = 'Blue';
  bool _trafficEnabled = true;
  bool _vanishingEnabled = true;

  static const _startCoords = '-122.4194,37.7749';
  static const _endCoords = '-122.2711,37.8044';

  final Map<String, RouteLineOptions> _stylePresets = {
    'Blue': RouteLineOptions(
      primaryRouteColor: 0xFF2196F3,
      alternativeRouteColor: 0xFF9E9E9E,
      traveledRouteColor: 0xFFBBDEFB,
      routeLineWidth: 8.0,
      enableTrafficColors: true,
      enableVanishingRouteLine: true,
      trafficLowColor: 0xFF4CAF50,
      trafficModerateColor: 0xFFFFC107,
      trafficHeavyColor: 0xFFFF9800,
      trafficSevereColor: 0xFFF44336,
    ),
    'Purple': RouteLineOptions(
      primaryRouteColor: 0xFF9C27B0,
      alternativeRouteColor: 0xFFE0E0E0,
      traveledRouteColor: 0xFFE1BEE7,
      routeLineWidth: 9.0,
      enableTrafficColors: true,
      enableVanishingRouteLine: true,
      trafficLowColor: 0xFF66BB6A,
      trafficModerateColor: 0xFFFFEE58,
      trafficHeavyColor: 0xFFFF7043,
      trafficSevereColor: 0xFFE53935,
    ),
    'Orange': RouteLineOptions(
      primaryRouteColor: 0xFFFF9800,
      alternativeRouteColor: 0xFFBDBDBD,
      traveledRouteColor: 0xFFFFE0B2,
      routeLineWidth: 10.0,
      enableTrafficColors: true,
      enableVanishingRouteLine: true,
      trafficLowColor: 0xFF81C784,
      trafficModerateColor: 0xFFFFD54F,
      trafficHeavyColor: 0xFFFF8A65,
      trafficSevereColor: 0xFFF44336,
    ),
  };

  @override
  void dispose() {
    _navigation?.dispose();
    super.dispose();
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
    _navigation = NavigationController();
    _applyStyle();
  }

  void _applyStyle() {
    if (_navigation == null) return;

    final options = _stylePresets[_currentStyle]!;
    final styledOptions = RouteLineOptions(
      primaryRouteColor: options.primaryRouteColor,
      alternativeRouteColor: options.alternativeRouteColor,
      traveledRouteColor: options.traveledRouteColor,
      routeLineWidth: options.routeLineWidth,
      enableTrafficColors: _trafficEnabled,
      enableVanishingRouteLine: _vanishingEnabled,
      trafficLowColor: options.trafficLowColor,
      trafficModerateColor: options.trafficModerateColor,
      trafficHeavyColor: options.trafficHeavyColor,
      trafficSevereColor: options.trafficSevereColor,
    );

    _navigation!.setRouteLineOptions(styledOptions);

    // Also set maneuver arrow to match
    _navigation!.setManeuverArrowOptions(
      ManeuverArrowOptions(
        arrowColor: options.primaryRouteColor,
        arrowBorderColor: 0xFFFFFFFF,
        arrowBorderWidth: 2.0,
      ),
    );
  }

  Future<void> _startNavigation() async {
    if (_navigation == null) return;

    try {
      await _navigation!.setRoute(
        RouteOptions(
          coordinates: '$_startCoords;$_endCoords',
          profile: 'mapbox/driving-traffic',
          alternatives: true,
          voiceInstructions: false,
        ),
      );

      await _navigation!.startNavigation(
        NavigationOptions(
          enableReroute: true,
          initialCameraMode: CameraMode.overview,
        ),
      );

      // Animate to following mode after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        _navigation?.setCameraModeAnimated(
          CameraMode.following,
          CameraAnimationOptions(duration: 1500),
        );
      });
    } catch (e) {
      debugPrint('Failed to start navigation: $e');
    }
  }

  void _changeStyle(String style) {
    setState(() {
      _currentStyle = style;
    });
    _applyStyle();
  }

  void _toggleTraffic() {
    setState(() {
      _trafficEnabled = !_trafficEnabled;
    });
    _applyStyle();
  }

  void _toggleVanishing() {
    setState(() {
      _vanishingEnabled = !_vanishingEnabled;
    });
    _applyStyle();
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
              zoom: 11.0,
            ),
          ),

          // Style Selector
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Route Style',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _stylePresets.keys.map((style) {
                        return ChoiceChip(
                          label: Text(style),
                          selected: _currentStyle == style,
                          onSelected: (_) => _changeStyle(style),
                          selectedColor: _getStyleColor(style),
                        );
                      }).toList(),
                    ),
                    const Divider(),
                    SwitchListTile(
                      title: const Text('Traffic Colors'),
                      dense: true,
                      value: _trafficEnabled,
                      onChanged: (_) => _toggleTraffic(),
                    ),
                    SwitchListTile(
                      title: const Text('Vanishing Route Line'),
                      dense: true,
                      value: _vanishingEnabled,
                      onChanged: (_) => _toggleVanishing(),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Start Button
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton.icon(
              onPressed: _startNavigation,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Styled Navigation'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),

          // Legend
          Positioned(
            bottom: 80,
            right: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Traffic',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    _legendItem(Colors.green, 'Low'),
                    _legendItem(Colors.yellow, 'Moderate'),
                    _legendItem(Colors.orange, 'Heavy'),
                    _legendItem(Colors.red, 'Severe'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStyleColor(String style) {
    final colorValue = _stylePresets[style]!.primaryRouteColor!;
    return Color(colorValue);
  }

  Widget _legendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 4,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
