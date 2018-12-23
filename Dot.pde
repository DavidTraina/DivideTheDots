class Dot {
  float x;
  float y;
  float radius;
  Dot(float x, float y, float radius) {
    this.x = x;
    this.y = y;
    this.radius = radius;
  }
  
  void drawDot() {
    ellipse(x, y, radius, radius);
  }
  
  float getX() {
    return x;
  }
  
  float getY() {
    return y;
  }
  
  float getRadius() {
    return radius;
  }
  
}
