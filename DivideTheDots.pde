/**
* A game where the user moves the cursor to divide the single starting dot into successivly smaller dots. 
* The dots act like pixels to reveal a picture.
*/

//TODO: make image random and have an image select mode, animation
import java.util.LinkedList;


/**
 * The maximum number of times a dot can be divided.
 */
private final int MAX_DOT_DIVISIONS = 8; 

/**
 * The x position of the cursor in the previous frame.
 */
private int oldX;

/**
 * The y position of the cursor in the previous frame.
 */
private int oldY;

/**
 * All the Dots on the screen.
 */
private final LinkedList<Dot> dots = new LinkedList<Dot>();

/**
 * The new Dots that were created during the division of another Dot during the current frame. Contents 
 * should be added to dots and then cleared in every frame a division happens.
 */
private final ArrayList<Dot> newDividedDots = new ArrayList<Dot>();

/**
 * The minimal radius of a dot, in pixels.
 */
private float MIN_DOT_SIZE;

/**
 * The background image that will be revealed.
 */
static PImage photo;

/**
 * A vector from the cursor position in the previous frame to the current cursor position.
 * Linearly approximates the path the cursor took between frames.
 */
PVector cursorPath;

/**
 * Sets up the program, runs one time only on start-up.
 */
void setup() {
  size(1000, 1000);
  frameRate(100);

  smooth(2);
  noStroke();
  ellipseMode(RADIUS);
  rectMode(CENTER);

  //////////////////////////////////
  // CHANGE BACKGROUND IMAGE HERE //
  //////////////////////////////////
  photo = loadImage("hippo.jpg");
  photo.resize(width, height);

  oldX = mouseX;
  oldY = mouseY;

  MIN_DOT_SIZE = min(height, width) / pow(2, MAX_DOT_DIVISIONS);

  background(0);
  dots.add(new Dot(width / 2, height / 2, width / 2));
  dots.get(0).drawDot();
}

/**
 * Runs frameRate times per second. If cursor has moved then iterate through the dots on the screen and divide them as necessary.
 */
void draw() {
  println(frameRate);
  cursorPath = new PVector(mouseX - oldX, mouseY - oldY);

  // If the cursor has moved. 
  if (cursorPath.magSq() >= 1) { 
    for (Dot dot : dots) {
      float radius = dot.getRadius();
      // dot should only divide if cursor starts outside of dot and then enters it.
      boolean pathStartsOutsideDot = dist(dot.getX(), dot.getY(), oldX, oldY) > radius; 
      // if the distance from the center of dot to cursorPath is <= radius, then cursorPath intersects dot.
      if (dot.isDivisible() && pathStartsOutsideDot && distToCursorPath(dot) <= radius) {
        // Black out the dot we are going to divide.
        fill(0);
        rect(dot.getX(), dot.getY(), radius * 2, radius * 2);
        divide(dot);
        // Draw the modified version of dot because it will not be newDividedDots.
        dot.drawDot();
      }
    }
    // We do this outside the loop for efficiency, so we do not draw a dot more than once.
    for (Dot newDot : newDividedDots) {
      newDot.drawDot();
    }
    dots.addAll(newDividedDots);
    newDividedDots.clear();

    oldX = mouseX;
    oldY = mouseY;
  }
}

/**
 * Convert dot into a 2x2 formation of 4 dots occupying the same space. The radius of the new dots will be half the radius of dot.
 *
 * @param dot The Dot to divide
 */
void divide(Dot dot) {
  float halfRadius = dot.getRadius() / 2;
  // Top right of 2x2 formation.
  newDividedDots.add(new Dot(dot.getX() + halfRadius, dot.getY() - halfRadius, halfRadius));
  // Bottom left of 2x2 formation.
  newDividedDots.add(new Dot(dot.getX() - halfRadius, dot.getY() + halfRadius, halfRadius));
  // Bottom right of 2x2 formation.
  newDividedDots.add(new Dot(dot.getX() + halfRadius, dot.getY() + halfRadius, halfRadius)); 
  // Convert dot to top left of 2x2 formation (avoids deletion and creation of another dot).
  dot.setX(dot.getX() - halfRadius);
  dot.setY(dot.getY() - halfRadius);
  dot.setRadius(halfRadius);
}

/**
 * Return the minimal distance from the center of dot to anywhere on the cursorPath vector.
 * 
 * @param dot The dot which we are computing the distance to.
 * @return the minimal distance from the center of dot to anywhere on the cursorPath vector.
 */
private float distToCursorPath(Dot dot) {
  PVector oldCursorToDot = new PVector(dot.getX() - oldX, dot.getY() - oldY); // Vector from old cursor position to center of dot.
  PVector currentCursorToDot = new PVector(dot.getX() - mouseX, dot.getY() - mouseY); // Vector from current cursor position to center of dot.
  PVector reverseCursorPath = PVector.mult(cursorPath, -1); // Vector from the current cursor position to the old cursor position.

  // Case (1)
  float angleOldToCurrent_OldToDot = PVector.angleBetween(cursorPath, oldCursorToDot);
  /*
   If the angle between these vectors is obtuse, then the dot lies behind the cursorPath 
   vector and the point on the cursorPath vector which is closest to dot is the starting 
   point; the old cursor position.
   */
  if (angleOldToCurrent_OldToDot > PI / 2) {
    return dist(dot.getX(), dot.getY(), oldX, oldY);
  }

  // Case (2)
  float angleCurrentToOld_CurrentToDot = PVector.angleBetween(reverseCursorPath, currentCursorToDot);
  /*
   If the angle between these vectors is obtuse, then the dot lies in front of the cursorPath 
   vector and the point on the cursorPath vector which is closest to dot is the ending point; the 
   current cursor position.
   */
  if (angleCurrentToOld_CurrentToDot > PI / 2) {
    return dist(dot.getX(), dot.getY(), mouseX, mouseY);
  }

  // Case (3)
  /* 
   If both of the above angles are acute, then the dot is between the endpoints of the cursorPath vector and the 
   point on the path which is closest to the dot is somewhere along the path and not one of the endpoints. The 
   magnitude of vector perpendicular to cursorPath with endpoints at the intersection points of dot and cursorPath 
   is the minimal distance from dot to cursorPath. We calculate this by forming a right triangle and using trigonometry.
   */
  return sin(angleOldToCurrent_OldToDot) * oldCursorToDot.mag(); // Angles always positive for non-zero vectors -> sin(angle) is positive.
}
