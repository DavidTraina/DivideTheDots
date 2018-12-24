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
  public static final long DELAY_UNTIL_DIVISIBLE = 100;

  /**
   * Create a new Dot. This counts as a division because we call setRadius().
   *
   * @param x      The x position of the center of the Dot.
   * @param y      The y position of the center of the Dot.
   * @param radius The radius of the DOt, in pixels.
   */
  Dot(float x, float y, float radius) {
    this.x = x;
    this.y = y;
    setRadius(radius);
  }

  /**
   * Draw the Dot to the screen.
   */
  void drawDot() {
    fill(dotColor);
    ellipse(x, y, radius, radius);
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
   * Set the y position of the center of the Dot.
   * @param y the new x position of the center of the Dot.
   */
  void setY(float y) {
    this.y = y;
  }

  /**
   * Return the radius of the Dot.
   * @return The radius of the Dot.
   */
  float getRadius() {
    return radius;
  }

  /**
   * Set the radius the Dot and update the color accordingly. Indicates a division.
   * @param radius The new radius of the Dot.
   */
  void setRadius(float radius) {
    this.radius = radius;   
    calculateColor();
    timeLastDivided = millis();
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
   * in the last DELAY_UNTIL_DIVISIBLE seconds, indicating that the dot can be divided.
   *
   * @return true iff the dot can be divided.
   */
  boolean isDivisible() {
    return (millis() - timeLastDivided) > DELAY_UNTIL_DIVISIBLE && radius > MIN_DOT_SIZE;
  }
}
