library glass_motion;

import 'dart:html';
import 'dart:async';
import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart';

class GlassMotion 
{
  static const avgMovementSampleSize = 20;
  static const avgDeltaSampleSize = 10;
  static const avgAccelerationSampleSize = 1000;
  static const tweekyVectorThreshold = 10;
  
  int _updateRate = 0;
  int _previousTimestamp = 0;
  
  Vector3 accelerationVector = new Vector3(0.0, 0.0, 0.0);
  Vector3 accelerationVectorDelta = new Vector3(0.0, 0.0, 0.0);
  Orientation orientation = new Orientation(0.0, 0.0, 0.0);
  
  List<Vector3> accelerationHistory = new List<Vector3>();
  List<Vector3> accelerationDeltaHistory = new List<Vector3>();

  Window _window;

  Stream onMotion; // called when there is a motion update
  StreamController streamController = new StreamController();
  
  Calibration calibration = new Calibration();

  /** Number of milliseconds since last position update */
  int get deltaTime => _updateRate;
  
  /** Returns the magnitude of the acceleration vector */
  double get acceleration => accelerationVector.length;
  
  /** The magnitude of the change in the acceleration vector */
  double get accelerationDelta => accelerationVectorDelta.length;

  /** The magnitude of the change in the acceleration vector squared*/
  double get accelerationDelta2 => accelerationVectorDelta.length2;
   
  /** The amount of movement */
  double get movement => _getMovement();
  
  /** Angle of the head roll (tilt side to side) */
  double get roll => Math.atan(accelerationVector.x / (-accelerationVector.y))
                               * radians2degrees;
   
  /** Angle of the head pitch (tilt up and down) */
  double get pitch => Math.atan(accelerationVector.z / (-accelerationVector.y))
                                * radians2degrees;
  
  final num displayWidth = 420;
  final num displayHeight = 240;
  
  num get cursorX => (((roll / calibration.roll.range) * displayWidth) + 
                       (displayWidth / 2)).clamp(0, displayWidth);
  
  num get cursorY => (((pitch / calibration.pitch.range) * displayHeight) +
                       (displayHeight / 2)).clamp(0, displayHeight);
  
  
 GlassMotion(this._window){
   onMotion = streamController.stream;
   _window.onDeviceMotion.listen((e) => _onDeviceMotion(e));
   _window.onDeviceOrientation.listen((e) => _onDeviceOrientation(e));
 }
 
 /** Handle the device motion event */
  _onDeviceMotion(DeviceMotionEvent event){
    if(!streamController.hasListener) return;
    if(streamController.isPaused) return;
    
    Vector3 vector = new Vector3(event.accelerationIncludingGravity.x, 
                                 event.accelerationIncludingGravity.y, 
                                 event.accelerationIncludingGravity.z);

    // Compensate for Google glass tweeky acceleration values
    if(vector.length2 < tweekyVectorThreshold){
      print("Tweeky Vector: ${vector.toString()}");
      return;
    }
    
    // Calculate how many milliseconds since last update
    _updateRate = event.timeStamp - _previousTimestamp;
    _previousTimestamp = event.timeStamp;
    
    accelerationVectorDelta = vector.clone().sub(accelerationVector);
    accelerationVector = vector.clone();
  
    _addAccelerationDeltaHistory(accelerationVectorDelta);
    _addAccelerationHistory(accelerationVector);

    streamController.add(onMotion); // Send off our motion event update
  }
  
  /** Handle the device orientation event */
  _onDeviceOrientation(DeviceOrientationEvent event){ 
    orientation.setValuesFromEvent(event);

    //streamController.add(onMotion);
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
  
  /** Add to our acceleration vector history */
  _addAccelerationHistory(Vector3 v){
    accelerationHistory.add(v);
    if(accelerationHistory.length > avgAccelerationSampleSize){
      accelerationHistory.removeAt(0);
    }
  }
  
  /** Add to our delta vector history */
  _addAccelerationDeltaHistory(Vector3 v){
    accelerationDeltaHistory.add(v);
    if(accelerationDeltaHistory.length > avgDeltaSampleSize){
      accelerationDeltaHistory.removeAt(0);  
    }
  }

}

class Calibration
{
  CalibrationLimits roll = new CalibrationLimits(-30,30); 
  CalibrationLimits pitch = new CalibrationLimits(-30,30); 
  Calibration();
}

class CalibrationLimits
{
  num min;
  num max;
  CalibrationLimits(this.min, this.max);
  
  num get range => max-min;
}


class Orientation
{
  bool absolute;
  num alpha;    //motion of the device around the z axis (degrees)
  num beta;     //motion of the device around the x axis (degrees)
  num gamma;    //motion of the device around the y axis (degrees)
  
  num previousAlpha;
  num previousBeta;
  num previousGamma;
  
  int timeStamp = 0;
  int previousTimeStamp = 0;
  
  get interval => timeStamp - previousTimeStamp;
  get alphaDelta => alpha - previousAlpha; 
  get betaDelta => beta - previousBeta; 
  get gammaDelta => gamma - previousGamma; 
  
  Orientation(this.alpha, this.beta, this.gamma){
    previousAlpha = alpha;
    previousBeta = beta;
    previousGamma = gamma;
  }
  
  void setValues(num a, num b, num g){
    previousAlpha = alpha;
    previousBeta = beta;
    previousGamma = gamma;
    
    alpha = a; 
    beta = b;
    gamma = g;
  }
  
  void setValuesFromEvent(DeviceOrientationEvent event){
    previousAlpha = alpha;
    previousBeta = beta;
    previousGamma = gamma;
    previousTimeStamp = timeStamp; 
    
    absolute = event.absolute;
    alpha = event.alpha; 
    beta = event.beta;
    gamma = event.gamma;
    timeStamp = event.timeStamp;
  }
  
  String toString() => "[${alpha.toStringAsFixed(1)},${alpha.toStringAsFixed(1)},${alpha.toStringAsFixed(1)}]";
}

