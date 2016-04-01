/**
 * Simple Read
 * 
 * Read data from the serial port and change the color of a rectangle
 * when a switch connected to a Wiring or Arduino board is pressed and released.
 * This example works with the Wiring / Arduino program that follows below.
 */

import processing.serial.*;

PShape cadImage;  // Sets up the datatype for storing the CAD (SVG) file to be loaded 
PShape cadImageThumb;  // Sets up the datatype for storing the CAD (SVG) used for the thumbnail
                       // file to be loaded 

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

float xScale = 100, yScale = 100;
float xOffset = -15, yOffset = -10;
float scaleFactor = 1;


boolean shiftflag; // flag which determines whether shift is held down or not
boolean ctrlflag; // flag which determines whether ctrl is held down or not
boolean dispThmbFlag;  //flag to indicate whether to display thumbnail window or not


void setup() 
{
  fullScreen(2);
  //size(1680, 1050);
  printArray(Serial.list());    //List availble ports and port numbers
  //String portName = Serial.list()[3];   //Home Desktop USB Adapter
  String portName = Serial.list()[1];    //Home Desktop UNO Port
  //println(portName);
  myPort = new Serial(this, portName, 9600);
  
  // The file "XXXXX.svg" file must be in the data folder
  // of the current sketch to load successfully
  //cadImage = loadShape("Large Square Test Drawing.svg");
  //cadImage = loadShape("Small Image Test Drawing.svg");  
  cadImage = loadShape("test drawing - HM Base - no grids3.svg");
  //cadImage = loadShape("test drawing - HM Base - with grids.svg");
  cadImageThumb = cadImage; //set the image for the thumbnail window
  inBuffer = myPort.readStringUntil(cr);   //Clear out any garbage from the serial port
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
      xValue = float(trim(xValueStr));
      xValue = (xValue*xScale) + xOffset;
    }
    if (axis.equals("Y")) {  
      yValueStr = inBuffer.substring(2);   // Get Y axis value
      yValue = float(trim(yValueStr));
      yValue = (yValue*yScale) + yOffset;   
    }

    //print("X_Float:");
    //println(xValue);
    //print("Y_Float:");
    //println(yValue); 
    

    //shapeMode(CORNER);
    shapeMode(CENTER);
    background(000);
    //shape(cadImage, 0, 0)

    shape(cadImage, -1000, -1000); 
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
    text(xValueStr,60,180);
    text(str(xValue),100,80);
    text("Y Value: ",10,95);
    text(yValueStr,60,200);
    text(str(yValue),100,95);
    
    shape(cadImage, 1400, 100, 16.8, 10.5); 
    //line (560,525,1100,525); // Draw Cross Hairs
    //line (840,300,840,800);  
    //strokeWeight(4);
    //ellipseMode(CENTER);
    //ellipse(840,525,500,500);
   //shape(cadImageThumb, -1000, -1000); 
         


    }
    
  }

  xTranslate=xValue-lastxValue;   //calculate amount to shift image X direction
  yTranslate=yValue-lastyValue;   //calculate amount to shift image Y direction
  
  lastxValue=xValue;   //Set the last x value to the current  xValue
  lastyValue=yValue;   //Set the last y value to the current  yValue
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
  
  line (560,525,1100,525); // Draw Cross Hairs
  line (840,300,840,800);  
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


