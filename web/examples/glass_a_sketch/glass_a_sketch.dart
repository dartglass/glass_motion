import 'dart:html';
import 'package:glass_motion/glass_motion.dart';

void main() {
  
  GlassMotion glassMotion = new GlassMotion(window);

  CanvasElement canvas = document.query('#canvas');
  ImageElement testImage;
 
  num yawRangeMin = -30;
  num yawRangeMax = 30;
  num tiltRangeMin = -30;
  num tiltRangeMax = 30;
  num xPos, yPos;
  
  canvas.context2D.moveTo((canvas.width / 2), (canvas.height / 2));
  
  // start at center
  num prevx = (canvas.width / 2);
  num prevy = (canvas.height / 2);
  
  num yaw = 0;
  num tilt = 0;
  num movement = 0;
      
  canvas.context2D.strokeStyle = "black";
  
  window.onScroll.listen((e){
    canvas.context2D.clearRect(0, 0, canvas.width, canvas.height);
  });

  glassMotion.onMotionUpdate = ((e){
    movement = glassMotion.movement;
    
    if(movement > 3.0){
      canvas.context2D.clearRect(0, 0, canvas.width, canvas.height);
    }
    
    yaw = (glassMotion.yaw * 0.2) + yaw * 0.8; // Add some smoothing
    tilt = (glassMotion.tilt * 0.2) + tilt * 0.8;
    
    xPos =  (yaw / (yawRangeMax-yawRangeMin)) * canvas.width + (canvas.width / 2);
    yPos =  (tilt / (tiltRangeMax-tiltRangeMin)) * canvas.height + (canvas.height / 2);
    
    // draw to new head postion;
    canvas.context2D.beginPath();
    canvas.context2D.moveTo(prevx, prevy);
    canvas.context2D.lineTo(xPos, yPos);
    canvas.context2D.stroke();
    
    canvas.context2D.closePath();
    
    prevx = xPos;
    prevy = yPos;

  });

}