//TODO: make image random and have an image select mode, animation, speed optimization
import java.util.LinkedList;

private float oldX;
private float oldY;
private LinkedList<Dot> dots = new LinkedList<Dot>();
private final ArrayList<Dot> newDividedDots = new ArrayList<Dot>(3);
private float MIN_DOT_SIZE;
static PImage photo;
PVector cursorPath;

void setup() {
  noStroke();
  size(1000, 1000);
  ellipseMode(RADIUS);
  oldX = mouseX;
  oldY = mouseY;
  frameRate(120);
  MIN_DOT_SIZE = min(height, width) / 128;
  photo = loadImage("hippo.jpg");
  photo.resize(width, height);
  dots.add(new Dot(width / 2, height / 2, width / 2));
}

void draw() {
  System.out.println(frameRate);
  background(0);
  cursorPath = new PVector(mouseX - oldX, mouseY - oldY);
  if (cursorPath.magSq() >= 1) { // If cursor has moved
    for (Dot dot : dots) {
      dot.drawDot();
      float radius = dot.getRadius();
      boolean pathStartsOutsideDot = dist(dot.getX(), dot.getY(), oldX, oldY) > radius;
      if (dot.isDivisible() && pathStartsOutsideDot && distToCursorPath(dot) <= radius) {
        divide(dot);
      }
    }
    oldX = mouseX;
    oldY = mouseY;
  } else {
    for (Dot dot : dots) {
      dot.drawDot();
    }
  }
  dots.addAll(newDividedDots);
  newDividedDots.clear();
}

void divide(Dot dot) {
  float halfRadius = dot.getRadius() / 2;
  newDividedDots.add(new Dot(dot.getX() + halfRadius, dot.getY() - halfRadius, halfRadius)); // Top Left
  newDividedDots.add(new Dot(dot.getX() - halfRadius, dot.getY() + halfRadius, halfRadius)); // Bottom Left
  newDividedDots.add(new Dot(dot.getX() + halfRadius, dot.getY() + halfRadius, halfRadius)); // Bottom Right

  // Convert dot to top left
  dot.setX(dot.getX() - halfRadius);
  dot.setY(dot.getY() - halfRadius);
  dot.setRadius(halfRadius);
}

//private boolean pathEntersDot(Dot dot, float ySlope, float yIntercept, float xSlope, float xIntercept) { //0 division
//  // Problem is poorly conditioned for large slope.
//  // We take the slope with respect to x or y, depending on which is less than 1
//  float[] intersectionPoint;
//  if (abs(ySlope) <= 1) {
//    intersectionPoint = calcIntersectionY(dot, ySlope, yIntercept);
//  } else {
//    intersectionPoint = calcIntersectionX(dot, ySlope, yIntercept);
//  }
//  return dist(intersectionPoint[0], intersectionPoint[1], dot.getX(), dot.getY()) <= dot.getRadius();

//}

//private float[] calcIntersectionY(Dot dot, float slope, float yIntercept) {
//   /* Want line to represent path
//     line must intersect oldX, oldY and mouseX, mouseY
//     m = (mouseY - oldY) / (mouseX - oldX)
//     y = mx +b -> oldY = moldX + b -> b = oldY - moldX
//     y = mx + b
//     x0, y0 center of dot. form perpendicular line
//     y = (-1/m)x + b0 -> y0 = (-1/m)x0 + b0 -> b0 = y0 - (-1/m)x0
//     find intersection of lines:
//     mx + b = (-1/m)x + y0 - (-1/m)x0 ->  mx - (-1/m)x = y0 - (-1/m)x0 - b
//     -> x = (y0  - (-x0/m) -b) / (m - (-1/m))
//     -> x = (y0m + x0 -bm) / (m^2 + 1)
//     -> y = m( x ) + b
//      x,y is intersection point of line
//   */
//  float intersectX = (dot.getY() * slope + dot.getX() - slope * yIntercept) / (slope * slope + 1); 
//  intersectX = constrain(intersectX, min(oldX, mouseX), max(oldX, mouseX));
//  float intersectY = (slope * intersectX) + yIntercept;
//  return new float[] {intersectX, intersectY};
//}

//private float[] calcIntersectionX(Dot dot, float slope, float xIntercept) {
//   /* Want line to represent path
//     line must intersect oldX, oldY and mouseX, mouseY
//     x = slope * y + xIntercept
//     x0, y0 center of dot. form perpendicular line
//     x = (-1/slope)*y + b0
//     x0 = (-1/slope)*y0 + b0 -> x0 + (1/slope)*y0 = b0
//     find intersection of lines:
//     slope*y + xIntercept = (-1/slope)*y + b0
//     -> slope*y + xIntercept = (-1/slope)*y + x0 + (1/slope)*y0
//     -> slope*y + (1/slope)*y = x0 + (1/slope)*y0 - xIntercept
//     -> y = (x0 + (1/slope)*y0 - xIntercept) / (slope + 1/slope) 
//     -> y = (x0*slope + y0 + xIntercept*slope) / (slope^2 + 1)
//     -> x = slope*y + xIntercept
//      x,y is intersection point of line
//   */
//  float intersectY = (dot.getX() * slope + dot.getY() + xIntercept * slope) / (slope * slope + 1); 
//  intersectY = constrain(intersectY, min(oldY, mouseY), max(oldY, mouseY));
//  float intersectX = (slope * intersectY) + xIntercept; 
//  return new float[] {intersectX, intersectY};
//}

private float distToCursorPath(Dot dot) {
  PVector oldCursorToDot = new PVector(dot.getX() - oldX, dot.getY() - oldY);
  PVector currentCursorToDot = new PVector(dot.getX() - mouseX, dot.getY() - mouseY);
  PVector reverseCursorPath = PVector.mult(cursorPath, -1); //CurrentToOld
  // If both of the below angles are acute , then the dot is between the endpoints and the closest 
  // point to the dot is along the path. If one of these is obtuse, the dot is past that endpoint 
  // and the closest point to the dot is that endpoint.
  float angleOldToCurrent_OldToDot = PVector.angleBetween(cursorPath, oldCursorToDot);
  if (angleOldToCurrent_OldToDot > PI / 2) {
    return dist(dot.getX(), dot.getY(), oldX, oldY);
  }
  float angleCurrentToOld_CurrentToDot = PVector.angleBetween(reverseCursorPath, currentCursorToDot);
  if (angleCurrentToOld_CurrentToDot > PI / 2) {
    return dist(dot.getX(), dot.getY(), mouseX, mouseY);
  }
  return sin(angleOldToCurrent_OldToDot) * oldCursorToDot.mag(); //angles always positive -> sin(angle) always positive. Careful with zero vector!
}
