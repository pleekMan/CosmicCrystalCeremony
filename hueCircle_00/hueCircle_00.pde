
float angle;
float angleIncrement;

float hue;
float hueNoise;
float hueNoiseIncrement;

void setup() {
  size(700, 700);
  colorMode(HSB,1);
  noStroke();
  frameRate(120);
  
  angle = 0;
  angleIncrement = 0.001;

  hue = random(1);
  hueNoise = random(1);
  hueNoiseIncrement = 0.01;
  
}

void draw() {
  //background(0);
  
  pushMatrix();
  translate(width * 0.5, height * 0.5);
  rotate(angle);
  fill(hue,1,1);
  rect(0,0,width,2);
  
  popMatrix();
  
  angle +=angleIncrement;
  
  hueNoise += hueNoiseIncrement;
  hue = noise(hueNoise);
}

void keyPressed() {
}

void mousePressed() {
}

void mouseReleased() {
}

void mouseClicked() {
}

void mouseDragged() {
}

void mouseWheel(MouseEvent event) {
  //float e = event.getAmount();
  //println(e);
}
