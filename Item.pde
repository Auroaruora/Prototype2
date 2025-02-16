// Items
class Item {
  float x, y;
  boolean isEaten;
  
  Item() {
    respawn();
  }
  
  void respawn() {
    int col = int(random(cols));
    int row = int(random(rows));
    x = col * cellSize + cellSize/2;
    y = row * cellSize + cellSize/2;
    isEaten = false;
  }
  
  void display() {
    if (!isEaten) {
      fill(0, 255, 0);
      ellipse(x, y, 10, 10);
    }
  }
}

void playBeep(SinOsc osc, float frequency) {
  osc.freq(frequency);
  osc.amp(0.5);
  osc.play();
  
  delay(100);
  osc.stop();
}

void checkItemCollision() {
  for (Item item : items) {
    if (!item.isEaten) {
      boolean p1Collides = dist(player1X, player1Y, item.x, item.y) < playerRadius + 5;
      boolean p2Collides = dist(player2X, player2Y, item.x, item.y) < playerRadius + 5;
      
      if (p1Collides) {
        player1Score++;
        item.isEaten = true;
        item.respawn();
        playBeep(redSound, 800);
      } else if (p2Collides) {
        player2Score++;
        item.isEaten = true;
        item.respawn();
        playBeep(blueSound, 400);
      }
    }
  }
}
