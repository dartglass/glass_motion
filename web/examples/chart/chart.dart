import 'dart:html';
import 'package:glass_motion/glass_motion.dart';
import 'package:vector_math/vector_math.dart';

void main() {

  GlassMotion glassMotion = new GlassMotion(window);
  CanvasElement canvas = document.query('#canvas');

  List<Vector3> buffer = new List<Vector3>();
  
  var ctx = canvas.context2D;
  
  final num width = canvas.width;
  final num height = canvas.height;
  
  final double scaleVal = height;
  
  draw() {
    if(buffer.isEmpty) return;
    ctx.clearRect(0,0,width,height);
    
    ctx.lineWidth = 2;
    
    ctx.beginPath();
    ctx.strokeStyle = "red";
    ctx.moveTo(0, buffer.first.x);
    int xPos = 0;
    for(Vector3 val in buffer){
      ctx.lineTo(xPos, val.x);
      xPos+=1;
    }
    ctx.stroke(); 
    ctx.closePath();
    
    ctx.beginPath();
    ctx.strokeStyle = "green";
    ctx.moveTo(0, buffer.first.y);
    xPos = 0;
    for(Vector3 val in buffer){
      ctx.lineTo(xPos, val.y);
      xPos+=1;
    }
    ctx.stroke();   
    ctx.closePath();
    
    ctx.beginPath();
    ctx.strokeStyle = "blue";
    ctx.moveTo(0, buffer.first.z);
    xPos = 0;
    for(Vector3 val in buffer){
      ctx.lineTo(xPos, val.z);
      xPos+=1;
    }
    ctx.stroke();   
    ctx.closePath();
  }
  
  void animate(num highResTime) {
    if(highResTime >= 16) {
      draw();    
    }
    window.requestAnimationFrame(animate);
  }
  window.requestAnimationFrame(animate);
 
  glassMotion.onOrientation.listen((e){
    Vector3 val = glassMotion.orientation.axis.clone().normalized();
    val.scale(scaleVal);
    buffer.add(val);
    if(buffer.length > width){
      buffer.removeAt(0);
    }  
  });
}


