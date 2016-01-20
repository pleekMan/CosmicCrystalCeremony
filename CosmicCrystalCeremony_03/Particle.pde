class Particle {
  float x;
  float y;
  float c;
  float colorIncrement;

  Particle() {
    x = y = 0;
    reset(x,y);
  }

  void render() {
    c+=colorIncrement;
    
    wallLayer.fill(255,c);
    wallLayer.noStroke();
    //wallLayer.stroke(c);
    wallLayer.ellipse(x,y,3,3);
  }

  void reset(float _x, float _y) {
    x = _x;
    y = _y;
    c = 255;
    colorIncrement = random(-5,-0.5);
    
    //println(x + " : " + y + " : " + c);
    //println(x);
  }
  
  boolean isDead(){
   return c < 0; 
  }
}
