import 'dart:html';
import 'dart:async';

import 'package:glass_motion/glass_motion.dart';

void main() {
  document.onKeyDown.listen((e){
    e.preventDefault();
    if(e.keyCode == 32){
      window.scrollBy(0, 555);
    }
  });
  
  // TODO: look into using pause instead.
  StreamSubscription<Event> scrollSubscription;
  bool movingScroll = false;
  int eventCount = 0;
  int height = 555;
  int slide = 1;
  
  _moveScroll(e) {
    print("_moveScroll:movingScroll = $movingScroll");
    eventCount++;
    if (eventCount > 25) {
      movingScroll = true;
      eventCount = 0;
    }

    if (movingScroll) {
      window.scrollTo(0, height*slide);
      slide++;
      movingScroll = false;
      eventCount = 0;
    }
  }
  
  GlassMotion glassMotion = new GlassMotion(window);
  double headTilt = 0.0;
 
  glassMotion.onMotionUpdate = ((e){
    headTilt = headTilt*0.8 + glassMotion.tilt*0.2;
  });
  
  int position = 0;
  
  void animate(num highResTime) {

    if(highResTime >= 16) {
      if(headTilt.abs() > 4.0){ // min angle to start tilt
        position -= headTilt/2;
        position = position.clamp(0, height*6);
        window.scrollTo(0, position);
      }  
    }
    window.requestAnimationFrame(animate);
  }
  
  window.requestAnimationFrame(animate);
  
  _onDoneScroll() {
    print("_onDoneScroll");
    scrollSubscription.cancel();
    movingScroll = true;
    scrollSubscription = window.onScroll.listen(_moveScroll, onDone: _onDoneScroll);
  }

  _registerScroll() {
    print("_registerScroll");
    scrollSubscription = window.onScroll.listen(_moveScroll, onDone: _onDoneScroll);
  };

  //_registerScroll();

}
