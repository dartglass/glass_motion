part of glass_motion;

class MotionHandler{
  
  static const avgMovementSampleSize = 20;
  static const avgDeltaSampleSize = 10;
  static const avgAccelerationSampleSize = 1000;
  static const tweekyVectorThreshold = 10;
  
  double get acceleration => accelerationVector.length;
  double get roll => Math.atan(accelerationVectorNormalized.x/(-accelerationVectorNormalized.y))*radians2degrees;
  double get pitch => Math.atan(accelerationVectorNormalized.z/(-accelerationVectorNormalized.y))*radians2degrees;
  //double get pitch => Math.atan((accelerationVectorNormalized.x*accelerationVectorNormalized.x + (accelerationVectorNormalized.y)*(accelerationVectorNormalized.y))/accelerationVectorNormalized.z)*radians2degrees;
  
  int updateRate;
  int _previousTimestamp;
  int _skipCount;
  
  Vector3 accelerationVector;
  Vector3 accelerationVectorDelta;
  Vector3 accelerationVectorNormalized;
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

    if(_vector.length2 < tweekyVectorThreshold){ // Compensate for Google glass tweeky acceleration values
      print("Tweeky Vector ${_vector.toString()} ${_vector.length2} ");
      return;
    }
    
    updateRate = event.timeStamp - _previousTimestamp;
    _previousTimestamp = event.timeStamp;
    
    accelerationVectorDelta = _vector.clone().sub(accelerationVector);
    accelerationVectorNormalized = _vector.clone().normalized();
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
  
  
}