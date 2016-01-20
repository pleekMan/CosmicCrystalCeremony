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
    
    wallLayer.fill(c);
    wallLayer.noStroke();
    //wallLayer.stroke(c);
    wallLayer.ellipse(x,y,2,2);
  }

  void reset(float _x, float _y) {
    x = _x;
    y = _y;
    c = 255;
    colorIncrement = random(-3,-0.5);
    
    //println(x + " : " + y + " : " + c);
    //println(x);
  }
  
  boolean isDead(){
   return c < 0; 
  }
}