void keyPressed()
{
  // Handle things when key is pressed
  println(keyCode);
  if(keyCode==16) {shiftflag=true;} // set shift flag
  if(keyCode==17) {ctrlflag=true;} // set ctrl flag
  switch(keyCode)
  {
    case 37: // left arrow
      if(shiftflag)
      {
        cadImage.translate(-10,0);    //translate image to the left 10
        scaleFactor=scaleFactor-10;
        print("Scale Factor: ");
        println(scaleFactor);
        //if(ctrlflag==true)
        //{
        //  if(ch_w>9) {ch_w-=10;}
        //} else {
        //  if(ch_w>0) {ch_w--;}
        //}
      } else {
        cadImage.translate(-1,0);     //translate image to the left 1
        scaleFactor--;
        print("Left Origin: ");
        println(scaleFactor);
        //if(ctrlflag==true) {
        //  ch_x-=10;
        //} else {
        //  ch_x--;
        //}
      }
      break;
    case 39: // right arrow
      if(shiftflag)
      {
        cadImage.translate(10,0);     //translate image to the right 10
        scaleFactor=scaleFactor+10;
        print("Scale Factor: ");
        println(scaleFactor);
        //if(ctrlflag==true) {
        //  ch_w+=10;
        //} else {
        //  ch_w++;
        //}
      } else
      {
        cadImage.translate(1,0);    //translate image to the right 1
        scaleFactor++;
        print("Scale Factor: ");
        println(scaleFactor);
        //if(ctrlflag==true) {
        //  ch_x+=10;
        //} else {
        //  ch_x++;
        //}
      }
      break;
    case 38: // up arrow
      if(shiftflag)
      {
        cadImage.translate(0,-10); 
        //if(ctrlflag==true) {
        //  ch_h+=10;
        //} else {
        //  ch_h++;
        //}
      } else
      {
        cadImage.translate(0,-1); 
        //if(ctrlflag==true) {
        //  ch_y+=10;
        //} else {
        //  ch_y++;
        //}
      }
      break;
    case 40: // down arrow
      if(shiftflag)
      {
        cadImage.translate(0,10); 
        //if(ctrlflag==true) {
        //  if(ch_h>9) {ch_h-=10;}
        //} else {
        //  if(ch_h>0) {ch_h--;}
        //}
      } else
      {
        cadImage.translate(0,1); 
        //if(ctrlflag==true) {
        //  ch_y-=10;
        //} else {
        //  ch_y--;
        //}
      }
      break;
    case 33: // page up
      if(shiftflag)
      {
        if(ctrlflag==true) {
          ch_a+=10;
        } else {
          ch_a++;
        }
      } else
      {
        if(ctrlflag==true) {
          ch_t+=10;
        } else {
          ch_t++;
        }
      }
      break; 
    case 34: // page down
      if(shiftflag)
      {
        if(ctrlflag==true) {
          ch_a-=10;
        } else {
          ch_a--;
        }
      } else
      {
        if(ctrlflag==true) {
          if(ch_t>9) {ch_t-=10;}
        } else {
          if(ch_t>0) {ch_t--;}
        }
      }
      break;
    case 49: // type 1
      //ch_type=1;
      break;
    case 50: // type 2
      ch_type=2;
      break;
    case 51: // type 3
      ch_type=3;
      break;
    case 52: // type 4
      ch_type=4;
      break;
    case 53: // type 5
      ch_type=5;
      break;
    case 54: // type 6
      ch_type=6;
      break;
    case 55: // type 7
      ch_type=7;
      break;
    case 56: // type 8
      ch_type=8;
      break;
    case 57: // type 9
      ch_type=9;
      break;
    case 48: // 0 - set the scale factor to zero
             // Set the left edge of the svg 1" box to the left edge of the window 1" box
      scaleFactor = 0;
      println("Scale Factor Set to 0");
      //ch_type=0;
      break;
    case 67: // C - cycle colors
      if(ch_color>6) {ch_color=0;} else {ch_color++;}
      break;
    case 82: // R - reset everything
      ch_x=0;
      ch_y=0;
      ch_w=10;
      ch_h=10;
      ch_t=2;
      ch_a=0;
      ch_type=1;
      ch_color=0;
      break;
    case 83: // S - set to current scale factor
      cadImage.scale(1000/(1000-scaleFactor));
      print("Scale set to: ");
      println(1000/(1000-scaleFactor));
      break;
    case 87: // X - exit
      exit();
      break;
    case 88: // W - toggle overview window
      exit();
      break;
  } 
}

void keyReleased()
{
  if(keyCode==16) {shiftflag=false;} // clear shift flag
  if(keyCode==17) {ctrlflag=false;} // clear ctrl flag
}

//void mousePressed()
//{
//  // Update origin with mouse position, but only if we are actually viewing the camera (i.e. don't respond
//  // to any mouse clicks on the splash screen)

//    //ch_x=mouseX-(cam.width/2);
//    //ch_y=(cam.height/2)-mouseY;

//}

//void mouseDragged()
//{
//  // Update origin with mouse position, but only if we are actually viewing the camera (i.e. don't respond
//  // to any mouse clicks on the splash screen)

//    //ch_x=mouseX-(cam.width/2);
//    //ch_y=(cam.height/2)-mouseY;
  
//}


void mouseWheel(MouseEvent event) {  //This function scales the shape + or - depending on wheel direction
  float e = event.getCount();
  //println(e);
  cadImage.scale((e*(-.1))+1);
  //cadImage.translate((mouseX-840)*1.2,(mouseY-550)*1.2); 
}