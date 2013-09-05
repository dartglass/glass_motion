import 'dart:html';
import 'dart:math' as Math;

import 'package:glass_motion/glass_motion.dart';

void main() {
  
  GlassMotion glassMotion = new GlassMotion(window);
  CanvasElement canvas = document.query('#canvas');
  ImageElement testImage;
 
  num yawRangeMin = -30;
  num yawRangeMax = 30;
  num tiltRangeMin = -30;
  num tiltRangeMax = 30;
  
  testImage = new Element.tag('img');
  testImage.src = "images/cross_hair.png";
  
  glassMotion.onMotionUpdate = ((e){

    num xPos =  (glassMotion.yaw / (yawRangeMax-yawRangeMin)) * canvas.width - (testImage.width / 2) + (canvas.width / 2);
    num yPos =  (glassMotion.tilt / (tiltRangeMax-tiltRangeMin)) * canvas.height - (testImage.height / 2) + (canvas.height / 2);
  
//    print("$xPos,$yPos  ${glassMotion.tilt},${glassMotion.yaw}");

    canvas.context2D.clearRect(0,0,canvas.width,canvas.height);
    canvas.context2D.drawImage(testImage, xPos, yPos);
    
  });

}