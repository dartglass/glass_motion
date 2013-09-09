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
  
  num roll = 0;
  num pitch = 0;
  
  num xPos = 0;
  num yPos = 0;
  
  crosshairGreen = new Element.tag('img');
  crosshairGreen.src = "images/crosshair_green.png";
  
  crosshairRed = new Element.tag('img');
  crosshairRed.src = "images/crosshair_red.png";
  
  crosshairWhite = new Element.tag('img');
  crosshairWhite.src = "images/crosshair_white.png";
  
  glassMotion.onMotionUpdate = ((e){
    roll = glassMotion.roll * 0.2 + roll * 0.8;
    pitch = glassMotion.pitch * 0.2 + pitch * 0.8; 
    
    xPos =  ((glassMotion.roll / (yawRangeMax-yawRangeMin)) * canvas.width - (crosshairGreen.width / 2) + (canvas.width / 2)).clamp(- (crosshairGreen.width / 2), canvas.width- (crosshairGreen.width / 2));
    yPos =  ((glassMotion.pitch / (tiltRangeMax-tiltRangeMin)) * canvas.height - (crosshairGreen.height / 2) + (canvas.height / 2)).clamp(- (crosshairGreen.width / 2), canvas.height- (crosshairGreen.width / 2));
  
    canvas.context2D.clearRect(0,0,canvas.width,canvas.height);
    
    if(glassMotion.movement > 2){
        canvas.context2D.drawImage(crosshairGreen, xPos, yPos);
    }
    else{
      canvas.context2D.drawImage(crosshairRed, xPos, yPos);
    }
    
  });

}