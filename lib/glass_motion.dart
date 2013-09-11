library glass_motion;

import 'dart:html';
import 'dart:async';
import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart';

class GlassMotion 
{
  static const tweekyVectorThreshold = 10;
  
  Orientation orientation = new Orientation(0.0, 0.0, 0.0);
  Acceleration acceleration = new Acceleration(0.0, 0.0, 0.0);
  Calibration calibration = new Calibration();
  Position position;
  Movement movement;

  Window _window;

  Stream onMotion; // called when there is a motion update
  StreamController streamController = new StreamController();
  
 GlassMotion(this._window){
   onMotion = streamController.stream;
   _window.onDeviceMotion.listen((e) => _onDeviceMotion(e));
   _window.onDeviceOrientation.listen((e) => _onDeviceOrientation(e));
   
   position = new Position(orientation, acceleration, calibration);
   movement = new Movement(calibration);
 }
 
 /** Handle the device motion event */
  _onDeviceMotion(DeviceMotionEvent event){
    if(!streamController.hasListener) return;
    if(streamController.isPaused) return;
    
    if(acceleration.setValuesFromEvent(event)){
      movement.addDeltaVector(acceleration.vectorDelta);
      streamController.add(onMotion); // Send off our motion event update
    }
  }
  
  /** Handle the device orientation event */
  _onDeviceOrientation(DeviceOrientationEvent event){ 
    orientation.setValuesFromEvent(event);
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
  
  num get interval => timeStamp - previousTimeStamp;
  num get alphaDelta => alpha - previousAlpha; 
  num get betaDelta => beta - previousBeta; 
  num get gammaDelta => gamma - previousGamma; 
  
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

class Position
{
  Orientation orientation;
  Acceleration acceleration;
  Calibration calibration;
  
  Position(this.orientation, this.acceleration, this.calibration); 
  
  /** Angle of the head roll (tilt side to side) */
  double get roll => Math.atan(acceleration.vector.x / (-acceleration.vector.y))
                               * radians2degrees;
   
  /** Angle of the head pitch (tilt up and down) */
  double get pitch => Math.atan(acceleration.vector.z / (-acceleration.vector.y))
                                * radians2degrees;
  
  num displayWidth = 420;
  num displayHeight = 240;
  
  num get cursorX => (((roll / calibration.roll.range) * displayWidth) + 
                       (displayWidth / 2)).clamp(0, displayWidth);
  
  num get cursorY => (((pitch / calibration.pitch.range) * displayHeight) +
                       (displayHeight / 2)).clamp(0, displayHeight);
}

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
