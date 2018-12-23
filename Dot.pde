class Dot {
  private float x;
  private float y;
  private float radius;
  
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
  
  void setX(float x) {
    this.x = x;
  }
  
  float getY() {
    return y;
  }
    
  void setY(float y) {
    this.y = y;
  }
  
  float getRadius() {
    return radius;
  }
  
  void setRadius(float radius) {
      this.radius = radius;
  }
 
  
}
