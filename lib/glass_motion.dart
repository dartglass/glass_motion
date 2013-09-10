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
   
 }
 
  
 /** Handle the device motion event */
  _onDeviceMotion(DeviceMotionEvent event){
    if(!streamController.hasListener) return;
    if(streamController.isPaused) return;
    
    Vector3 vector = new Vector3(event.accelerationIncludingGravity.x, 
                                 event.accelerationIncludingGravity.y, 
                                 event.accelerationIncludingGravity.z);

    // Compensate for Google glass tweeky acceleration values
    if(vector.length2 < tweekyVectorThreshold) return false;
    
    // Calculate how many milliseconds since last update
    _updateRate = event.timeStamp - _previousTimestamp;
    _previousTimestamp = event.timeStamp;
    
    accelerationVectorDelta = vector.clone().sub(accelerationVector);
    accelerationVector = vector.clone();
  
    _addAccelerationDeltaHistory(accelerationVectorDelta);
    _addAccelerationHistory(accelerationVector);

    streamController.add(onMotion); // Send off our motion event update
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

