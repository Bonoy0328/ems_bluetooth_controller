import 'package:flutter/material.dart';
import '../controller/knob_controller.dart';
import '../utils/polar_coordinate.dart';
import '../widgets/control_knob.dart';

import '../widgets/radial_drag_gesture_detector.dart';
import 'package:provider/provider.dart';

class KnobGestureDetector extends StatefulWidget {
  const KnobGestureDetector({
    Key? key,
  }) : super(key: key);

  @override
  _KnobGestureDetectorState createState() => _KnobGestureDetectorState();
}

class _KnobGestureDetectorState extends State<KnobGestureDetector> {
  _onRadialDragStart(PolarCoordinate coordinate) {}

  _onRadialDragUpdate(PolarCoordinate coordinate) {
    var controller = Provider.of<KnobController>(context, listen: false);
    var angle = coordinate.angle;
    var value = controller.getValueOfAngle(angle);
    controller.setCurrentValue(value);
  }

  onRadialDragEnd() {}

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<KnobController>(context);
    return RadialDragGestureDetector(
      onRadialDragStart: _onRadialDragStart,
      onRadialDragUpdate: _onRadialDragUpdate,
      onRadialDragEnd: onRadialDragEnd,
      child: ControlKnob(
        controller.getAngleOfValue(controller.value.current) / 360,
      ),
    );
  }
}
