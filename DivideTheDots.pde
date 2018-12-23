float old_x = 0;
float old_y = 0;
ArrayList<Dot> deadDots = new ArrayList<Dot>();
ArrayList<Dot> activeDots = new ArrayList<Dot>();
ArrayList<Dot> dotsToDivide = new ArrayList<Dot>();

void setup() {
  size(1000,1000);
  smooth(16);
  ellipseMode(RADIUS);
  frameRate(120);
  activeDots.add(new Dot(width / 2, height / 2, width / 2));
}

void draw() {
  System.out.println(frameRate);
  background(0);
  divide();
  for (Dot dot : activeDots) {
    if (dot.getRadius() > (width / 128) && dist(old_x, old_y, dot.getX(), dot.getY()) > dot.getRadius() && dist(mouseX, mouseY, dot.getX(), dot.getY()) <= dot.getRadius()) {
      dotsToDivide.add(dot);
    }
    dot.drawDot();
  }
  for (Dot dot : deadDots) {
    dot.drawDot();
  }
  old_x = mouseX;
  old_y = mouseY;
}

void divide() {
  for (Dot dot: dotsToDivide) {
    activeDots.remove(dot);
    Dot topLeft = new Dot(dot.getX() - (dot.getRadius() / 2), dot.getY() - (dot.getRadius() / 2), dot.getRadius() / 2);
    Dot topRight = new Dot(dot.getX() + (dot.getRadius() / 2), dot.getY() - (dot.getRadius() / 2), dot.getRadius() / 2);
    Dot bottomLeft = new Dot(dot.getX() - (dot.getRadius() / 2), dot.getY() + (dot.getRadius() / 2), dot.getRadius() / 2);
    Dot bottomRight = new Dot(dot.getX() + (dot.getRadius() / 2), dot.getY() + (dot.getRadius() / 2), dot.getRadius() / 2);
    ArrayList<Dot> listToAddTo;
    if (dot.getRadius() / 2 > width / 128) {
      listToAddTo = activeDots;
    } else {
      listToAddTo = deadDots;
    }
    listToAddTo.add(topLeft);
    listToAddTo.add(topRight);
    listToAddTo.add(bottomLeft);
    listToAddTo.add(bottomRight);
  }
  dotsToDivide.clear();
}
