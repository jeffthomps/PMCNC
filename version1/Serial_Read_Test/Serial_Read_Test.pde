/**
 * Simple Read
 * 
 * Read data from the serial port and change the color of a rectangle
 * when a switch connected to a Wiring or Arduino board is pressed and released.
 * This example works with the Wiring / Arduino program that follows below.
 */


import processing.serial.*;
PShape cadImage;
Serial myPort;  // Create object from Serial class
String inBuffer;
int lf = 10;    // Linefeed in ASCII
int val;      // Data received from the serial port
String axis, xValueStr = " ", yValueStr = " ";
float xValue, yValue = 0;
int ms,ms_last;  //milliseconds since program start
float fps; // Frames per second
void setup() 
{
  //size(200, 200);
  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  printArray(Serial.list());
  //String portName = Serial.list()[3];   //Home Desktop UNO Port
  String portName = Serial.list()[3];
  //println(portName);
  myPort = new Serial(this, portName, 9600);
  size(1000, 1000);
  // The file "bot1.svg" must be in the data folder
  // of the current sketch to load successfully
  cadImage = loadShape("Webcam Test Drawing HEATERMETER BOTTOM TEST.svg");
  inBuffer = myPort.readStringUntil(lf); 
  inBuffer = null;   
}

void draw()
  {
//  if ( myPort.available() > 0) {  // If data is available,
//    val = myPort.read();         // read it and store it in val
//  }
  while (myPort.available() > 0) {
    inBuffer = myPort.readStringUntil(lf);   
    if (inBuffer != null) {
      println("++++++++++++++++++++++++++");
      println(inBuffer); 
      axis = inBuffer.substring(0, 1);  // Get axis letter
    if (axis.equals("X")) {  
      xValueStr = inBuffer.substring(2);   // Get X axis value      
      print("X Axis Reading:");
      float xValue = float(xValueStr); //<>//
      println(xValue);
    }
    if (axis.equals("Y")) {  
      yValueStr = inBuffer.substring(2);   // Get Y axis value
      print("Y Axis Reading:");
      float yValue = float(yValueStr); //<>//
      println(yValue);
    }
    }
    
  }
  
  //background(000);
  //shape(cadImage, -1000, -1000, 1000, 2000);  // Draw at coordinate (110, 90) at size 100 x 100
  shape(cadImage, xValue, yValue, 500, 500);            // Draw at coordinate (280, 40) at the default size

  text("X Value: ",0,180);
  text(xValueStr,80,180);
  text("Y Value: ",0,200);
  text(yValueStr,80,200);
  
  ms=millis();
  fps=1000.0/(ms-ms_last); //calculate frames per second
  //println(fps,ms,ms_last);
  //text("FPS",0,140);
  //text(fps,80,140);
  ms_last=ms; 
  
  
  
//  background(255);             // Set background to white
//  if (val == 0) {              // If the serial value is 0,
//    fill(0);                   // set fill to black
//  } 
//  else {                       // If the serial value is not 0,
//    fill(204);                 // set fill to light gray
//  }
//  rect(50, 50, 100, 100);
}