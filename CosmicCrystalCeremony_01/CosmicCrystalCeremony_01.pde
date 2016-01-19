import controlP5.*;
import deadpixel.keystone.*;

Keystone keyStoner;
ControlP5 controlGui;

PGraphics floorLayer;
PGraphics wallLayer;
PGraphics crystalLayer;

PImage wallBack;
PImage floorBack;

CornerPinSurface floorSurface;
CornerPinSurface wallSurface;

PImage backgroundRender;

PVector[] crystalVertex;
float crystalSidesUVs;

float layersOpacity;

void setup() {
  size(1280, 720, P3D);

  controlGui = new ControlP5(this);
  controlGui.addSlider("crystalSidesUVs").setRange(0.6, 1).setPosition(20, 40).setDefaultValue(1).setLabel("CRYSTAL SIDE VERTEX UVs");
  controlGui.addSlider("layersOpacity").setRange(0,1).setPosition(20,60).setDefaultValue(1).setLabel("SURFACES ALPHA");
  controlGui.addFrameRate().setInterval(60).setPosition(20,20);
  
  backgroundRender = loadImage("Ceremony Espacio 3D.png");
  keyStoner = new Keystone(this);
  
  createSurfacesAndLayers();
  wallBack = loadImage("wall.png");
  floorBack = loadImage("floor.png");

  crystalVertex = new PVector[4];
  crystalVertex[0] = new PVector(645, 239, 1);
  crystalVertex[1] = new PVector(810, 530, 1);
  crystalVertex[2] = new PVector(645, 575, 1);
  crystalVertex[3] = new PVector(480, 530, 1);

  crystalSidesUVs = 1;
  layersOpacity = 1;
}

void draw() {
  //background(backgroundRender);
  background(0);

  floorLayer.beginDraw();
  floorLayer.background(floorBack);
  //drawBackLines(floorLayer, color(255, 0, 0));
  floorLayer.endDraw();

  wallLayer.beginDraw();
  wallLayer.background(wallBack);
  //drawBackLines(wallLayer, color(0, 255, 0));
  wallLayer.endDraw();

  crystalLayer.beginDraw();
  crystalLayer.background(0);
  drawBackLines(crystalLayer, color(255, 255, 0));  
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

  //image(crystalLayer,mouseX,mouseY);
}

void createSurfacesAndLayers() {
  floorLayer = createGraphics(1000, 400, P2D);
  wallLayer =createGraphics(1000, 800, P2D);
  crystalLayer = createGraphics(500, 700, P2D);

  floorSurface = keyStoner.createCornerPinSurface(floorLayer.width, floorLayer.height, 10);
  wallSurface = keyStoner.createCornerPinSurface(wallLayer.width, wallLayer.height, 10);
}

public void drawBackLines(PGraphics onLayer, color lineColor) {
  onLayer.stroke(lineColor);
  float offset = frameCount % 40;
  for (int i = 0; i < onLayer.width; i += 40) {
    onLayer.line(i + offset, 0, i + offset, onLayer.height);
  }
}

public boolean mouseOver(PVector _point) {
  return dist(_point.x, _point.y, mouseX, mouseY) < 10;
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
    if(controlGui.isVisible()){
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
