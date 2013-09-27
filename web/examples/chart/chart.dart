import 'dart:html';
import 'package:glass_motion/glass_motion.dart';
import 'package:vector_math/vector_math.dart';

void main() {

  GlassMotion glassMotion = new GlassMotion(window);
  CanvasElement canvas = document.query('#canvas');

  List<Vector3> buffer = new List<Vector3>();
  CanvasRenderingContext2D context = canvas.context2D;

  final num width = canvas.width;
  final num height = canvas.height;

  final String xColor = "red";
  final String yColor = "green";
  final String zColor = "blue";

  final double scaleVal = height;
  int xPos = 0;

  glassMotion.onOrientation.listen((_){
    Vector3 val = glassMotion.orientation.axis.clone().normalized();
    val.scale(scaleVal);
    buffer.add(val);
    if(buffer.length > width){
      buffer.removeAt(0);
    }
  });

  draw() {
    if(buffer.isEmpty) return;

    // Draw vector x axis
    xPos = 0;
    context
      ..clearRect(0,0,width,height)
      ..lineWidth = 2
      ..beginPath()
      ..strokeStyle = xColor
      ..moveTo(0, buffer.first.x);
    for(Vector3 val in buffer)
      context.lineTo(xPos++, val.x);
    context..stroke()..closePath();

    // Draw vector y axis
    xPos = 0;
    context
      ..beginPath()
      ..strokeStyle = yColor
      ..moveTo(0, buffer.first.y);
    for(Vector3 val in buffer)
      context.lineTo(xPos++, val.y);
    context..stroke()..closePath();

    // Draw vector z axis
    xPos = 0;
    context
      ..beginPath()
      ..strokeStyle = zColor
      ..moveTo(0, buffer.first.z);
    for(Vector3 val in buffer)
      context.lineTo(xPos++, val.z);
    context..stroke()..closePath();
  }

  void animate(num highResTime) {
    if(highResTime >= 16) {
      draw();
    }
    window.requestAnimationFrame(animate);
  }
  window.requestAnimationFrame(animate);
}


