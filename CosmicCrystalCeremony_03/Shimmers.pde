
class Shimmers {

  PVector pos;
  PImage[] shimmers;
  float[] shimmersAlpha;
  float[] shimmersAlphaIncrement;
  float scale;

  Shimmers() {
    pos = new PVector(floorLayer.width * 0.5, -10);
    scale = 0.75;

    shimmers = new PImage[3];
    shimmersAlpha = new float[shimmers.length];
    shimmersAlphaIncrement = new float[shimmers.length];

    for (int i=0; i < shimmers.length; i++) {
      shimmers[i] = loadImage("shimmer_" + i  + ".png");
      shimmersAlpha[i] = random(1);
      shimmersAlphaIncrement[i] = random(TWO_PI * 0.002, TWO_PI * 0.005);
    }
  }

  void render() {
    floorLayer.pushMatrix();
    floorLayer.translate(pos.x, pos.y);
    floorLayer.scale(scale);
    for (int i=0; i < shimmers.length; i++) {
      shimmersAlpha[i] += shimmersAlphaIncrement[i];
      floorLayer.blendMode(ADD);
      floorLayer.tint((((sin(shimmersAlpha[i]) + 1) * 0.5) + 0.2) * 255 );
      floorLayer.image(shimmers[i], -(shimmers[i].width * 0.5), pos.y);
    }
    floorLayer.popMatrix();
  }

  void setScale(float _scale) {
    scale = _scale;
  }
}
