class Dot {
  private float x;
  private float y;
  private float radius;
  color dotColor;
  int framesUntilDivisible; // Does not allow Dot to be divided for a few frames after dividing so dots don't rapidly divide.
  final int MAX_FRAMES_UNTIL_DIVISIBLE = 3;

  Dot(float x, float y, float radius) {
    this.x = x;
    this.y = y;
    setRadius(radius);
  }

  void drawDot() {
    fill(dotColor);
    ellipse(x, y, radius, radius);
    if (framesUntilDivisible > 0) {
      framesUntilDivisible--;
    }
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
    framesUntilDivisible = MAX_FRAMES_UNTIL_DIVISIBLE;
  }

  private void calculateColor() {
    photo.loadPixels();
    float r = 0;
    float g = 0;
    float b = 0;
    int rRadius = round(radius);
    int rx = round(x);
    int ry = round(y);
    for (int i = 0; i < 2 * rRadius; i++) {
      for (int j = 0; j < 2 * rRadius; j++) {
        r += red(photo.get(rx - rRadius + i, ry - rRadius + j));
        g += green(photo.get(rx - rRadius + i, ry - rRadius + j));
        b += blue(photo.get(rx - rRadius + i, ry - rRadius + j));
      }
    }
    int numIterations = (4*rRadius*rRadius);
    r /= numIterations;
    g /= numIterations;
    b /= numIterations;
    this.dotColor = color(r, g, b);
  }
  
  boolean isDivisible() {
    return framesUntilDivisible == 0 && radius > MIN_DOT_SIZE;
  }
}
