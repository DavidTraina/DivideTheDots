/**
 * A Dot; represented as a single circle on-screen.
 */
private class Dot {

  /**
   * The x position of the center of the Dot.
   */
  private float x;

  /**
   * The y position of the center of the Dot.
   */
  private float y;

  /**
   * The radius of the Dot, in pixels.
   */
  private float radius;

  /**
   * The fill color of the Dot.
   */
  private color dotColor;

  /**
   * The most recent time that the Dot was divided, in milliseconds since the program started.
   */
  private long timeLastDivided;

  /**
   * The minimal amount of time between divisions, in milliseconds. Prevents the appearence of rapid multiple-division.
   */
  public static final int ANIMATION_TIME = 210;  

  /**
   * Create a new Dot.
   *
   * @param x            The x position of the center of the Dot.
   * @param y            The y position of the center of the Dot.
   * @param radius       The radius of the Dot, in pixels.
   */
  Dot(float x, float y, float radius) {
    this.x = x;
    this.y = y;
    this.radius = radius;
    calculateColor();
    timeLastDivided = millis();
  }
  
  /**
   * Return the x position of the center of the Dot.
   * @return The x position of the center of the Dot.
   */
  float getX() {
    return x;
  }

  /**
   * Return the y position of the center of the Dot.
   * @return The y position of the center of the Dot.
   */
  float getY() {
    return y;
  }

  /**
   * Return the radius of the Dot.
   * @return The radius of the Dot.
   */
  float getRadius() {
    return radius;
  }

  /**
   * Draw the Dot to the screen with a radius and position based on how long 
   * the Dot has been animataing. Return True iff dot is done animating. 
   * Important we check this at time of drawing and not before or after 
   * so we do not get innacurate results due to imprecise timing.
   *
   * @param oldDotX The x position of the Dot that was divided to create this Dot.
   * @param oldDotY The y position of the Dot that was divided to create this Dot.
   * @return true iff the dot is finished animating.
   */
  boolean drawDot(float oldDotX, float oldDotY) {
    fill(dotColor);
    long timeSinceDivision = millis() - timeLastDivided;
    if (timeSinceDivision >= ANIMATION_TIME) {
      ellipse(x, y, radius, radius);
      return true;
    }
    float percentComplete = (float) timeSinceDivision / ANIMATION_TIME;
    float xDiff = x - oldDotX;
    float yDiff = y - oldDotY;
    float rDiff = -radius; //radius - oldRadius = radius - 2*radius = -radius
    float displayX = oldDotX + (percentComplete * xDiff);
    float displayY = oldDotY + (percentComplete * yDiff);
    float displayR = (2 * radius) + (percentComplete * rDiff);
    ellipse(displayX, displayY, displayR, displayR);

    return false;
  }

  /**
   * Draw the Dot to the screen, unanimated, at position x, y with radius radius. 
   */
  void drawDot() {
    fill(dotColor);
    ellipse(x, y, radius, radius);
  }

  /**
   * Caculate the value of dotColor; the fill color of the Dot. Accomplishes this by 
   * averaging the colors of the pixels of photo which are overapped by the square 
   * centered at (x,y) with side length 2*radius. This is the square centered around 
   * the Dot and of minimal size such that it still contains the Dot.
   */
  private void calculateColor() {


    // Accumulated r, g, b values 
    float r = 0;
    float g = 0;
    float b = 0;


    int rRadius = round(radius);
    int rx = round(x);
    int ry = round(y);

    // Iterate over the pixels of photo which are overapped by the square 
    // centered at (rx,ry) with side length 2 * rRadius
    for (int i = 0; i < 2 * rRadius; i++) {
      for (int j = 0; j < 2 * rRadius; j++) {
        // photo.get(0,0) is the top left corner
        r += red(photo.get(rx - rRadius + i, ry - rRadius + j));
        g += green(photo.get(rx - rRadius + i, ry - rRadius + j));
        b += blue(photo.get(rx - rRadius + i, ry - rRadius + j));
      }
    }
    // Take mean.
    int numIterations = (4*rRadius*rRadius);
    r /= numIterations;
    g /= numIterations;
    b /= numIterations;
    this.dotColor = color(r, g, b);
  }
}
