
library glass_motion;

import 'dart:html';
import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart';

part 'src/motion_handler.dart';
part 'src/motion_calibration.dart';


typedef void onMotionUpdateFunction(GlassMotion glassMotion);


class GlassMotion {
  
  Window window;
  MotionHandler _motionHandler;
  onMotionUpdateFunction onMotionUpdate;
  
  bool motionEnable;

  GlassMotion(this.window){
    window.onDeviceMotion.listen((e) => _onDeviceMotion(e));
    
    _motionHandler = new MotionHandler();
    motionEnable = true;
  }
 
 double get acceleration => _motionHandler.acceleration;
 double get movement => _motionHandler.getAvgMovement();
 double get yaw => _motionHandler.yaw;
 double get pitch => _motionHandler.pitch;
 double get tilt => _motionHandler.tilt;
 

  _onDeviceMotion(DeviceMotionEvent event){
    
    if(!motionEnable) return;
    
    _motionHandler.onDeviceMotion(event);
    
    if (onMotionUpdate != null) {
      onMotionUpdate(this);

    }
    
  }
  

  
}