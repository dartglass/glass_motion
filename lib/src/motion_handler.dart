part of glass_motion;

class MotionHandler{
  
  static const avgMovementSampleSize = 20;
  static const avgDeltaSampleSize = 10;
  static const avgAccelerationSampleSize = 1000;
  static const tweekyVectorThreshold = 10;
  
  int updateRate;
  int _previousTimestamp;
  int _skipCount;
  
  Vector3 accelerationVector;
  Vector3 accelerationVectorDelta;
  Vector3 _vectorN;
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
  
  
  void onDeviceMotion(DeviceMotionEvent event){
    _vector.setValues(event.accelerationIncludingGravity.x, 
                      event.accelerationIncludingGravity.y, 
                      event.accelerationIncludingGravity.z);

    // Compensate for Google glass tweeky acceleration values
    if(_vector.length2 < tweekyVectorThreshold) return;
    
    updateRate = event.timeStamp - _previousTimestamp;
    _previousTimestamp = event.timeStamp;
    
    accelerationVectorDelta = _vector.clone().sub(accelerationVector);
    _vectorN = _vector.clone().normalized();
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
  }
  
  double getMovement(){
    double totalMagnitude = 0.0;
    int count = accelerationDeltaHistory.length;
    
    if(count < 1) return 0.0;
    
    for(Vector3 v in accelerationDeltaHistory){
      totalMagnitude += v.length;    
    }
    return totalMagnitude/count;
  }
  
  double getAcceleration(){
    return accelerationVector.length;
  }
  
  double getRoll(){
    return  Math.atan(_vectorN.x / (-_vectorN.y)) * radians2degrees;
  }
  
  double getPitch(){
    return Math.atan(_vectorN.z / (-_vectorN.y)) * radians2degrees;
  }
  
}