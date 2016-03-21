# PMCNC
### Poor Man's CNC

This project inititially started with the concept of using a webcam mounted to a mill in such a way that it could view a drawing on a platform attached to the mill table. Using an application coded in [Processing](https://processing.org/) I could use the webcam to follow the drawing while cutting the part in the vice. After much work, I finally got to the point of making an actual part. This was moderately successfull, but calibration (both of the printer and camera) and allignment issues were more difficult to deal with than I had imangined. 

Near the end of this build, I realized, that I could possibly use the RS-232 output of the Newall Digital Readout that came with my mill. I was lucky to get [this](http://www.newall.com/upload/content/file/C80%20Manual%20-%20023-80500-UK-2.pdf) readout with my mill. 
The CS-80 can output the X and Y locations on the serial port as fast as once every 0.1 seconds.



