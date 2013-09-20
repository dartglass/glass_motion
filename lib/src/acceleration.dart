part of glass_motion;

class Acceleration
{
  static const tweekyVectorThresholdMin = 10;
  static const tweekyVectorThresholdMax = 1500;

  Vector3 vector = new Vector3(0.0, 0.0, 0.0);
  Vector3 vectorPrevious = new Vector3(0.0, 0.0, 0.0);
  Vector3 gravity = new Vector3(0.0, 0.0, 0.0);
  Vector3 linearAcceleration = new Vector3(0.0, 0.0, 0.0);

  int timeStamp = 0;
  int previousTimeStamp = 0;

  num get x => vector.x;
  num get y => vector.y;
  num get z => vector.z;

  num get dx => vector.x - vectorPrevious.x;
  num get dy => vector.y - vectorPrevious.y;
  num get dz => vector.z - vectorPrevious.z;

  /** delta time */
  num get dT => timeStamp - previousTimeStamp;

  /** The magnitude of the acceleration vector*/
  num get magnitude => vector.length;

  /** The magnitude of the acceleration vector squared*/
  num get magnitude2 => vector.length2;

  /** The magnitude of the change in the acceleration vector*/
  num get magnitudeDelta => vectorDelta.length;

  /** The magnitude of the change in the acceleration vector squared*/
  num get magnitudeDelta2 => vectorDelta.length2;

  Vector3 get vectorDelta => vector.clone().sub(vectorPrevious);

  Acceleration();

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

    // If no change in time return (first run)
    if(dT == 0) return false;

    num length2 = vector.length2;

//    // Compensate for Google glass tweeky acceleration values
//    if(length2 < tweekyVectorThresholdMin || length2 > tweekyVectorThresholdMax){
//      print("Tweeky Vector: ${vector.toString()} ${length2.toString()}");
//      vectorPrevious.copyInto(vector);
//      return false;
//    }

    // calculate gravity
    gravity.scale(0.8).add(vector.scale(0.2));

    // Subtract gravity to get linear acceleration
    linearAcceleration = vector.sub(gravity);

    return true;
  }

  String toString() => "[${vector.x.toStringAsFixed(3)},${vector.y.toStringAsFixed(3)},${vector.z.toStringAsFixed(3)}]";
}

