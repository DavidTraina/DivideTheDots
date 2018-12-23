class Dot {
  private float x;
  private float y;
  private float radius;
  color dotColor;

  Dot(float x, float y, float radius) {
    this.x = x;
    this.y = y;
    setRadius(radius);
  }

  void drawDot() {
    fill(dotColor);
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
    calculateColor();
  }

  private void calculateColor() {
    photo.loadPixels();
    float r = 0;
    float g = 0;
    float b = 0;
    for (int i = 0; i < 2 * round(radius); i++) {
      for (int j = 0; j < 2 * round(radius); j++) {
        r += red(photo.get(round(x - radius + i), round(y - radius + j)));
        g += green(photo.get(round(x - radius + i), round(y - radius + j)));
        b += blue(photo.get(round(x - radius + i), round(y - radius + j)));
      }
    }
    r = r / (4*radius*radius);
    g = g / (4*radius*radius);
    b = b / (4*radius*radius);
    this.dotColor = color(r, g, b);
  }
}
