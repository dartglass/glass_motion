import 'dart:html';
import 'package:glass_motion/glass_motion.dart';

void main() {
  GlassMotion glassMotion = new GlassMotion(window);
  CanvasElement canvas = document.query('#canvas');
  CanvasRenderingContext2D context = canvas.context2D;

  final num pitchRange = 60;
  final num pitchOffset = pitchRange / 2;

  final num rollRange = 60;
  final num rollOffset = rollRange / 2;

  final num width = canvas.width;
  final num height = canvas.height;

  final num xScale = width / rollRange;
  final num xOffset = (xScale * rollOffset);

  final num yScale = height / pitchRange;
  final num yOffset = (yScale * pitchOffset);

  // start at center
  num prevx = (canvas.width / 2);
  num prevy = (canvas.height / 2);

  num roll = 0;
  num pitch = 0;
  num movement = 0;

  context
  ..moveTo((canvas.width / 2), (canvas.height / 2))
  ..strokeStyle = "black";

  window.onScroll.listen((e) =>
    context.clearRect(0, 0, canvas.width, canvas.height));

  glassMotion.onMotion.listen((e){
    movement = glassMotion.movement.amount;

    if(movement > 3.0){
      context.clearRect(0, 0, canvas.width, canvas.height);
    }

    roll = glassMotion.position.roll;
    pitch = glassMotion.position.pitch;

    num cursorX = ((roll * xScale) + xOffset).clamp(0, width);
    num cursorY = ((pitch * yScale) + yOffset).clamp(0, height);

    // draw to new head postion;
    context
    ..beginPath()
    ..moveTo(prevx, prevy)
    ..lineTo(cursorX, cursorY)
    ..stroke()
    ..closePath();

    prevx = cursorX;
    prevy = cursorY;
  });
}