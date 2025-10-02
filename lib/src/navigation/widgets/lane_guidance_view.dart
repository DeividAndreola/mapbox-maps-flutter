part of mapbox_maps_flutter;

/// Widget for displaying lane guidance at intersections.
///
/// Shows visual indicators for which lanes can be used and which should be used
/// for the upcoming maneuver.
///
/// Example usage:
/// ```dart
/// navigation.routeProgressStream.listen((event) {
///   final laneInfo = event.progress.currentStep?.laneInfo;
///   if (laneInfo != null) {
///     showDialog(
///       context: context,
///       builder: (context) => LaneGuidanceView(
///         laneInfo: laneInfo,
///         style: LaneGuidanceStyle(),
///       ),
///     );
///   }
/// });
/// ```
class LaneGuidanceView extends StatelessWidget {
  const LaneGuidanceView({
    Key? key,
    required this.laneInfo,
    this.style = const LaneGuidanceStyle(),
  }) : super(key: key);

  final LaneInfo laneInfo;
  final LaneGuidanceStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: style.padding,
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: style.borderRadius,
        boxShadow: style.elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: style.elevation,
                  offset: Offset(0, style.elevation / 2),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < laneInfo.lanes.length; i++) ...[
            LaneIndicator(
              lane: laneInfo.lanes[i],
              style: style,
            ),
            if (i < laneInfo.lanes.length - 1)
              SizedBox(width: style.laneSpacing),
          ],
        ],
      ),
    );
  }
}

/// Individual lane indicator showing arrows for possible directions.
class LaneIndicator extends StatelessWidget {
  const LaneIndicator({
    Key? key,
    required this.lane,
    required this.style,
  }) : super(key: key);

  final Lane lane;
  final LaneGuidanceStyle style;

  @override
  Widget build(BuildContext context) {
    final color = lane.active
        ? style.activeLaneColor
        : lane.valid
            ? style.validLaneColor
            : style.invalidLaneColor;

    return Container(
      width: style.laneWidth,
      height: style.laneHeight,
      decoration: BoxDecoration(
        color: lane.active ? color.withOpacity(0.2) : Colors.transparent,
        border: Border.all(
          color: color,
          width:
              lane.active ? style.activeLaneBorderWidth : style.laneBorderWidth,
        ),
        borderRadius: BorderRadius.circular(style.laneRounding),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: lane.directions.map((direction) {
          return Icon(
            _getDirectionIcon(direction),
            size: style.arrowSize,
            color: color,
          );
        }).toList(),
      ),
    );
  }

  IconData _getDirectionIcon(String direction) {
    switch (direction.toLowerCase()) {
      case 'straight':
      case 'through':
        return Icons.arrow_upward;
      case 'left':
        return Icons.arrow_back;
      case 'right':
        return Icons.arrow_forward;
      case 'slight left':
      case 'slight_left':
        return Icons.north_west;
      case 'slight right':
      case 'slight_right':
        return Icons.north_east;
      case 'sharp left':
      case 'sharp_left':
        return Icons.turn_sharp_left;
      case 'sharp right':
      case 'sharp_right':
        return Icons.turn_sharp_right;
      case 'uturn':
      case 'u-turn':
        return Icons.u_turn_left;
      default:
        return Icons.arrow_upward;
    }
  }
}

/// Styling configuration for lane guidance display.
class LaneGuidanceStyle {
  const LaneGuidanceStyle({
    this.laneWidth = 60.0,
    this.laneHeight = 80.0,
    this.laneSpacing = 8.0,
    this.laneRounding = 4.0,
    this.laneBorderWidth = 2.0,
    this.activeLaneBorderWidth = 3.0,
    this.arrowSize = 32.0,
    this.activeLaneColor = const Color(0xFF4CAF50),
    this.validLaneColor = const Color(0xFF9E9E9E),
    this.invalidLaneColor = const Color(0xFFE0E0E0),
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.padding = const EdgeInsets.all(12.0),
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.elevation = 4.0,
  });

  /// Width of each lane indicator
  final double laneWidth;

  /// Height of each lane indicator
  final double laneHeight;

  /// Spacing between lanes
  final double laneSpacing;

  /// Corner rounding for lane boxes
  final double laneRounding;

  /// Border width for normal lanes
  final double laneBorderWidth;

  /// Border width for active lane
  final double activeLaneBorderWidth;

  /// Size of direction arrows
  final double arrowSize;

  /// Color for lanes that should be used
  final Color activeLaneColor;

  /// Color for lanes that can be used
  final Color validLaneColor;

  /// Color for lanes that cannot be used
  final Color invalidLaneColor;

  /// Background color of the widget
  final Color backgroundColor;

  /// Padding around the lane display
  final EdgeInsets padding;

  /// Border radius of the widget
  final BorderRadius borderRadius;

  /// Elevation/shadow depth
  final double elevation;

  /// Creates a copy with modified properties
  LaneGuidanceStyle copyWith({
    double? laneWidth,
    double? laneHeight,
    double? laneSpacing,
    double? laneRounding,
    double? laneBorderWidth,
    double? activeLaneBorderWidth,
    double? arrowSize,
    Color? activeLaneColor,
    Color? validLaneColor,
    Color? invalidLaneColor,
    Color? backgroundColor,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
    double? elevation,
  }) {
    return LaneGuidanceStyle(
      laneWidth: laneWidth ?? this.laneWidth,
      laneHeight: laneHeight ?? this.laneHeight,
      laneSpacing: laneSpacing ?? this.laneSpacing,
      laneRounding: laneRounding ?? this.laneRounding,
      laneBorderWidth: laneBorderWidth ?? this.laneBorderWidth,
      activeLaneBorderWidth:
          activeLaneBorderWidth ?? this.activeLaneBorderWidth,
      arrowSize: arrowSize ?? this.arrowSize,
      activeLaneColor: activeLaneColor ?? this.activeLaneColor,
      validLaneColor: validLaneColor ?? this.validLaneColor,
      invalidLaneColor: invalidLaneColor ?? this.invalidLaneColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
    );
  }
}
