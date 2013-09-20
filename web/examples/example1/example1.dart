import 'dart:html';

import 'package:glass_motion/glass_motion.dart';

void main() {
  GlassMotion glassMotion = new GlassMotion(window);

  glassMotion.onMotion.listen((e){
    query("#sample_text_id")..text   = " Acceleration : ${glassMotion.acceleration.magnitude.toStringAsFixed(3)}";
    query("#sample_text_id2")..text   = " Roll : ${glassMotion.position.roll.toStringAsFixed(0)}° , Pitch: ${glassMotion.position.pitch.toStringAsFixed(0)}°";
    query("#sample_text_id3")..text   = "Acceleration ${glassMotion.acceleration.toString()}";
    query("#sample_text_id4")..text   = "Orientation ${glassMotion.orientation.toString()}";
    query("#sample_text_id5")..text   = "Movement ${glassMotion.movement.toString()}";
   });
}