part of glass_motion;

class MotionHandler{
  
  static const avgMovementSampleSize = 20;
  static const avgDeltaSampleSize = 10;
  static const avgAccelerationSampleSize = 1000;
  static const tweekyVectorThreshold = 10;
  
  int updateRate;
  int _previousTimestamp;
  
  Vector3 accelerationVector;
  Vector3 accelerationVectorDelta;
  Vector3 _vector;
   
  List<Vector3> accelerationHistory;
  List<Vector3> accelerationDeltaHistory;
   
   MotionHandler(){
    _previousTimestamp = 0;
    
    accelerationHistory = new List<Vector3>();
    accelerationDeltaHistory = new List<Vector3>();
    accelerationVector = new Vector3(0.0, 0.0, 0.0);
    accelerationVectorDelta = new Vector3(0.0, 0.0, 0.0);

    _vector = new Vector3(0.0, 0.0, 0.0);
  }
  
  
  bool onDeviceMotion(DeviceMotionEvent event){
    
    _vector.setValues(event.accelerationIncludingGravity.x, 
                      event.accelerationIncludingGravity.y, 
                      event.accelerationIncludingGravity.z);

    // Compensate for Google glass tweeky acceleration values
    if(_vector.length2 < tweekyVectorThreshold) return false;
        
    // Calculate how many milliseconds sence last update
    updateRate = event.timeStamp - _previousTimestamp;
    _previousTimestamp = event.timeStamp;
    
    accelerationVectorDelta = _vector.clone().sub(accelerationVector);
    accelerationVector = _vector.clone();

    
    // Add to our delta history
    accelerationDeltaHistory.add(accelerationVectorDelta);
    if(accelerationDeltaHistory.length > avgDeltaSampleSize){
      accelerationDeltaHistory.removeAt(0);  
    }
    
    // Add to our acceleration history
    accelerationHistory.add(accelerationVector);
    if(accelerationHistory.length > avgAccelerationSampleSize){
      accelerationHistory.removeAt(0);
    }
    
    return true;
  }
  
  /** Get the average amount of movement as determined by the sample size */
  double getMovement(){
    double totalMagnitude = 0.0;
    int count = accelerationDeltaHistory.length;
    
    if(count < 1) return 0.0;
    
    for(Vector3 v in accelerationDeltaHistory){
      totalMagnitude += v.length2;    
    }
    return totalMagnitude/count;
  }
  
  /** get the magnitude of the instantaneous acceleration */
  double getInstantaneousAcceleration(){
    return accelerationVector.length;
  }
  
  /** get the magnitude of the instantaneous change in acceleration */
  double getDeltaAcceleration(){
    return accelerationVectorDelta.length2;// .length;
  }
  
  /** returns the angle of head roll in degrees */
  double getRoll(){
    return  Math.atan(_vector.x / (-_vector.y)) * radians2degrees;
  }
  
  /** returns the angle of head pitch in degrees */
  double getPitch(){
    return Math.atan(_vector.z / (-_vector.y)) * radians2degrees;
  }
  
}