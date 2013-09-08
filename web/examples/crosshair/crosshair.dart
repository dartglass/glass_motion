import 'dart:html';
import 'package:glass_motion/glass_motion.dart';

void main() {
  
  GlassMotion glassMotion = new GlassMotion(window);
  CanvasElement canvas = document.query('#canvas');
  
  ImageElement crosshairGreen;
  ImageElement crosshairRed;
  ImageElement crosshairWhite;
 
  num yawRangeMin = -30;
  num yawRangeMax = 30;
  num tiltRangeMin = -30;
  num tiltRangeMax = 30;
  
  num yaw = 0;
  num tilt = 0;
  
  num xPos = 0;
  num yPos = 0;
  
  crosshairGreen = new Element.tag('img');
  crosshairGreen.src = "images/crosshair_green.png";
  
  crosshairRed = new Element.tag('img');
  crosshairRed.src = "images/crosshair_red.png";
  
  crosshairWhite = new Element.tag('img');
  crosshairWhite.src = "images/crosshair_white.png";
  
  glassMotion.onMotionUpdate = ((e){
    yaw = glassMotion.yaw * 0.2 + yaw * 0.8;
    tilt = glassMotion.tilt * 0.2 + tilt * 0.8; 
    
    xPos =  ((glassMotion.yaw / (yawRangeMax-yawRangeMin)) * canvas.width - (crosshairGreen.width / 2) + (canvas.width / 2)).clamp(- (crosshairGreen.width / 2), canvas.width- (crosshairGreen.width / 2));
    yPos =  ((glassMotion.tilt / (tiltRangeMax-tiltRangeMin)) * canvas.height - (crosshairGreen.height / 2) + (canvas.height / 2)).clamp(- (crosshairGreen.width / 2), canvas.height- (crosshairGreen.width / 2));
  
    canvas.context2D.clearRect(0,0,canvas.width,canvas.height);
    
    if(glassMotion.movement > 2){
        canvas.context2D.drawImage(crosshairGreen, xPos, yPos);
    }
    else{
      canvas.context2D.drawImage(crosshairRed, xPos, yPos);
    }
    
  });

}