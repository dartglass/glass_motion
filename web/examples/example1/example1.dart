import 'dart:html';

import 'package:glass_motion/glass_motion.dart';

void main() {
  
  GlassMotion glassMotion = new GlassMotion(window);
  
  query("#sample_text_id")..text   = "Test";
  
  glassMotion.onMotionUpdate = ((e){
    query("#sample_text_id")..text   = " Acceleration : ${glassMotion.acceleration.toStringAsFixed(3)}"; 
    query("#sample_text_id2")..text   = " Yaw (Head Side Tilt): ${glassMotion.yaw.toStringAsFixed(0)}°"; 
    query("#sample_text_id3")..text   = " Avg Movement : ${glassMotion.movement.toStringAsFixed(3)}"; 
  });

}