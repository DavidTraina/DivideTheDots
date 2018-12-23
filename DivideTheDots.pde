import java.util.LinkedList;

private float old_x = 0;
private float old_y = 0;
private LinkedList<Dot> dots = new LinkedList<Dot>();
private final ArrayList<Dot> newDividedDots = new ArrayList<Dot>(3);
private float MIN_DOT_SIZE;
static PImage photo;

void setup() {
  noStroke();
  size(1000, 1000);
  ellipseMode(RADIUS);
  frameRate(120);
  MIN_DOT_SIZE = min(height, width) / 128;
  photo = loadImage("zebra.jpg");
  photo.resize(width, height);
  dots.add(new Dot(width / 2, height / 2, width / 2));
}

void draw() {
  System.out.println(frameRate);
  background(0);
  for (Dot dot : dots) {
    dot.drawDot();
    if (dot.getRadius() > MIN_DOT_SIZE && dist(old_x, old_y, dot.getX(), dot.getY()) > dot.getRadius() && 
      dist(mouseX, mouseY, dot.getX(), dot.getY()) <= dot.getRadius()) {
      divide(dot);
    }
  }
  dots.addAll(newDividedDots);
  newDividedDots.clear();
  old_x = mouseX;
  old_y = mouseY;
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
