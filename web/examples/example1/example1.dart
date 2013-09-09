import 'dart:html';

import 'package:glass_motion/glass_motion.dart';

void main() {
  
  GlassMotion glassMotion = new GlassMotion(window);
  
  query("#sample_text_id")..text   = "Test";
  
  glassMotion.onMotionUpdate = ((e){
    query("#sample_text_id")..text   = " Acceleration : ${glassMotion.accelerationDelta.toStringAsFixed(3)}"; 
    query("#sample_text_id2")..text   = " Roll : ${glassMotion.roll.toStringAsFixed(0)}° , Pitch: ${glassMotion.pitch.toStringAsFixed(0)}°"; 
    query("#sample_text_id3")..text   = " Avg Movement : ${glassMotion.movement.toStringAsFixed(3)}"; 
    
    //query("#sample_text_id4")..text   = "${glassMotion.accelerationV.toString()}";// Position: ${glassMotion.x.toStringAsFixed(1)}, ${glassMotion.y.toStringAsFixed(1)}, ${glassMotion.z.toStringAsFixed(1)}"; 
    //query("#sample_text_id4")..text   = " Position: ${glassMotion.x.toStringAsFixed(1)}, ${glassMotion.y.toStringAsFixed(1)}, ${glassMotion.z.toStringAsFixed(1)}"; 
  });

  window.onScroll.listen((e){
    glassMotion.zeroPosition();
  });
}