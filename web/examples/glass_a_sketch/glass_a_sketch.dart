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
  
  num roll = 0;
  num pitch = 0;
  num movement = 0;
      
  canvas.context2D.strokeStyle = "black";
  
  window.onScroll.listen((e){
    canvas.context2D.clearRect(0, 0, canvas.width, canvas.height);
  });

  glassMotion.onMotion.listen((e){
    movement = glassMotion.movement;
    
    if(movement > 3.0){
      canvas.context2D.clearRect(0, 0, canvas.width, canvas.height);
    }
    
    roll = (glassMotion.roll * 0.2) + roll * 0.8; // Add some smoothing
    pitch = (glassMotion.pitch * 0.2) + pitch * 0.8;
    
    xPos =  (roll / (yawRangeMax-yawRangeMin)) * canvas.width + (canvas.width / 2);
    yPos =  (pitch / (tiltRangeMax-tiltRangeMin)) * canvas.height + (canvas.height / 2);
    
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