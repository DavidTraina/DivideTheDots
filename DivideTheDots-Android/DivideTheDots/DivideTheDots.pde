import java.util.LinkedList;

/**
 * A game where the user moves the cursor to divide the single starting dot into successivly smaller dots. 
 * The dots act like pixels to reveal a picture.
 */

/**
 * The maximum number of times a dot can be divided.
 */
private static final int MAX_DOT_DIVISIONS = 9; 

/**
 * The minimal radius of a dot, in pixels.
 */
private float MIN_DOT_SIZE;

/**
 * The smallest radius a dot can have before the program makes it easier to clear.
 */
private static float MIN_UNASSISTED_RADIUS; 


/**
 * All the Dots on the screen that are greater than MIN_DOT_SIZE.
 */
private LinkedList<Dot> dots;

/**
 * All the AnimatedSections currently being animated (drawn each frame).
 */
private LinkedList<AnimatedSection> sections;

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
 * Sets up the program, runs at program start-up / reset.
 */
void setup() {
  ////////////////////////////////////
  //  CHANGE BACKGROUND IMAGE HERE  //
  //                                //
  // If you would like a non-random //
  // image, add the file-name of    //
  // the image in quotes as an      //
  // argument to the setupPhoto()   //
  // call below. For example,       //
  // setupPhoto("example.jpg")      //
  // If you would like a random     //
  // image, use the empty string    //
  // as the argument.               //
  //                                //
  // NOTE: If you use your own      //
  // image, place the image in the  //
  // data folder. The image should  //
  // be square or it will appear    //
  // distorted.                     //
  ////////////////////////////////////
  setupPhoto(""); //
  ////////////////////////////////////
  
  // Cannot use variables in size(), assuming displayHeight < dislayWidth;
  size(displayWidth, displayWidth); 
  photo.resize(width, height);
  // Update the pixels[] array for photo
  photo.loadPixels();
  
  frameRate(60);
  noStroke();
  ellipseMode(RADIUS);
  rectMode(CENTER);
  int minHeightWidth = min(height, width);
  
  MIN_DOT_SIZE = minHeightWidth / pow(2, MAX_DOT_DIVISIONS);
  MIN_UNASSISTED_RADIUS = minHeightWidth / pow(2, 7);

  sections = new LinkedList<AnimatedSection>();
  dots = new LinkedList<Dot>();
  Dot firstDot = new Dot(width / 2, height / 2, height / 2);
  dots.add(firstDot);

  background(0);
  firstDot.drawDot();
}

private void setupPhoto(String photoName) {
  boolean validName = false;
  String[] photoNames = loadStrings("fileNames.txt");
  for (String name : photoNames) {
    if (name.equals(photoName)) {
      validName = true;
      break;
    }
  }
  if (!validName) {
    photoName = photoNames[(int) random(photoNames.length)];
  }
  photo = loadImage(photoName);
}

/**
 * Runs frameRate times per second. If cursor has moved then iterate through the dots on the screen and divide them as necessary.
 */
void draw() {
  drawSections();
  cursorPath = new PVector(mouseX - pmouseX, mouseY - pmouseY);
  // If the cursor has moved. 
  if (cursorPath.magSq() >= 1) { 
    LinkedList<Dot> tempDotsToRemove = new LinkedList<Dot>();
    for (Dot dot : dots) {
      float radius = dot.getRadius();
      // dot should only divide if cursor starts outside of dot and then enters it.
      boolean pathStartsOutsideDot = dist(dot.getX(), dot.getY(), pmouseX, pmouseY) > radius; 
      if (pathStartsOutsideDot && pathIntersectsDot(dot)) {
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
      Dot[] dotsCreated = section.getDotsCreated();
      // All dots in section same size, if Dot is min size, don't add the Dots from this 
      // section to dots because we don't want to divide them anymore.
      if (dotsCreated[0].getRadius() > MIN_DOT_SIZE) { 
        for (Dot dot : dotsCreated) {
          dots.add(dot);
        }
      }
      tempSectionsToRemove.add(section);
    }
  }
  sections.removeAll(tempSectionsToRemove);
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
  float maxDistance;
  float radius = dot.getRadius();
  if (radius < MIN_UNASSISTED_RADIUS) {
    // It's annoyingly difficult to clear the very small dots, so we make it slightly more forgiving.
    maxDistance =  radius * 1.4;
  } else {
    maxDistance = radius;
  }
  return distToCursorPath(dot) <= maxDistance;
}

void keyPressed() {
  if (key == ' ' || key == 'n' || key == 'r') {
    setup();
    println("reset");
  }
}
