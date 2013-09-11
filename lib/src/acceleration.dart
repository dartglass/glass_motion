part of glass_motion;

class Acceleration
{
  static const tweekyVectorThresholdMin = 10;
  static const tweekyVectorThresholdMax = 1500;
  
  Vector3 vector;
  Vector3 vectorPrevious;
  int timeStamp = 0;
  int previousTimeStamp = 0;
  
  num get x => vector.x;
  num get y => vector.y;
  num get z => vector.z;
  
  num get xDelta => vector.x - vectorPrevious.x;
  num get yDelta => vector.y - vectorPrevious.y;
  num get zDelta => vector.z - vectorPrevious.z;
  
  num get interval => timeStamp - previousTimeStamp;
  
  /** The magnitude of the acceleration vector*/
  num get magnitude => vector.length;
  
  /** The magnitude of the acceleration vector squared*/
  num get magnitude2 => vector.length2;
  
  /** The magnitude of the change in the acceleration vector*/
  num get magnitudeDelta => vectorDelta.length;
  
  /** The magnitude of the change in the acceleration vector squared*/
  num get magnitudeDelta2 => vectorDelta.length2;
  
  Vector3 get vectorDelta => vector.clone().sub(vectorPrevious);
  
  Acceleration(num x_, num y_, num z_){
    vector = new Vector3(x_, y_, z_);
    vectorPrevious = new Vector3(x_, y_, z_);
  }
  
  void setValues(num x_, num y_, num z_){
    vector.x = x_;
    vector.y = y_;
    vector.z = z_; 
  }
  
  bool setValuesFromEvent(DeviceMotionEvent event){
    vector.copyInto(vectorPrevious); 
    
    vector.x = event.accelerationIncludingGravity.x;
    vector.y = event.accelerationIncludingGravity.y;
    vector.z = event.accelerationIncludingGravity.z;
    
    previousTimeStamp = timeStamp; 
    timeStamp = event.timeStamp;
    
    num length2 = vector.length2;

    // Compensate for Google glass tweeky acceleration values
    if(length2 < tweekyVectorThresholdMin || length2 > tweekyVectorThresholdMax){
      print("Tweeky Vector: ${vector.toString()} ${length2.toString()}");
      vectorPrevious.copyInto(vector);
      return false;
    }
    
    return true;
  }
  
  String toString() => "[${vector.x.toStringAsFixed(3)},${vector.y.toStringAsFixed(3)},${vector.z.toStringAsFixed(3)}]";
}

