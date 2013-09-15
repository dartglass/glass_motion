part of glass_motion;

class Orientation
{
  Vector3 axis = new Vector3(0.0,0.0,0.0);
  Vector3 axisPrevious = new Vector3(0.0,0.0,0.0);
  Vector3 axisNormalized = new Vector3(0.0,0.0,0.0);

  Quaternion deltaRotation = new Quaternion(0.0,0.0,0.0,0.0);
 
  Matrix3 rotationMatrix = new Matrix3(1.0, 0.0, 0.0,
                                       0.0, 1.0, 0.0,
                                       0.0, 0.0, 1.0);
  
  int timeStamp = 0;
  int previousTimeStamp = 0;
  
  num get axisX => axis.x;  
  num get axisY => axis.y;  
  num get axisZ => axis.z;  
  
  /** motion of the device around the x axis (degrees) */
  num get beta => axis.x;  
  
  /** motion of the device around the y axis (degrees) */
  num get gamma => axis.y;
  
  /** motion of the device around the z axis (degrees) */
  num get alpha => axis.z; 
  
  /** delta time */
  num get dT => timeStamp - previousTimeStamp;
  
  /** Magnitude of the orientation axis */
  num get magnitude => axis.length;
  
  Matrix3 gyroMatrix = new Matrix3(1.0, 0.0, 0.0,
      0.0, 1.0, 0.0,
      0.0, 0.0, 1.0);
  
  Orientation();
  
  void setValues(num x_, num y_, num z_){
    axis.copyInto(axisPrevious);
    axis.x = x_; 
    axis.y = y_;
    axis.z = z_;
  }
  
  void setValuesFromEvent(DeviceOrientationEvent event){
    axis.copyInto(axisPrevious);
   
    previousTimeStamp = timeStamp; 
    timeStamp = event.timeStamp;
    
    axis.x = event.beta;
    axis.y = event.gamma;
    axis.z = event.alpha;
    
    axis.copyInto(axisNormalized);
    
    if(dT == 0) return; // if delta time change then return
    
    if(magnitude > 0.000001) axisNormalized.normalize();

    // Integrate around this axis with the angular speed by the timestep
    // in order to get a delta rotation from this sample over the timestep
    // http://developer.android.com/reference/android/hardware/SensorEvent.html#values

    num thetaOverTwo = magnitude * dT / 2.0;
    num sinThetaOverTwo = Math.sin(thetaOverTwo);
    num cosThetaOverTwo = Math.cos(thetaOverTwo);
    
    // set axis-angle representation of the delta rotation quaternion
    deltaRotation.x = sinThetaOverTwo * axisNormalized.x;
    deltaRotation.y = sinThetaOverTwo * axisNormalized.y;
    deltaRotation.z = sinThetaOverTwo * axisNormalized.z;
    deltaRotation.w = cosThetaOverTwo;
    
    deltaRotation.asRotationMatrix().copyInto(rotationMatrix);
    
    gyroMatrix = gyroMatrix * rotationMatrix;

  }
  
  String toString() => "[${axis.x.toStringAsFixed(1)},${axis.y.toStringAsFixed(1)},${axis.z.toStringAsFixed(1)}]";
}
