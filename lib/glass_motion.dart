library glass_motion;

import 'dart:html';
import 'dart:async';
import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart';

part 'src/acceleration.dart';
part 'src/orientation.dart';
part 'src/calibration.dart';
part 'src/movement.dart';
part 'src/position.dart';

class GlassMotion
{
  static const tweekyVectorThreshold = 10;

  Orientation orientation = new Orientation();
  Acceleration acceleration = new Acceleration();
  Calibration calibration = new Calibration();
  Position position;
  Movement movement;

  Window _window;

  Stream onMotion; // called when there is a motion update
  Stream onOrientation; // called when there is a orientation update
  StreamController motionStreamController = new StreamController();
  StreamController orientationStreamController = new StreamController();

 GlassMotion(this._window){
   onMotion = motionStreamController.stream;
   onOrientation = orientationStreamController.stream;
   _window.onDeviceMotion.listen((e) => _onDeviceMotion(e));
   _window.onDeviceOrientation.listen((e) => _onDeviceOrientation(e));

   position = new Position(orientation, acceleration, calibration);
   movement = new Movement(calibration);

 }

 /** Handle the device motion event */
  _onDeviceMotion(DeviceMotionEvent event){
    if(!motionStreamController.hasListener) return;
    if(motionStreamController.isPaused) return;

    if(acceleration.setValuesFromEvent(event)){
      movement.addDeltaVector(acceleration.vectorDelta);

      motionStreamController.add(onMotion); // Send off our motion event update
    }
  }

  /** Handle the device orientation event */
  _onDeviceOrientation(DeviceOrientationEvent event){
    if(!orientationStreamController.hasListener) return;
    if(orientationStreamController.isPaused) return;

    orientation.setValuesFromEvent(event);
    orientationStreamController.add(onOrientation);
  }
}

