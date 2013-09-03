import 'dart:html';

import 'package:glass_motion/glass_motion.dart';

void main() {
  
  GlassMotion glassMotion = new GlassMotion(window);
  CanvasElement canvas = document.query('#canvas');
  ImageElement testImage;
 
  testImage = new Element.tag('img');
  testImage.src = "images/and.png";
  
  glassMotion.onMotionUpdate = ((e){
    num destX = canvas.width/2;
    num destY = canvas.height/2; 
    
    num offset = (glassMotion.yaw/60)*destX;
    
    canvas.context2D.clearRect(0,0,canvas.width,canvas.height);
    canvas.context2D.drawImage(testImage, destX + offset, destY);
  });

}