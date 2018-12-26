/**
 * A game where the user moves the cursor to divide the single starting dot into successivly smaller dots. 
 * The dots act like pixels to reveal a picture.
 */

//TODO: animation
import java.util.LinkedList;
import java.util.Arrays;

/**
 * The maximum number of times a dot can be divided.
 */
private final int MAX_DOT_DIVISIONS = 9; 


/**
 * All the Dots on the screen.
 */
private LinkedList<Dot> dots;

/**
 * The new Dots that were created during the division of another Dot during the current frame. Contents 
 * should be added to dots and then cleared in every frame a division happens.
 */
//private  ArrayList<Dot> newDividedDots = new ArrayList<Dot>();

private LinkedList<AnimatedSection> sections;

//private  LinkedList<Dot> animatingDots = new LinkedList<Dot>(); 

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
  /// Photo Stuff ///
  String photoName;

  /**
   * Set true for a random photo each time the program starts.
   */
  boolean randomImage = false;
  if (!randomImage) {


    //////////////////////////////////
    // CHANGE BACKGROUND IMAGE HERE //
    //                              //
    // Make sure to set randomImage //
    // to flase above.              //
    //                              //
    // NOTE: Image should be square //
    // or it will appear distorted. //
    //////////////////////////////////
    photoName = "circleGame.jpg";
  } else {
    // Change path to images as required, should be in data folder.
    File pathToImages = new File("C:\\Users\\David\\Dropbox\\Processing\\DotsSandbox\\DivideTheDots\\data");
    String[] photoNames = pathToImages.list();
    photoName = photoNames[floor(random(photoNames.length))];
  }
  photo = loadImage(photoName);

  // Cannot use variables in size(), assuming displayHeight < dislayWidth;
  size(displayHeight, displayHeight); 

  photo.resize(width, height);

  frameRate(100);

  //smooth(2);
  noStroke();
  ellipseMode(RADIUS);
  rectMode(CENTER);
  MIN_DOT_SIZE = min(height, width) / pow(2, MAX_DOT_DIVISIONS);

  sections = new LinkedList<AnimatedSection>();
  dots = new LinkedList<Dot>();
  Dot firstDot = new Dot(width / 2, height / 2, height / 2);
  dots.add(firstDot);

  background(0);
  firstDot.drawDot();
}

/**
 * Runs frameRate times per second. If cursor has moved then iterate through the dots on the screen and divide them as necessary.
 */
void draw() {
  println(frameRate);
  drawSections();

  cursorPath = new PVector(mouseX - pmouseX, mouseY - pmouseY);

  // If the cursor has moved. 
  if (cursorPath.magSq() >= 1) { 
    LinkedList<Dot> tempDotsToRemove = new LinkedList<Dot>();
    for (Dot dot : dots) {
      //animating dots
      float radius = dot.getRadius();
      // dot should only divide if cursor starts outside of dot and then enters it.
      boolean pathStartsOutsideDot = dist(dot.getX(), dot.getY(), pmouseX, pmouseY) > radius; 
      // if the distance from the center of dot to cursorPath is <= radius, then cursorPath intersects dot.
      if (radius > MIN_DOT_SIZE && pathStartsOutsideDot && pathIntersectsDot(dot)) {
        sections.add(new AnimatedSection(dot));
        tempDotsToRemove.add(dot);
      }
    }
    dots.removeAll(tempDotsToRemove);
  }
}

void drawSections() {
  LinkedList<AnimatedSection> tempSectionsToRemove = new LinkedList<AnimatedSection>();

  for (AnimatedSection section : sections) {
    if (section.drawSection()) {
      for (Dot dot : section.getDotsCreated()) {
        dots.add(dot);
      }
      tempSectionsToRemove.add(section);
    }
  }
  sections.removeAll(tempSectionsToRemove);
  //tempSectionsToRemove.clear();
}

/**
 * Return the minimal distance from the center of dot to anywhere on the cursorPath vector.
 * 
 * @param dot The dot which we are computing the distance to.
 * @return the minimal distance from the center of dot to anywhere on the cursorPath vector.
 */
private float distToCursorPath(Dot dot) {
  PVector oldCursorToDot = new PVector(dot.getX() - pmouseX, dot.getY() - pmouseY); // Vector from old cursor position to center of dot.
  PVector currentCursorToDot = new PVector(dot.getX() - mouseX, dot.getY() - mouseY); // Vector from current cursor position to center of dot.
  PVector reverseCursorPath = PVector.mult(cursorPath, -1); // Vector from the current cursor position to the old cursor position.

  // Case (1)
  float angleOldToCurrent_OldToDot = PVector.angleBetween(cursorPath, oldCursorToDot);
  /*
   If the angle between these vectors is obtuse, then the dot lies behind the cursorPath 
   vector and the point on the cursorPath vector which is closest to dot is the starting 
   point; the old cursor position.
   */
  if (angleOldToCurrent_OldToDot > HALF_PI) {
    return dist(dot.getX(), dot.getY(), pmouseX, pmouseY);
  }

  // Case (2)
  float angleCurrentToOld_CurrentToDot = PVector.angleBetween(reverseCursorPath, currentCursorToDot);
  /*
   If the angle between these vectors is obtuse, then the dot lies in front of the cursorPath 
   vector and the point on the cursorPath vector which is closest to dot is the ending point; the 
   current cursor position.
   */
  if (angleCurrentToOld_CurrentToDot > HALF_PI) {
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

boolean pathIntersectsDot(Dot dot) {
  float requiredDistance;
  float radius = dot.getRadius();
  if (MAX_DOT_DIVISIONS > 8) {
    // It's annoyingly difficult to clear the very small dots, so we make it slightly more forgiving.
       requiredDistance = max(radius, min(height, width) / (pow(2, 7) * 1.4));
  }
  else {
    requiredDistance = radius;
  }
  return distToCursorPath(dot) <= requiredDistance;
}

//// Misses dots sometimes??
//private float calcDistance(Dot dot) {
//  PVector oldCursorToDot = new PVector(dot.getX() - pmouseX, dot.getY() - pmouseY); // Vector from old cursor position to center of dot.
//  // a onto b
//  float magnitudeOfProjectionOntoCursorPath = PVector.dot(cursorPath, oldCursorToDot) / cursorPath.mag();
//  if (magnitudeOfProjectionOntoCursorPath <= 0) {
//    return dist(dot.getX(), dot.getY(), pmouseX, pmouseY);
//  } else if (magnitudeOfProjectionOntoCursorPath >= cursorPath.mag()) {
//    return dist(dot.getX(), dot.getY(), mouseX, mouseY);
//  } else {
//    PVector projectionOntoCursorPath = PVector.mult(cursorPath, magnitudeOfProjectionOntoCursorPath); 
//    PVector closestPoint = PVector.add(new PVector(pmouseX, pmouseY), projectionOntoCursorPath);
//    return (PVector.sub(closestPoint, new PVector(dot.getX(), dot.getY()))).mag();
//  }
//}

void keyPressed() {
  if (key == ' ' || key == 'n' || key == 'r') {
      setup();
  }
}
