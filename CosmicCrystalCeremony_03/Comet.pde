class Comet {

  float cometSize;
  PVector pos;
  PVector finalPos;
  PVector vel;
  color cometColor;

  PImage blast;
  PVector blastPos;
  float blastOpacity;

  ArrayList<Particle> particles;

  PVector miniCrystalPos;
  float miniCrystalScale;
  color miniCrystalColor;

  Comet() {
    finalPos = new PVector();
    pos = new PVector();
    vel = new PVector();
    cometSize = random(2, 10);
    cometColor = color(255, random(50, 230));

    createParticles();

    blast= loadImage("whiteBlast.png");
    blastPos = new PVector(-1000, -1000);

    miniCrystalPos = new PVector(-1000, -1000);
  }

  Comet(PVector _finalPos, PVector _vel, float _size) {
    createParticles();

    blast= loadImage("whiteBlast.png");
    blastPos = new PVector(-500, 500);
    miniCrystalPos = new PVector(-1000, -1000);


    reset(_finalPos, _vel, _size);
  }

  /*
  void update() {
   pos.add(vel);
   }
   */

  void render() {

    pos.add(vel);

    wallLayer.noFill();
    wallLayer.stroke(cometColor);
    wallLayer.line(pos.x, pos.y, pos.x - ((vel.x * 150)), pos.y - ((vel.y * 150)));
    wallLayer.noStroke();
    wallLayer.fill(cometColor);
    wallLayer.ellipse(pos.x, pos.y, cometSize, cometSize);

    for (int i=0; i<particles.size (); i++) {
      particles.get(i).render();
      if (particles.get(i).isDead()) {
        float x = random(pos.x - (cometSize * 0.5), pos.x + (cometSize * 0.5));
        float y = random(pos.y - (cometSize * 0.5), pos.y + (cometSize * 0.5));
        particles.get(i).reset(x, y);
      }
    }

    /*
    float blastScaleY = 1;
     if (pos.x > (wallLayer.width * 0.5)) {
     blastScaleY *= 2;
     }
     */
    //wallLayer.image(blast, blastPos.x - (blast.width * 0.5), blastPos.y - (blast.height * 0.8), blast.width, blast.width * blastScaleY);

    float blastTallMountainCorrection = 0;
    if (blastPos.x > 750) {
      blastTallMountainCorrection = -100;
    }
    wallLayer.tint(255, 255 * blastOpacity);
    wallLayer.image(blast, blastPos.x - (blast.width * 0.5), blastPos.y - (blast.height * 0.8) + blastTallMountainCorrection);

    wallLayer.tint(255);

    drawMiniCrystal();

    blastOpacity -= 0.02;
    blastOpacity = constrain(blastOpacity, 0, 1);
  }

  public boolean collided() {
    return pos.y > finalPos.y;
  }

  void drawMiniCrystal() {

    miniCrystalPos.add(0, -vel.y, 0);

    wallLayer.noFill();
    wallLayer.stroke(miniCrystalColor, 200);

    wallLayer.pushMatrix();
    wallLayer.translate(miniCrystalPos.x, miniCrystalPos.y);
    wallLayer.scale(miniCrystalScale);

    wallLayer.quad(0, -20, 10, 0, 0, 20, -10, 0);
    wallLayer.ellipse(0, 0, 5, 10);

    wallLayer.translate(0, vel.y * 20);
    wallLayer.stroke(miniCrystalColor, 50);
    wallLayer.line(0,0,0,vel.y * 30);
    
    wallLayer.popMatrix();
  }

  public void reset(PVector _finalPos, PVector _vel, float _size) {

    blastOpacity = 1;
    blastPos.set(pos);

    miniCrystalPos.set(pos);
    miniCrystalScale = random(1);
    //miniCrystalColor = color(random(255), random(255), random(255));
    miniCrystalColor = color(cometColor, 150);


    finalPos = _finalPos;
    cometSize = _size;
    vel = _vel;
    pos = calculateInitialPos(finalPos);
    cometColor = color(255, random(150, 240));
  }

  public void createParticles() {
    particles = new ArrayList<Particle>();
    for (int i=0; i<10; i++) {
      Particle newParticle = new Particle();

      float x = random(pos.x - (cometSize * 0.5), pos.x + (cometSize * 0.5));
      float y = random(pos.y - (cometSize * 0.5), pos.y + (cometSize * 0.5));
      newParticle.reset(x, y);
      particles.add(newParticle);
    }
  }


  PVector calculateInitialPos(PVector _finalPos) {
    PVector initPos = new PVector();
    initPos.y = -cometSize;
    float deltaCounts =  (_finalPos.y - initPos.y) / vel.y;
    initPos.x = finalPos.x - (vel.x * deltaCounts);
    return initPos;
  }
}
