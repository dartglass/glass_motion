import 'dart:html';
import 'package:glass_motion/glass_motion.dart';

void main() {

  GlassMotion glassMotion = new GlassMotion(window);
  CanvasElement canvas = document.query('#canvas');

  ImageElement crosshairImage;

  num xPos = 0;
  num yPos = 0;
  
  num pitch = 0;
  num roll = 0;

  crosshairImage = new Element.tag('img');
  crosshairImage.src = "images/crosshair_green.png";
  
  glassMotion.onMotion.listen((e){
    roll = glassMotion.position.roll;
    pitch = glassMotion.position.pitch;
    
    final num width = canvas.width;
    final num height = canvas.height;
    
    num cursorX = (((roll / 60) * width) + (width / 2)).clamp(0, width);
    num cursorY = (((pitch / 60) * height) + (height / 2)).clamp(0, height);
    
    xPos = cursorX - (crosshairImage.width / 2);
    yPos = cursorY - (crosshairImage.height / 2);
    
    canvas.context2D.clearRect(0,0,canvas.width,canvas.height);

    if(glassMotion.movement.amount > 0.05){
      crosshairImage.src = "images/crosshair_white.png";
    }
    else{
      crosshairImage.src = "images/crosshair_green.png";
    }
    
    canvas.context2D.drawImage(crosshairImage, xPos, yPos);
  });
  
  


}


