part of glass_motion;

class MotionHandler{

  static const double timeConstant = 500.0; // For gravity Compensation update intervals > then timeConstant will correct faster
  static const avgMovementSampleSize = 20;
  static const tweekyVectorThreshold = 10;

  double _alpha;
  List<double> accelerationHistory;

  double get acceleration => _gravityComp.length;

  double get yaw => Math.atan(accelerationVectorNormalized.x /
      (-accelerationVectorNormalized.y)) * radians2degrees;

  double get pitch => Math.atan((accelerationVectorNormalized.x *
                                 accelerationVectorNormalized.x +
                                 (accelerationVectorNormalized.y) *
                                 (accelerationVectorNormalized.y)) /
                                 accelerationVectorNormalized.z) *
                                 radians2degrees;

  double get tilt => Math.atan(accelerationVectorNormalized.z /
      (-accelerationVectorNormalized.y))*radians2degrees;

  int updateRate;
  int _previousTimestamp;
  int _skipCount;

  Vector3 accelerationVector;
  Vector3 accelerationVectorPrevious;
  Vector3 accelerationVectorDelta;
  Vector3 accelerationVectorDeltaSum;
  Vector3 accelerationVectorNormalized;

  Vector3 accelerationVectorGravityCompensated;
  Vector3 _gravityComp; // Gravity Compensation vector
  Vector3 _vector;
  Vector3 accelerationVectorGravityCompOLD;

  MotionHandler(){
    _previousTimestamp = 0;
    accelerationHistory = new List<double>();

    accelerationVector = new Vector3(0.0, 0.0, 0.0);
    accelerationVectorPrevious = new Vector3(0.0, 0.0, 0.0);
    accelerationVectorNormalized = new Vector3(0.0, 0.0, 0.0);
    accelerationVectorGravityCompensated = new Vector3(0.0, 0.0, 0.0);
    accelerationVectorDelta = new Vector3(0.0, 0.0, 0.0);
    accelerationVectorDeltaSum = new Vector3(0.0, 0.0, 0.0);
    _gravityComp = new Vector3(0.0, 0.0, 0.0);
    _vector = new Vector3(0.0, 0.0, 0.0);
  }


  void onDeviceMotion(DeviceMotionEvent event){
    _vector.setValues(event.accelerationIncludingGravity.x,
        event.accelerationIncludingGravity.y,
        event.accelerationIncludingGravity.z);

    // Compensate for Google glass tweeky acceleration values
    if(_vector.length2 < tweekyVectorThreshold){
      print("Tweeky Vector ${_vector.toString()} ${_vector.length2} ");
      return;
    }

    updateRate = event.timeStamp - _previousTimestamp;
    _previousTimestamp = event.timeStamp;

    accelerationVector = _vector.clone();
    accelerationVectorDelta = _vector.clone().sub(accelerationVectorPrevious);
    accelerationVectorDeltaSum.add(accelerationVectorDelta);
    accelerationVectorPrevious = accelerationVector.clone();
    accelerationVectorNormalized = accelerationVector.normalized();

    //print("${_vector.x.toString()},${_vector.y.toString()},${_vector.z.toString()},${updateRate.toString()},${_vector.length2}");

    // Do Gravity Compensation
    // Calculate how fast we need to compensante faster
    // if updateRate > timeConstant
    _alpha = timeConstant / (timeConstant + updateRate);
    _gravityComp.scale(_alpha);
    _gravityComp.add(accelerationVector.clone().scaled(1-_alpha));
    accelerationVectorGravityCompensated =
        accelerationVector.clone().sub(_gravityComp);

    // Buffer Gravity Vector
    accelerationHistory.add(accelerationVectorGravityCompensated.length);
    if(accelerationHistory.length > avgMovementSampleSize){
      accelerationHistory.removeAt(0);
    }
  }

  double getAvgMovement(){
    double accTotal = 0.0;

    for(double val in accelerationHistory){
      accTotal += val;
    }
    return accTotal/accelerationHistory.length;
  }


}