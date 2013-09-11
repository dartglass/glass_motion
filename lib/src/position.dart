part of glass_motion;

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