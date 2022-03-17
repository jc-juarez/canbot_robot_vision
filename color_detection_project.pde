// Daniel Shiffman
// http://codingtra.in
// http://patreon.com/codingtrain
// Code for: https://youtu.be/nCVZHROb_dE

import processing.video.*;

Capture video;

color trackColor; 
float threshold = 25;

int logTracker;

void setup() {
  size(640, 360);
  String[] cameras = Capture.list();
  printArray(cameras);
  video = new Capture(this, cameras[0]);
  video.start();
  trackColor = color(255, 0, 0);
  logTracker = 0;
}

void captureEvent(Capture video) {
  video.read();
}

void draw() {
  video.loadPixels();
  background(0);
  textSize(20);
  text("Equipo 2 - Visión para Robots", 178, 40);
  //fill(1);
  rect(130, 280, 400, 80);
  //image(video, 0, 0);

  //threshold = map(mouseX, 0, width, 0, 100);
  threshold = 80;

  float avgX = 0;
  float avgY = 0;

  int count = 0;

  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      float d = distSq(r1, g1, b1, r2, g2, b2); 

      if (d < threshold*threshold) {
        //stroke(255);
        //strokeWeight(1);
        //point(x, y);
        avgX += x;
        avgY += y;
        count++;
      }
    }
  }

  // We only consider the color found if its color distance is less than 10. 
  // This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
  if (count > 0) { 
    avgX = avgX / count;
    avgY = avgY / count;
    // Draw a circle at the tracked pixel
    /*
    if(avgX < 0 || avgX > 640 || avgY < 0 || avgY > 360){
      fill(204, 102, 0);
      println("This");
    }else{
      fill(0, 0, 255);
      println("other");
    }
    */
    //fill(204, 102, 0);
    
    // 130, 280, 400, 80
    float _avgX = avgX - 60;
    float _avgY = avgY + 130;
    
    if (130 < _avgX + 50 &&
    130 + 400 > _avgX &&
    280 < _avgY + 50 &&
    80 + 280 > _avgY) {
    //colliding!
    fill(255, 0, 0);
  } else {
    //not colliding!
    fill(0, 255, 0);
  }
    
    
    strokeWeight(4.0);
    stroke(0);
    // Found something
    println(logTracker," - Center of Object Detected");
    logTracker++;
    rect(avgX, avgY, 50, 180);
  }
}

float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}

void mousePressed() {
  // Save color where the mouse is clicked in trackColor variable
  int loc = mouseX + mouseY*video.width;
  trackColor = video.pixels[loc];
}
