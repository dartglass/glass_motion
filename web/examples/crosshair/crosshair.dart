import 'dart:html';
import 'package:glass_motion/glass_motion.dart';

void main() {
  GlassMotion glassMotion = new GlassMotion(window);
  CanvasElement canvas = document.query('#canvas');
  CanvasRenderingContext2D context = canvas.context2D;

  ImageElement  crosshairImage = new ImageElement()
  ..src = "images/crosshair_green.png";

  final num pitchRange = 30;
  final num pitchOffset = pitchRange / 2;

  final num rollRange = 30;
  final num rollOffset = rollRange / 2;

  final num width = canvas.width;
  final num height = canvas.height;

  final num xScale = width / rollRange;
  final num xOffset = (xScale * rollOffset);

  final num yScale = height / pitchRange;
  final num yOffset = (yScale * pitchOffset);

  num pitch, roll;
  num cursorX, cursorY;
  num x, y;

  // Listen for on motion events
  glassMotion.onMotion.listen((_){
    roll = glassMotion.position.roll;
    pitch = glassMotion.position.pitch;

    cursorX = ((roll * xScale) + xOffset).clamp(0, width);
    cursorY = ((pitch * yScale) + yOffset).clamp(0, height);

    x = cursorX - (crosshairImage.width / 2);
    y = cursorY - (crosshairImage.height / 2);
  });

  draw() => context
              ..clearRect(0,0,canvas.width,canvas.height)
              ..drawImage(crosshairImage, x, y);

  void animate(num highResTime) {
    if(highResTime >= 16) {
      draw();
    }
    window.requestAnimationFrame(animate);
  }
  window.requestAnimationFrame(animate);
}


