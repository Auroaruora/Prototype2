// Create a list of raindrops
ArrayList<RainDrop> rain = new ArrayList<RainDrop>();

void drawRain() {
  for (int i = rain.size() - 1; i >= 0; i--) {
    RainDrop r = rain.get(i);
    r.fall();
    r.display();
    if (r.offScreen()) {
      rain.remove(i);
    }
  }
  
  // Add new raindrops
  if (frameCount % 2 == 0) { // Control density of rain
    rain.add(new RainDrop());
  }
}

class RainDrop {
  float x, y, speed;

  RainDrop() {
    x = random(width);  // Random X position
    y = random(-100, 0);  // Start above screen
    speed = random(4, 10);  // Random falling speed
  }

  void fall() {
    y += speed;
  }

  void display() {
    stroke(0);
    strokeWeight(2);
    line(x, y, x, y + 10);  // Draw raindrop as a short line
  }

  boolean offScreen() {
    return y > height; // Remove raindrop when it reaches the bottom
  }
}


// List of fireworks
ArrayList<Firework> fireworks = new ArrayList<Firework>();

void drawFireworks() {
  // Update and display fireworks
  for (int i = fireworks.size() - 1; i >= 0; i--) {
    Firework f = fireworks.get(i);
    f.update();
    f.display();
    if (f.isDone()) {
      fireworks.remove(i);
    }
  }

  // Launch new fireworks randomly across the entire width
  if (random(1) < 0.05) { // Adjust probability for density
    fireworks.add(new Firework(random(width), height));
  }
}

// Firework class
class Firework {
  float x, y, speed;
  boolean exploded = false;
  ArrayList<Particle> particles = new ArrayList<Particle>();

  Firework(float startX, float startY) {
    x = startX; // Random X launch position
    y = startY;  // Start from bottom
    speed = random(-10, -15);  // Random launch speed
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
      fill(255, 200, 0);
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
    for (int i = 0; i < 30; i++) { // Increase explosion size
      particles.add(new Particle(x, y));
    }
  }

  boolean isDone() {
    return exploded && particles.isEmpty();
  }
}

// Particle class for firework explosion
class Particle {
  float x, y, vx, vy, alpha;

  Particle(float x, float y) {
    this.x = x;
    this.y = y;
    float angle = random(TWO_PI); // Random explosion direction
    float speed = random(3, 6); // Bigger explosion range
    vx = cos(angle) * speed;
    vy = sin(angle) * speed;
    alpha = 255; // Fading effect
  }

  void update() {
    x += vx;
    y += vy;
    vy += 0.1; // Gravity pulls particles down
    alpha -= 4; // Fade out
  }

  void display() {
    noStroke();
    fill(255, 100, 0, alpha);
    ellipse(x, y, 5, 5); // Draw explosion particles
  }

  boolean isDone() {
    return alpha <= 0;
  }
}

void drawHeartbeatLine() {
  stroke(0);
  strokeWeight(3);

  float baselineY = height - 100;
  float lastX = 0;
  float lastY = baselineY;

  for (float x = 0; x < width; x += random(15, 30)) {
    float y = baselineY + random(-10, 10);
    line(lastX, lastY, x, y);
    lastX = x;
    lastY = y;
  }
}
