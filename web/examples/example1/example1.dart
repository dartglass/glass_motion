import 'dart:html';

import 'package:glass_motion/glass_motion.dart';

void main() {
  
  GlassMotion glassMotion = new GlassMotion(window);
  
  query("#sample_text_id")..text   = "Test";
  
  glassMotion.onMotionUpdate = ((e){
    query("#sample_text_id")..text   = " Acceleration : "..appendText(glassMotion.acceleration.toStringAsFixed(3)); 
    query("#sample_text_id2")..text   = " Movement : "..appendText(glassMotion.movement.toStringAsFixed(3)); 
  });

}