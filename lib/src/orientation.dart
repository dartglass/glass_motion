part of glass_motion;

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
