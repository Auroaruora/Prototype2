// Maze generation using Recursive Backtracking (DFS)
void generateMaze() {
  Cell current = maze[0][0];
  current.visited = true;
  stack.add(current);

  while (!stack.isEmpty()) {
    current = stack.get(stack.size() - 1);
    Cell next = current.getUnvisitedNeighbor();
    
    if (next != null) {
      removeWall(current, next);
      next.visited = true;
      stack.add(next);
    } else {
      stack.remove(stack.size() - 1);
    }
  }
}

// Remove walls between two cells
void removeWall(Cell a, Cell b) {
  int dx = b.col - a.col;
  int dy = b.row - a.row;

  if (dx == 1) { a.walls[1] = false; b.walls[3] = false; } // Right
  if (dx == -1) { a.walls[3] = false; b.walls[1] = false; } // Left
  if (dy == 1) { a.walls[2] = false; b.walls[0] = false; } // Down
  if (dy == -1) { a.walls[0] = false; b.walls[2] = false; } // Up
}

// Draw the maze with **thicker walls**
void drawMaze() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      maze[i][j].show();
    }
  }
}


// **Check if a position collides with a wall**
boolean hitsWall(float x, float y) {
  int col = int(x / cellSize);
  int row = int(y / cellSize);

  if (col < 0 || col >= cols || row < 0 || row >= rows) return true;
  return maze[col][row].isWall(x, y);
}

// **Maze Cell Class**
class Cell {
  int col, row;
  boolean[] walls = {true, true, true, true}; // Top, Right, Bottom, Left
  boolean visited = false;

  Cell(int col, int row) {
    this.col = col;
    this.row = row;
  }

  // **Draw thicker walls**
  void show() {
    int x = col * cellSize;
    int y = row * cellSize;
    strokeWeight(4); // **Thicker walls**
    stroke(255);

    if (walls[0]) line(x, y, x + cellSize, y); // Top
    if (walls[1]) line(x + cellSize, y, x + cellSize, y + cellSize); // Right
    if (walls[2]) line(x, y + cellSize, x + cellSize, y + cellSize); // Bottom
    if (walls[3]) line(x, y, x, y + cellSize); // Left
  }

  // **Get unvisited neighbor**
  Cell getUnvisitedNeighbor() {
    ArrayList<Cell> neighbors = new ArrayList<Cell>();

    if (col > 0 && !maze[col - 1][row].visited) neighbors.add(maze[col - 1][row]);
    if (col < cols - 1 && !maze[col + 1][row].visited) neighbors.add(maze[col + 1][row]);
    if (row > 0 && !maze[col][row - 1].visited) neighbors.add(maze[col][row - 1]);
    if (row < rows - 1 && !maze[col][row + 1].visited) neighbors.add(maze[col][row + 1]);

    if (neighbors.size() > 0) return neighbors.get(int(random(neighbors.size())));
    return null;
  }

  // **Check if a position is inside a wall**
  boolean isWall(float x, float y) {
    float cx = col * cellSize;
    float cy = row * cellSize;
    float wallThickness = 4; // **Wall thickness**

    return (walls[0] && y - playerRadius < cy + wallThickness) || 
           (walls[2] && y + playerRadius > cy + cellSize - wallThickness) ||
           (walls[3] && x - playerRadius< cx + wallThickness) ||
           (walls[1] && x + playerRadius> cx + cellSize - wallThickness);
  }
}
