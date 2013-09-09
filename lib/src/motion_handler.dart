part of glass_motion;

class MotionHandler{
  
  static const avgMovementSampleSize = 20;
  static const tweekyVectorThreshold = 10;
  
  List<double> accelerationHistory;
  
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
   
  MotionHandler(){
    _previousTimestamp = 0;
    accelerationHistory = new List<double>();
    
    accelerationVector = new Vector3(0.0, 0.0, 0.0);
    accelerationVectorDelta = new Vector3(0.0, 0.0, 0.0);

    _vector = new Vector3(0.0, 0.0, 0.0);
  }
  
  
  void onDeviceMotion(DeviceMotionEvent event){
    _vector.setValues(event.accelerationIncludingGravity.x, event.accelerationIncludingGravity.y, event.accelerationIncludingGravity.z);

    if(_vector.length2 < tweekyVectorThreshold){ // Compensate for Google glass tweeky acceleration values
      print("Tweeky Vector ${_vector.toString()} ${_vector.length2} ");
      return;
    }
    
    updateRate = event.timeStamp - _previousTimestamp;
    _previousTimestamp = event.timeStamp;
    
    accelerationVectorDelta = _vector.clone().sub(accelerationVector);
    accelerationVector = _vector.clone();

    accelerationVectorNormalized = accelerationVector.normalized();
    
    //print("${_vector.x.toString()},${_vector.y.toString()},${_vector.z.toString()},${updateRate.toString()},${_vector.length2}");
   
  }
  
  double getAvgMovement(){
    double accTotal = 0.0;
    
    for(double val in accelerationHistory){
      accTotal += val;    
    }
    return accTotal/accelerationHistory.length;
  }
  
  
}