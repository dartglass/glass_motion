
library glass_motion;

import 'dart:html';
import 'dart:math' as Math;

part 'motion_handler.dart';


class GlassMotion {
  
  Window window;
  MotionHandler motionHandler;
  
  bool motionEnable;
  
  GlassMotion(this.window){
    window.onDeviceMotion.listen((e) => onDeviceMotion(e));
    
    motionHandler = new MotionHandler();
    motionEnable = true;
    
  }
  
  onDeviceMotion(DeviceMotionEvent event){
    
    if(motionEnable) motionHandler.onDeviceMotion(event); 
    
    
  }
  
}