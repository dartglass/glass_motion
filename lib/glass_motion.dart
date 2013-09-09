
library glass_motion;

import 'dart:html';
import 'dart:async';
import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart';

part 'src/motion_handler.dart';
part 'src/motion_calibration.dart';

class GlassMotion {
  
  Window window;
  MotionHandler _motionHandler = new MotionHandler();
  
  Stream onMotion; // called when there is a motion update
  
  var streamController = new StreamController();

  GlassMotion(this.window){
    window.onDeviceMotion.listen((e) => _onDeviceMotion(e));
    onMotion = streamController.stream;
  }
 
 double get acceleration => _motionHandler.getInstantaneousAcceleration();
 double get accelerationDelta => _motionHandler.getDeltaAcceleration();
 double get movement => _motionHandler.getMovement();
 double get roll => _motionHandler.getRoll();
 double get pitch => _motionHandler.getPitch();
 
 zeroPosition(){

 }
 
  _onDeviceMotion(DeviceMotionEvent event){
    if(!streamController.hasListener) return;
    
    if(_motionHandler.onDeviceMotion(event)){
      streamController.add(onMotion);
    }
 }
  
}