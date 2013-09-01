part of glass_motion;

class MotionHandler{
  
  static const double timeConstant = 500.0;
  double _alpha;
  double _xRaw,_yRaw,_zRaw;
  double _gx,_gy,_gz;
  double _x,_y,_z;
  
  double acceleration;
  
  int updateRate;
  int previousTimestamp;
  
  bool gravityFilterEnable;
   
  MotionHandler(){
    _gx = 0.0;
    _gy = 0.0;
    _gz = 0.0;
    _x = 0.0;
    _y = 0.0;
    _z = 0.0;
    
    gravityFilterEnable = true;
  }
  
  onDeviceMotion(DeviceMotionEvent event){
    
    updateRate = event.timeStamp - previousTimestamp;
    previousTimestamp = event.timeStamp;
       
    _xRaw = event.accelerationIncludingGravity.x;
    _yRaw = event.accelerationIncludingGravity.y;
    _zRaw = event.accelerationIncludingGravity.z;
    
    // Enable if we want to filter the effects of gravity
    if(gravityFilterEnable){
       _alpha = timeConstant / (timeConstant + updateRate);
      
      _gx = (_alpha * _gx) + ((1 - _alpha) * _xRaw);
      _gy = (_alpha * _gy) + ((1 - _alpha) * _yRaw);
      _gz = (_alpha * _gz) + ((1 - _alpha) * _zRaw);
     
      _x = _xRaw - _gx;
      _y = _yRaw - _gy;
      _z = _zRaw - _gz;
    }
    else{
      _x = _xRaw;
      _y = _yRaw;
      _z = _zRaw;   
    }
    
    acceleration = Math.sqrt(_x*_x + _y*_y + _z*_z);
    
  }
  
}