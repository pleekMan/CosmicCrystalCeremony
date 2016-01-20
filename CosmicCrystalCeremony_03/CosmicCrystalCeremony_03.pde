import controlP5.*;
import deadpixel.keystone.*;

Keystone keyStoner;
ControlP5 controlGui;

PGraphics floorLayer;
PGraphics wallLayer;
PGraphics crystalLayer;

PImage wallBack;
PImage wallMountains;
PImage floorBack;
PImage rainbow;

CornerPinSurface floorSurface;
CornerPinSurface wallSurface;

PImage backgroundRender;

PVector[] crystalVertex;
float crystalSidesUVs;

float rainbowPos;

float layersOpacity;

ArrayList<Comet> comets;

void setup() {
  size(1280, 720, P3D);
  frameRate(30);


  controlGui = new ControlP5(this);
  controlGui.addSlider("crystalSidesUVs").setRange(0.6, 1).setPosition(20, 40).setDefaultValue(1).setLabel("CRYSTAL SIDE VERTEX UVs");
  controlGui.addSlider("layersOpacity").setRange(0, 1).setPosition(20, 60).setDefaultValue(1).setLabel("SURFACES ALPHA");
  controlGui.addFrameRate().setInterval(60).setPosition(20, 20);

  backgroundRender = loadImage("Ceremony Espacio 3D.png");
  keyStoner = new Keystone(this);

  createSurfacesAndLayers();
  wallBack = loadImage("wall.png");
  floorBack = loadImage("floor.png");
  wallMountains = loadImage("wallMountains.png");
  rainbow = loadImage("rainbow.png");

  crystalVertex = new PVector[4];
  crystalVertex[0] = new PVector(645, 239, 1);
  crystalVertex[1] = new PVector(810, 530, 1);
  crystalVertex[2] = new PVector(645, 575, 1);
  crystalVertex[3] = new PVector(480, 530, 1);

  crystalSidesUVs = 1;
  layersOpacity = 1;
  rainbowPos = 0;

  comets = new ArrayList<Comet>();
  createComets(20);

  keyStoner.load();
}

void draw() {
  //background(backgroundRender); // THIS CAUSES SCREEN FLICKERING
  background(0);
  tint(255);
  image(backgroundRender, 0, 0);

  //drawBackLines(color(255, 255, 0));

  floorLayer.beginDraw();
  floorLayer.background(floorBack);
  floorLayer.endDraw();


  wallLayer.beginDraw();
  wallLayer.background(0);
  wallLayer.image(wallBack, 0, 0);

  //drawBackLines(wallLayer, color(0, 255, 0));

  //wallLayer.pushMatrix();
  //wallLayer.translate(0,0,-10);
  for (Comet comet : comets) {
    if (comet.collided()) {
      resetComet(comet);
    }
    comet.render();
  }

  wallLayer.image(wallMountains, 0, 0);

  wallLayer.endDraw();

  tint(255, layersOpacity * 255);
  crystalLayer.beginDraw();
  crystalLayer.background(0);
  //drawBackLines(crystalLayer, color(255, 255, 0));  
  drawRainbow();
  crystalLayer.endDraw();

  textureMode(NORMAL);
  beginShape();
  texture(crystalLayer);
  vertex(crystalVertex[0].x, crystalVertex[0].y, crystalVertex[0].z, 0.5, 0);
  vertex(crystalVertex[1].x, crystalVertex[1].y, crystalVertex[1].z, crystalSidesUVs, 1);
  vertex(crystalVertex[2].x, crystalVertex[2].y, crystalVertex[2].z, 0.5, 1);
  vertex(crystalVertex[3].x, crystalVertex[3].y, crystalVertex[3].z, 1 - crystalSidesUVs, 1);
  endShape(CLOSE);
  textureMode(IMAGE);


  tint(255, layersOpacity * 255);
  floorSurface.render(floorLayer);
  wallSurface.render(wallLayer);


  //image(wallLayer,mouseX,mouseY);
}

void createSurfacesAndLayers() {
  floorLayer = createGraphics(1000, 400, P2D);
  wallLayer = createGraphics(1000, 800, P2D);
  crystalLayer = createGraphics(500, 700, P2D);

  floorSurface = keyStoner.createCornerPinSurface(floorLayer.width, floorLayer.height, 10);
  wallSurface = keyStoner.createCornerPinSurface(wallLayer.width, wallLayer.height, 10);
}

void drawRainbow() {

  rainbowPos-=1;
  crystalLayer.image(rainbow, rainbowPos, 0);
  crystalLayer.image(rainbow, rainbowPos + rainbow.width, 0);
  if (rainbowPos < -rainbow.width) {
    rainbowPos = 0;
  }
}

public void drawBackLines(PGraphics onLayer, color lineColor) {
  onLayer.stroke(lineColor);
  float offset = frameCount % 40;
  for (int i = 0; i < onLayer.width; i += 40) {
    onLayer.line(i + offset, 0, i + offset, onLayer.height);
  }
}

public void createComets(int count) {
  for (int i=0; i<count; i++) {
    Comet newComet = new Comet();
    resetComet(newComet);
    comets.add(newComet);
  }
}

public void resetComet(Comet _comet) {
  float yVel = random(0.3, 1.5);
  PVector collisionPoint = new PVector(random(0, wallLayer.width), random(638, 677));
  PVector vel = new PVector(yVel * 0.5, yVel);
  float _size = random(2, 10);
  _comet.reset(collisionPoint, vel, _size);
}

public boolean mouseOver(PVector _point) {
  return dist(_point.x, _point.y, mouseX, mouseY) < 20;
}

public void mousePressed() {
}

public void mouseDragged() {

  // CRYSTAL VERTEX POSITIONING
  for (int i=0; i < crystalVertex.length; i++) {
    if (mouseOver(crystalVertex[i])) {
      crystalVertex[i].set(mouseX, mouseY);
      noFill();
      stroke(0, 255, 0);
      ellipse(crystalVertex[i].x, crystalVertex[i].y, 20, 20);
    }
  }
}

void keyPressed() {
  switch(key) {
    /*
  case 'q':
     crystalSidesUVs+=0.1;
     crystalSidesUVs = constrain(crystalSidesUVs, 0.6, 1);
     break;
     case 'a':
     crystalSidesUVs-=0.1;
     crystalSidesUVs = constrain(crystalSidesUVs, 0.6, 1);
     break;
     */

  case 'g':
    if (controlGui.isVisible()) {
      controlGui.hide();
    } else {
      controlGui.show();
    }
    break;
  case 'c':
    // enter/leave calibration mode, where surfaces can be warped 
    // and moved
    keyStoner.toggleCalibration();
    break;

  case 'l':
    // loads the saved layout
    keyStoner.load();
    break;

  case 's':
    // saves the layout
    keyStoner.save();
    break;
  }
}
