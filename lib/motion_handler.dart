part of glass_motion;

class MotionHandler{
  
  int updateRate;
  int previousTimestamp;
  
  MotionHandler(){
    
  }
  
  onDeviceMotion(DeviceMotionEvent event){
    
    updateRate = event.timeStamp - previousTimestamp;
    previousTimestamp = event.timeStamp;
       
    
  }
  
}