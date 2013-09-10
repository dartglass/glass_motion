import 'dart:html';
import 'package:glass_motion/glass_motion.dart';

void main() {

  GlassMotion glassMotion = new GlassMotion(window);
  CanvasElement canvas = document.query('#canvas');

  ImageElement crosshairImage;

  num xPos = 0;
  num yPos = 0;

  crosshairImage = new Element.tag('img');
  crosshairImage.src = "images/crosshair_green.png";

  glassMotion.onMotion.listen((e){

    xPos = glassMotion.cursorX - (crosshairImage.width / 2);
    yPos = glassMotion.cursorY - (crosshairImage.height / 2);
    
    canvas.context2D.clearRect(0,0,canvas.width,canvas.height);

    if(glassMotion.accelerationDelta2 > 0.05){
      crosshairImage.src = "images/crosshair_white.png";
    }
    else{
      crosshairImage.src = "images/crosshair_green.png";
    }
    
    canvas.context2D.drawImage(crosshairImage, xPos, yPos);
  });

}