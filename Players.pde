// Move players **smoothly**
void movePlayers() {
  float newP1X = player1X, newP1Y = player1Y;
  float newP2X = player2X, newP2Y = player2Y;
  // **Player 1 Movement**
  if (wPressed) newP1Y -= playerSpeed;
  if (sPressed) newP1Y += playerSpeed;
  if (aPressed) newP1X -= playerSpeed;
  if (dPressed) newP1X += playerSpeed;

  // **Player 2 Movement**
  if (upPressed) newP2Y -= playerSpeed;
  if (downPressed) newP2Y += playerSpeed;
  if (leftPressed) newP2X -= playerSpeed;
  if (rightPressed) newP2X += playerSpeed;

  // **Wall Collision Detection**
  if (!hitsWall(newP1X, newP1Y)) { player1X = newP1X; player1Y = newP1Y; }
  if (!hitsWall(newP2X, newP2Y)) { player2X = newP2X; player2Y = newP2Y; }

  // **Winning Condition**
  if (dist(player1X, player1Y, player2X, player2Y) < 20) {
    if (player1Score > player2Score) {
      winnerText = "Red Player Wins!";
    } else if (player2Score > player1Score) {
      winnerText = "Blue Player Wins!";
    } else {
      winnerText = "It's a Tie!";
    }
    gameOver = true;
    noLoop();
  }
}

// Draw players with **limited vision**
void drawPlayers() {
  // Player 1 (Red)
  fill(255, 0, 0);
  ellipse(player1X, player1Y, 20, 20);

  // Player 2 (Blue)
  fill(0, 0, 255);
  ellipse(player2X, player2Y, 20, 20);
}

// **Smooth movement control using key states**
void keyPressed() {
  if (key == 'w') wPressed = true;
  if (key == 's') sPressed = true;
  if (key == 'a') aPressed = true;
  if (key == 'd') dPressed = true;

  if (keyCode == UP) upPressed = true;
  if (keyCode == DOWN) downPressed = true;
  if (keyCode == LEFT) leftPressed = true;
  if (keyCode == RIGHT) rightPressed = true;
  
  // Restart game when Enter is pressed
  if (keyCode == ENTER && gameOver==true) {
    gameOver = false;
    resetGame();
    loop(); // Ensure draw() runs again
  }
}

void keyReleased() {
  if (key == 'w') wPressed = false;
  if (key == 's') sPressed = false;
  if (key == 'a') aPressed = false;
  if (key == 'd') dPressed = false;

  if (keyCode == UP) upPressed = false;
  if (keyCode == DOWN) downPressed = false;
  if (keyCode == LEFT) leftPressed = false;
  if (keyCode == RIGHT) rightPressed = false;
}
