part of glass_motion;

class MotionHandler{
  
  static const double timeConstant = 500.0;
  static const avgMovementSampleSize = 20;
  
  double _alpha;
  double _xRaw,_yRaw,_zRaw;
  double _gx,_gy,_gz;
  double x,y,z;
  
  List<double> accelerationHistory;
  
  double get acceleration => accelerationVectorGravityComp.length;
  double get yaw => Math.atan(accelerationVectorNormalized.x/(-accelerationVectorNormalized.y))*radians2degrees;
  double get pitch => Math.atan((accelerationVectorNormalized.x*accelerationVectorNormalized.x + (accelerationVectorNormalized.y)*(accelerationVectorNormalized.y))/accelerationVectorNormalized.z)*radians2degrees;
  double get tilt => Math.atan(accelerationVectorNormalized.z/(-accelerationVectorNormalized.y))*radians2degrees;
  
  int updateRate;
  int _previousTimestamp;
  
  Vector3 accelerationVector;
  Vector3 accelerationVectorGravityComp;
  Vector3 accelerationVectorNormalized;
  Vector3 accelerationVectorSmoothed;
    
  bool gravityFilterEnable;
   
  MotionHandler(){
    _gx = 0.0;
    _gy = 0.0;
    _gz = 0.0;
    x = 0.0;
    y = 0.0;
    z = 0.0;
    _previousTimestamp = 0;
    
    gravityFilterEnable = true;
    accelerationHistory = new List<double>();
    
    accelerationVector = new Vector3(0.0, 0.0, 0.0);
    accelerationVectorGravityComp = new Vector3(0.0, 0.0, 0.0);
    accelerationVectorSmoothed = new Vector3(0.0, 0.0, 0.0);
    accelerationVectorNormalized = new Vector3(0.0, 0.0, 0.0);
  }
  
  
  bool onDeviceMotion(DeviceMotionEvent event){
    
    updateRate = event.timeStamp - _previousTimestamp;
    _previousTimestamp = event.timeStamp;

    _xRaw = event.accelerationIncludingGravity.x;
    _yRaw = event.accelerationIncludingGravity.y;
    _zRaw = event.accelerationIncludingGravity.z;
    
    accelerationVector.setValues(_xRaw, _yRaw, _zRaw);
    
    accelerationVectorNormalized = accelerationVector.normalized();
    
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
    
    accelerationVectorGravityComp.setValues(x, y, z);
    
    accelerationHistory.add(accelerationVectorGravityComp.length);//Math.sqrt(x*x + y*y + z*z)
    
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