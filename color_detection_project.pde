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

void setup() {
  size(640, 360);
  String[] cameras = Capture.list();
  printArray(cameras);
  video = new Capture(this, cameras[0]);
  video.start();
  redColor = color(245, 60, 32);
  blueColor = color(35, 110, 232);
  logTracker = 0;
}

void captureEvent(Capture video) {
  video.read();
}

void draw() {
  video.loadPixels();
  background(0);
  fill(1);
  image(video, 0, 0);

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
      }
      if (dBlue < threshold*threshold) {
        //stroke(255);
        //strokeWeight(1);
        //point(x, y);
        avgXBlue += x;
        avgYBlue += y;
        countBlue++;
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
    println(logTracker," - Center of Red Object Detected");
    logTracker++;
    fill(245, 60, 32);
    rect(avgXRed, avgYRed, 50, 180);
  }
  
    if (countBlue > 0) { 
    avgXBlue = avgXBlue / countBlue;
    avgYBlue = avgYBlue / countBlue;
    strokeWeight(4.0);
    stroke(1);
    // Found something
    println(logTracker," - Center of Blue Object Detected");
    logTracker++;
    fill(35, 110, 232);
    rect(avgXBlue, avgYBlue, 50, 180);
  }
}

float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}

void mousePressed() {
  // Save color where the mouse is clicked in redColor variable
  int loc = mouseX + mouseY*video.width;
  redColor = video.pixels[loc];
}
