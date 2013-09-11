part of glass_motion;

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
