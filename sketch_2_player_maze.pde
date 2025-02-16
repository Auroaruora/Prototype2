import processing.sound.*;
SinOsc redSound, blueSound;
//Maze
int cols, rows;
int cellSize = 200;//TODO change this after debugging 
Cell[][] maze;
ArrayList<Cell> stack = new ArrayList<Cell>();

// Players
float player1X, player1Y, player2X, player2Y;
float playerSpeed = 5; //TODO change this after debugging 
int playerRadius =10;
int visionRadius = 100; // Limited vision radius

// Game states
boolean gameOver = false;
String winnerText = "";
int player1Score = 0;
int player2Score = 0;

// **Key states for smooth movement**
boolean wPressed, sPressed, aPressed, dPressed;
boolean upPressed, downPressed, leftPressed, rightPressed;


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

Item[] items = new Item[8];

void setup() {
  size(600, 600);
  resetGame();

}

void resetGame(){
  cols = width / cellSize;
  rows = height / cellSize;
  maze = new Cell[cols][rows];
  
  redSound = new SinOsc(this);
  blueSound = new SinOsc(this);

  // Initialize maze cells
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      maze[i][j] = new Cell(i, j);
    }
  }

  generateMaze();
  
  for (int i = 0; i < items.length; i++) {
    items[i] = new Item();
  }

  // Start positions
  player1X = cellSize / 2;
  player1Y = cellSize / 2;
  player2X = width - cellSize / 2;
  player2Y = height - cellSize / 2;
}

void playBeep(SinOsc osc, float frequency) {
  osc.freq(frequency);
  osc.amp(0.5);
  osc.play();
  
  delay(100);
  osc.stop();
}

void draw() {
  background(0);
  drawMaze();
  for (Item item : items) {
    item.display();
  }
  movePlayers();
  checkItemCollision();
  drawPlayers();
  displayScores();

  if (gameOver) {
    if (winnerText.equals("Red Player Wins!")) {
      background(139, 0, 0); // Dark red
    } else if (winnerText.equals("Blue Player Wins!")) {
      background(0, 0, 139); // Dark blue
    } else {
      background(139, 0, 139); // Dark blue
    }
    drawFireworks();
    textSize(32);
    fill(255);
    textAlign(CENTER, CENTER);
    text(winnerText, width / 2, height / 2);
    textSize(20);
    text("Press ENTER to restart", width / 2, height / 2 + 25);

    drawFireworks();
  }
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

void displayScores() {
  fill(255, 0, 0);
  textSize(20);
  textAlign(LEFT, TOP);
  text("Red: " + player1Score, 20, 20);
  
  fill(0, 0, 255);
  textAlign(RIGHT, TOP);
  text("Blue: " + player2Score, width - 20, 20);
}
