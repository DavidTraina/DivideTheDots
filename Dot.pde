/**
 * A Dot; represented as a single circle on-screen.
 */
class Dot {

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
   * Create a new Dot. This counts as a division because we call setRadius().
   *
   * @param x            The x position of the center of the Dot.
   * @param y            The y position of the center of the Dot.
   * @param oldDotX      The oldDotX position of the center of the Dot.
   * @param oldDotY      The oldDotY position of the center of the Dot.
   * @param radius       The radius of the DOt, in pixels.
   */
  Dot(float x, float y, float radius) {
    this.radius = 2 * radius;
    divide(x, y);
  }

  /**
   * Draw the Dot to the screen. Return True iff dot is done animating. 
   * Important we check this at time of drawing and not before or after 
   * so we do not get innacurate results due to imprecise timing.
   */
  boolean drawDot(float oldDotX, float oldDotY) {
    boolean doneAnimating = false;
    float displayX, displayY, displayR, percentComplete;
    long timeSinceDivision = millis() - timeLastDivided;
    if (timeSinceDivision >= ANIMATION_TIME) {
      percentComplete = 1;
      doneAnimating = true;
    } else {
      percentComplete = (float) timeSinceDivision / ANIMATION_TIME;
    }
    float xDiff = x - oldDotX;
    float yDiff = y - oldDotY;
    float rDiff = -radius; //radius - oldRadius = radius - 2*radius = -radius
    displayX = oldDotX + (percentComplete * xDiff);
    displayY = oldDotY + (percentComplete * yDiff);
    displayR = (2 * radius) + (percentComplete * rDiff);
    fill(dotColor);
    ellipse(displayX, displayY, displayR, displayR);
    return doneAnimating;
  }
  
  void drawDot() {
    fill(dotColor);
    ellipse(x, y, radius, radius);
  }

  void divide(float x, float y) {
    this.x = x;
    this.y = y;
    radius /= 2;
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
   * Set the x position of the center of the Dot.
   * @param x the new x position of the center of the Dot.
   */
  void setX(float x) {
    this.x = x;
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
   * Caculate the value of dotColor; the fill color of the Dot. Accomplishes this by 
   * averaging the colors of the pixels of photo which are overapped by the square 
   * centered at (x,y) with side length 2* radius. This is the square centered around 
   * the Dot and of minimal size such that it still contains the Dot.
   */
  private void calculateColor() {
    // Update the pixels[] array for photo
    photo.loadPixels();

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

  /**
   * Return true iff radius is larger than the minimal Dot radius and the Dot hasn't been divided 
   * in the last DELAY_UNTIL_DIVISIBLE milliseconds, indicating that the dot can be divided.
   *
   * @return true iff the dot can be divided.
   */
  boolean isAnimating() {
    return (millis() - timeLastDivided) <= ANIMATION_TIME;
  }
}
