part of glass_motion;

class MotionHandler{
  
  static const double timeConstant = 500.0;
  static const avgMovementSampleSize = 15;
  
  double _alpha;
  double _xRaw,_yRaw,_zRaw;
  double _gx,_gy,_gz;
  double x,y,z;
  
  List<double> accelerationHistory;
  
  double acceleration;
  
  int updateRate;
  int _previousTimestamp;
    
  bool gravityFilterEnable;
   
  MotionHandler(){
    _gx = 0.0;
    _gy = 0.0;
    _gz = 0.0;
    x = 0.0;
    y = 0.0;
    z = 0.0;
    _previousTimestamp = 0;
    acceleration = 0.0; 
    
    gravityFilterEnable = true;
    accelerationHistory = new List<double>();
  }
  
  
  bool onDeviceMotion(DeviceMotionEvent event){
    
    updateRate = event.timeStamp - _previousTimestamp;
    _previousTimestamp = event.timeStamp;

    _xRaw = event.accelerationIncludingGravity.x;
    _yRaw = event.accelerationIncludingGravity.y;
    _zRaw = event.accelerationIncludingGravity.z;
    
    // Enable if we want to filter the effects of gravity
    if(gravityFilterEnable){
       _alpha = timeConstant / (timeConstant + updateRate);
      
      _gx = (_alpha * _gx) + ((1 - _alpha) * _xRaw);
      _gy = (_alpha * _gy) + ((1 - _alpha) * _yRaw);
      _gz = (_alpha * _gz) + ((1 - _alpha) * _zRaw);
     
      x = _xRaw - _gx;
      y = _yRaw - _gy;
      z = _zRaw - _gz;
    }
    else{
      x = _xRaw;
      y = _yRaw;
      z = _zRaw;   
    }
    
    acceleration = Math.sqrt(x*x + y*y + z*z);
    
    accelerationHistory.add(acceleration);
    
    if(accelerationHistory.length > avgMovementSampleSize){
      accelerationHistory.removeAt(0);  
    }
    
    return true;
  }
  
  double getAvgMovement(){
    double accTotal = 0.0;
    
    for(double val in accelerationHistory){
      accTotal += val;    
    }
    return accTotal/accelerationHistory.length;
  }
  
  
}