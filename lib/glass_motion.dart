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
  
  Orientation orientation = new Orientation(0.0, 0.0, 0.0);
  Acceleration acceleration = new Acceleration(0.0, 0.0, 0.0);
  Calibration calibration = new Calibration();
  Position position;
  Movement movement;

  Window _window;

  Stream onMotion; // called when there is a motion update
  StreamController streamController = new StreamController();
  
 GlassMotion(this._window){
   onMotion = streamController.stream;
   _window.onDeviceMotion.listen((e) => _onDeviceMotion(e));
   _window.onDeviceOrientation.listen((e) => _onDeviceOrientation(e));
   
   position = new Position(orientation, acceleration, calibration);
   movement = new Movement(calibration);
 }
 
 /** Handle the device motion event */
  _onDeviceMotion(DeviceMotionEvent event){
    if(!streamController.hasListener) return;
    if(streamController.isPaused) return;
    
    if(acceleration.setValuesFromEvent(event)){
      movement.addDeltaVector(acceleration.vectorDelta);
      streamController.add(onMotion); // Send off our motion event update
    }
  }
  
  /** Handle the device orientation event */
  _onDeviceOrientation(DeviceOrientationEvent event){ 
    orientation.setValuesFromEvent(event);
  } 
}

