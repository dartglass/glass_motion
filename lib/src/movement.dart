part of glass_motion;

class Movement
{
  static const avgMovementSampleSize = 20;
  static const avgDeltaSampleSize = 10;
  static const avgAccelerationSampleSize = 1000;

  List<Vector3> accelerationHistory = new List<Vector3>();
  List<Vector3> accelerationDeltaHistory = new List<Vector3>();

  Calibration calibration;

  /** The amount of movement */
  double get amount => _getMovement();

  Movement(this.calibration);

  String toString() => amount.toStringAsFixed(3);

  /** Get the average amount of movement as determined by the sample size */
  double _movement(int samples){
    if(accelerationDeltaHistory.isEmpty) return 0.0;

    int count = accelerationDeltaHistory.length;

    if(samples > count) samples = count;

    double totalMagnitude = 0.0;
    for(Vector3 v in accelerationDeltaHistory.getRange(count - samples, count)){
      totalMagnitude += v.length2;
    }
    return totalMagnitude / samples;
  }

  /** Get the average amount of movement as determined by the sample size */
  double _getMovement(){
    double totalMagnitude = 0.0;
    int count = accelerationDeltaHistory.length;

    if(count < 1) return 0.0;

    for(Vector3 v in accelerationDeltaHistory){
      totalMagnitude += v.length2;
    }
    return totalMagnitude/count;
  }


  /** Add to our acceleration vector history */
  addVector(Vector3 v){
    accelerationHistory.add(v);
    if(accelerationHistory.length > avgAccelerationSampleSize){
      accelerationHistory.removeAt(0);
    }
  }

  /** Add to our delta vector history */
  addDeltaVector(Vector3 v){
    if(v == null) return;
    accelerationDeltaHistory.add(v.clone());
    if(accelerationDeltaHistory.length > avgDeltaSampleSize){
      accelerationDeltaHistory.removeAt(0);
    }
  }
}