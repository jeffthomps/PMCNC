/**
 * Simple Read
 * 
 * Read data from the serial port and change the color of a rectangle
 * when a switch connected to a Wiring or Arduino board is pressed and released.
 * This example works with the Wiring / Arduino program that follows below.
 */


import processing.serial.*;
PShape cadImage;  // Sets up the datatype for storing the CAD (SVG) file to be loaded 
Serial myPort;  // Create object from Serial class
String inBuffer=" ";
int lf = 10;    // Linefeed in ASCII
int cr = 13;    // Carriage Return in ASCII

String axis, xValueStr = " ", yValueStr = " ";
float xValue = 0, yValue = 0;
float lastxValue = 0, lastyValue = 0;
float xTranslate = 0, yTranslate = 0;

int ms,ms_last;  //milliseconds since program start
float fps; // Frames per second

// Declarations for crosshair parameters
int ch_x; // x position of center rel to center of screen
int ch_y; // y position of center rel to center of screen
int ch_w; // width
int ch_h; // height
int ch_t; // thickness
int ch_a; // angle. This is divided by 5 to get the ACTUAL angle, so we have a resolution of 0.2Â°
int ch_type; // crosshair type
int ch_color; // color index to use
color[] colors=new color[8]; // array to store colors

float x1,y1,x2,y2; // temporary variables used for calculations

int x_origin; // actual X and Y pixel origins of crosshairs
int y_origin;
int maxlength; // maximum length of line which fits diagonally on screen

float xScale = 30, yScale = 30;
float xOffset = 0, yOffset = 0;

boolean shiftflag; // flag which determines whether shift is held down or not
boolean ctrlflag; // flag which determines whether ctrl is held down or not


void setup() 
{
  fullScreen(2);
  //size(1680, 1050);
  printArray(Serial.list());    //List availble ports and port numbers
  //String portName = Serial.list()[3];   //Home Desktop UNO Port
  String portName = Serial.list()[1];
  //println(portName);
  myPort = new Serial(this, portName, 9600);
  
  // The file "bot1.svg" must be in the data folder
  // of the current sketch to load successfully
  //cadImage = loadShape("Large Square Test Drawing.svg");
  cadImage = loadShape("Small Image Test Drawing.svg");  
  //cadImage = loadShape("test drawing - HM Base - no grids.svg");
  //cadImage = loadShape("test drawing - HM Base - with grids.svg");
  inBuffer = myPort.readStringUntil(cr); 
  //inBuffer = null;
  //background(000);
}

void draw()
  {
  // Read Serial Data when avaialable
  while (myPort.available() > 0) {
    inBuffer = myPort.readStringUntil(lf);   
    if (inBuffer != null) {
      //println("++++++++++++++++++++++++++");
      //println(inBuffer); 
      axis = inBuffer.substring(0, 1);  // Get axis letter
    if (axis.equals("X")) {  
      xValueStr = inBuffer.substring(2);   // Get X axis value      
      //print("X Axis Reading:");
      xValue = float(trim(xValueStr));
      xValue = (xValue*xScale) + xOffset;
      //println(xValue);
      //print("X_Float:");
      //println(xValue);
    }
    if (axis.equals("Y")) {  
      yValueStr = inBuffer.substring(2);   // Get Y axis value
      //print("Y Axis Reading:");
      yValue = float(trim(yValueStr));
      yValue = (yValue*yScale) + yOffset;
      //println(yValue);
      //print("Y_Float:");
      //println(yValue);
      
    }


    
    print("X_Float:");
    println(xValue);
    print("Y_Float:");
    println(yValue); 

    shapeMode(CORNER);
    //shapeMode(CENTER);
    //background(000);
    shape(cadImage, 0, 0);  
    //shape(cadImage, xValue, yValue); 
    //shape(cadImage, xValue, yValue, 357.717, 176.212);            // Draw at coordinate (x, y, width, height) 
    //shape(cadImage, xValue, yValue, 715.434, 352.424);
    //shape(cadImage, xValue, yValue, 1073.151,528.636);
    //shape(cadImage, xValue, yValue, 1430.868,704.848);
    //shape(cadImage, xValue, yValue, 3571.700,1762.120);
    //shape(cadImage, mouseX-100, mouseY-100);
    //fill(0,0,0);   //change fill to color to black
    //stroke(0,0,0); // change line color to black
    //rect(0,0,180,110);  // Draw a box to put the text in
    fill(0,100,0);      //change color for text
    text("X Value: ",10,80);
    //text(xValueStr,60,180);
    text(str(xValue),100,80);
    text("Y Value: ",10,95);
    //text(yValueStr,60,200);
    text(str(yValue),100,95);
         


    }
    
  }

  xTranslate=xValue-lastxValue;   //calculate amount to shift image X direction
  yTranslate=yValue-lastyValue;   //calculate amount to shift image Y direction
  
  lastxValue=xValue;
  lastyValue=yValue;
  text(str(xTranslate),100,110);
  text(str(yTranslate),100,125);
  cadImage.translate(xTranslate, yTranslate); 
  
  colorMode(RGB,100);
  noFill();
  strokeWeight(1);
  stroke(100,0,0); // set color
  line (340,25,1340,25); //Draw 1" Boundry Left Line
  line (1340,25,1340,1025);  //Draw 1" Boundry Right Line (1000 pixels from Left)
  line (1340,1025,340,1025); //  Draw 1" Boundry Top Line
  line (340,1025,340,25);  //Draw 1" Boundry Bottom Line (1000 pixels from Top) 
  strokeWeight(4);
  ellipseMode(CENTER);
  ellipse(840,525,500,500);
  
  
  ms=millis();
  fps=1000.0/(ms-ms_last); //calculate frames per second
  //println(fps,ms,ms_last);
  text("FPS",10,50);
  text(fps,80,50);
  ms_last=ms; 
  
  
}

void mousePressed() {
  //// Shrink the shape 90% each time the mouse is pressed
  // Enlarge the shape 10% each time the mouse is pressed
  //cadImage.scale(1.5);
  //cadImage.translate(10, 10);
  cadImage.translate(mouseX, mouseY);
  
}
