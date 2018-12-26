class AnimatedSection {
  float x;
  float y;
  Dot[] animatedDots;
  float sideLength;
  
  AnimatedSection(Dot dot) {
    x = dot.getX();
    y = dot.getY();
    sideLength = dot.getRadius() * 2;
    
    float halfOldRadius = sideLength / 4;
    //dot.divide(x - halfOldRadius, y - halfOldRadius);
    //Dot topLeft = dot; // Avoid unecessary creation/deletion
    Dot topLeft = new Dot(x - halfOldRadius, y - halfOldRadius, halfOldRadius);
    Dot topRight = new Dot(x + halfOldRadius, y - halfOldRadius, halfOldRadius);
    Dot bottomLeft = new Dot(x - halfOldRadius, y + halfOldRadius, halfOldRadius);
    Dot bottomRight = new Dot(x + halfOldRadius, y + halfOldRadius, halfOldRadius);
    animatedDots = new Dot[] {topLeft, topRight, bottomLeft, bottomRight};
  }
  
  boolean drawSection() {
    fill(0);
    rect(x, y, sideLength, sideLength);
    boolean doneAnimating = true;
    for (Dot dot : animatedDots) {
      if(!dot.drawDot(x, y)) {
        doneAnimating = false;
      }
    }
    return doneAnimating;
  }
  
  Dot[] getDotsCreated() {
    return animatedDots;
  }
  
}
