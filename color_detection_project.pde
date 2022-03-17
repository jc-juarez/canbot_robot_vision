// Daniel Shiffman
// http://codingtra.in
// http://patreon.com/codingtrain
// Code for: https://youtu.be/nCVZHROb_dE

import processing.video.*;

Capture video;

color redColor; 
color blueColor;
float threshold = 25;

int logTracker;
int redDetected;
int blueDetected;

int minXRed;
int maxXRed;
int minYRed;
int maxYRed;

int minXBlue;
int maxXBlue;
int minYBlue;
int maxYBlue;

void setup() {
  size(640, 360);
  String[] cameras = Capture.list();
  printArray(cameras);
  video = new Capture(this, cameras[0]);
  video.start();
  redColor = color(245, 60, 32);
  blueColor = color(35, 110, 232);
  logTracker = 0;
  redDetected = 0;
  blueDetected = 0;
  minXRed = Integer.MAX_VALUE;
  maxXRed = Integer.MIN_VALUE;
  minYRed = Integer.MAX_VALUE;
  maxYRed = Integer.MIN_VALUE;

  minXBlue = Integer.MAX_VALUE;
  maxXBlue = Integer.MIN_VALUE;
  minYBlue = Integer.MAX_VALUE;
  maxYBlue = Integer.MIN_VALUE;
}

void captureEvent(Capture video) {
  video.read();
}

void draw() {
  video.loadPixels();
  //background(0);
  //fill(1);
  image(video, 0, 0);
  
  redDetected = 0;
  blueDetected = 0;
  
  minXRed = Integer.MAX_VALUE;
  maxXRed = Integer.MIN_VALUE;
  minYRed = Integer.MAX_VALUE;
  maxYRed = Integer.MIN_VALUE;

  minXBlue = Integer.MAX_VALUE;
  maxXBlue = Integer.MIN_VALUE;
  minYBlue = Integer.MAX_VALUE;
  maxYBlue = Integer.MIN_VALUE;

  //threshold = map(mouseX, 0, width, 0, 100);
  threshold = 80;

  float avgXRed = 0;
  float avgYRed = 0;
  float avgXBlue = 0;
  float avgYBlue = 0;

  int countRed = 0;
  int countBlue = 0;

  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(redColor);
      float g2 = green(redColor);
      float b2 = blue(redColor);
      float r3 = red(blueColor);
      float g3 = green(blueColor);
      float b3 = blue(blueColor);

      float dRed = distSq(r1, g1, b1, r2, g2, b2); 
      float dBlue = distSq(r1, g1, b1, r3, g3, b3); 

      if (dRed < threshold*threshold) {
        //stroke(255);
        //strokeWeight(1);
        //point(x, y);
        avgXRed += x;
        avgYRed += y;
        countRed++;
        minXRed = Math.min(minXRed,x);
        maxXRed = Math.max(maxXRed,x);
        minYRed = Math.min(minYRed,y);
        maxYRed = Math.max(maxYRed,y);
      }
      if (dBlue < threshold*threshold) {
        //stroke(255);
        //strokeWeight(1);
        //point(x, y);
        avgXBlue += x;
        avgYBlue += y;
        countBlue++;
        minXBlue = Math.min(minXBlue,x);
        maxXBlue = Math.max(maxXBlue,x);
        minYBlue = Math.min(minYBlue,y);
        maxYBlue = Math.max(maxYBlue,y);
      }
    }
  }

  // We only consider the color found if its color distance is less than 10. 
  // This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
  if (countRed > 0) { 
    avgXRed = avgXRed / countRed;
    avgYRed = avgYRed / countRed;
    strokeWeight(4.0);
    stroke(1);
    // Found something
    redDetected = 1;
    fill(245, 60, 32);
    circle(avgXRed, avgYRed, 35);
    stroke(255,255,255);
    circle(minXRed, maxYRed, 15);
    circle(minXRed, minYRed, 15);
    circle(maxXRed, maxYRed, 15);
    circle(maxXRed, minYRed, 15);
    line(minXRed, maxYRed,minXRed, minYRed);
    line(minXRed, minYRed,maxXRed, minYRed);
    line(minXRed, maxYRed,maxXRed, maxYRed);
    line(maxXRed, maxYRed,maxXRed, minYRed);
  }
  
  if (countBlue > 0) { 
    avgXBlue = avgXBlue / countBlue;
    avgYBlue = avgYBlue / countBlue;
    strokeWeight(4.0);
    stroke(1);
    // Found something
    blueDetected = 1;
    fill(35, 110, 232);
    circle(avgXBlue, avgYBlue, 35);
    stroke(255,255,255);
    circle(minXBlue, maxYBlue, 15);
    circle(minXBlue, minYBlue, 15);
    circle(maxXBlue, maxYBlue, 15);
    circle(maxXBlue, minYBlue, 15);
    line(minXBlue, maxYBlue,minXBlue, minYBlue);
    line(minXBlue, minYBlue,maxXBlue, minYBlue);
    line(minXBlue, maxYBlue,maxXBlue, maxYBlue);
    line(maxXBlue, maxYBlue,maxXBlue, minYBlue);
  }
  
  if(redDetected == 1 && blueDetected == 1){
    println(logTracker," -> Red Object: [ minX : ", minXRed, " | maxX : ", maxXRed, " | minY : ", minYRed, " | maxY : ", maxYRed, " ] // Blue Object: [ minX : ", minXBlue, " | maxX : ", maxXBlue, " | minY : ", minYBlue, " | maxY : ", maxYBlue, " ]");
  } else if(redDetected == 1){
    println(logTracker," -> Red Object: [ minX : ", minXRed, " | maxX : ", maxXRed, " | minY : ", minYRed, " | maxY : ", maxYRed, " ]");
  } else if(blueDetected == 1){
    println(logTracker," -> Blue Object: [ minX : ", minXBlue, " | maxX : ", maxXBlue, " | minY : ", minYBlue, " | maxY : ", maxYBlue, " ]");
  }
  
  if(redDetected == 1 || blueDetected == 1) logTracker++;
  
}

float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}
