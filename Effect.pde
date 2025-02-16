// List of fireworks
ArrayList<Firework> fireworks = new ArrayList<Firework>();

// Firework class
class Firework {
  float x, y, speed;
  boolean exploded = false;
  ArrayList<Particle> particles = new ArrayList<Particle>();
  color fireworkColor;

  Firework(float startX, float startY, color c) {
    x = startX; // Random X launch position
    y = startY;  // Start from bottom
    speed = random(-10, -15);  // Random launch speed
    fireworkColor = c; // Assign color
  }

  void update() {
    if (!exploded) {
      y += speed;  // Move up
      speed += 0.1; // Gravity effect
      if (speed >= 0) { // When it reaches peak, explode
        explode();
      }
    } else {
      for (int i = particles.size() - 1; i >= 0; i--) {
        Particle p = particles.get(i);
        p.update();
        if (p.isDone()) {
          particles.remove(i);
        }
      }
    }
  }

  void display() {
    if (!exploded) {
      fill(fireworkColor);
      noStroke();
      ellipse(x, y, 5, 5); // Firework core before explosion
    } else {
      for (Particle p : particles) {
        p.display();
      }
    }
  }

  void explode() {
    exploded = true;
    for (int i = 0; i < 30; i++) { // Bigger explosion
      particles.add(new Particle(x, y, fireworkColor));
    }
  }

  boolean isDone() {
    return exploded && particles.isEmpty();
  }
}

// Particle class for firework explosion
class Particle {
  float x, y, vx, vy, alpha;
  color particleColor;

  Particle(float x, float y, color c) {
    this.x = x;
    this.y = y;
    float angle = random(TWO_PI); // Random explosion direction
    float speed = random(3, 6); // Bigger explosion range
    vx = cos(angle) * speed;
    vy = sin(angle) * speed;
    alpha = 255; // Fading effect
    particleColor = c; // Assign color
  }

  void update() {
    x += vx;
    y += vy;
    vy += 0.1; // Gravity pulls particles down
    alpha -= 4; // Fade out
  }

  void display() {
    noStroke();
    fill(particleColor, alpha);
    ellipse(x, y, 5, 5); // Draw explosion particles
  }

  boolean isDone() {
    return alpha <= 0;
  }
}

// Firework effect function
void drawFireworks() {
  if (frameCount % 10 == 0) { // Generate fireworks periodically
    color fireworkColor;
    
    if (winnerText.equals("Red Player Wins!")) {
      fireworkColor = color(random(100, 255), 0,0); // Random colors
    } 
    else if (winnerText.equals("Blue Player Wins!")) {
      fireworkColor = color(0, 0, random(100, 255)); // Blue gradient
    } 
    else { // Tie case: Red and Blue fireworks
      if (random(1) > 0.5) {
        fireworkColor = color(255, 0, 0); // Red
      } else {
        fireworkColor = color(0, 0, 255); // Blue
      }
    }

    fireworks.add(new Firework(random(width), height, fireworkColor));
  }

  for (int i = fireworks.size() - 1; i >= 0; i--) {
    Firework f = fireworks.get(i);
    f.update();
    f.display();
    if (f.isDone()) {
      fireworks.remove(i);
    }
  }
}
