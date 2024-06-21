void game2Screen(){
  background(100, 200, 255);
  
  if (!game2Over) {
    // Draw player
    fill(255, 0, 0);
    ellipse(playerX, playerY, 40, 40);
    
    // Update player position
    playerY += playerVelocityY;
    playerVelocityY += 0.5; // Gravity
    
    // Check player boundaries
    if (playerY > height) {
      playerY = height;
      playerVelocityY = 0;
      endGame();
    } else if (playerY < 0) {
      playerY = 0;
      playerVelocityY = 0;
      endGame();
    }
    
    // Update obstacles
    updateObstacles();
    
    // Check for collisions with obstacles
    checkCollisions();
    
    // Draw score
    drawScore();
  } else {
    // Game over screen
    fill(255);
    textSize(32);
    textAlign(CENTER, CENTER);
    text("Game Over", width/2, height/2 - 40);
    text("Score: " + score, width/2, height/2);
    text("Press middle left button to restart", width/2, height/2 + 40);
    text("Press bottom button to return to home screen", width/2, height/2 + 80);
  }
}

void updateObstacles() {
  if (millis() - lastObstacleTime > obstacleInterval) {
    lastObstacleTime = millis();
    float gapTop = random(height - gapSize);
    obstacles.add(new Obstacle(width, gapTop, gapSize));
  }
  
  for (int i = obstacles.size() - 1; i >= 0; i--) {
    Obstacle obs = obstacles.get(i);
    obs.update();
    
    if (obs.offscreen()) {
      obstacles.remove(i);
      score++; // Increment score when obstacle goes offscreen
    }
  }
}

void checkCollisions() {
  for (Obstacle obs : obstacles) {
    if (obs.hits(playerX, playerY)) {
      endGame();
      return;
    }
  }
}

void endGame() {
  game2Over = true;
  pressed = 0; 
  if (player != null) {
    player.close(); // Stop the currently playing song when the game ends
  }
}

void restartGame() {
  //println("entered restart"); 
  playerY = height / 2;
  playerVelocityY = 0;
  obstacles.clear();
  score = 0;
  game2Over = false;
  
  // Switch to the next song
  currentSongIndex = (currentSongIndex + 1) % songFiles.length;
  loadSong(songFiles[currentSongIndex]);
}

void drawScore() {
  fill(255);
  textSize(20);
  textAlign(RIGHT);
  text("Score: " + score, width - 20, 30);
}

void displayGame2InProgressScreen() {
  
  
  background(255); // White background
  fill(0);
  textSize(24);
  textAlign(CENTER, CENTER);
  text("Game 2 is still in development", width/2, height/2 - 20); // Display development message
  text("Press any button to return home", width/2, height/2 + 20); // Display return home message
  
  
}

void loadSong(String fileName) {
  if (player != null) {
    player.close(); // Close the currently playing song
  }
  player = minim.loadFile(fileName);
  player.play(); // Play the new song
}

class Obstacle {
  float x, gapTop, gapSize;
  float w = 60;
  
  Obstacle(float x, float gapTop, float gapSize) {
    this.x = x;
    this.gapTop = gapTop;
    this.gapSize = gapSize;
  }
  
  void update() {
    x -= obstacleSpeed;
    draw();
  }
  
  void draw() {
    // Draw top part
    fill(0);
    rect(x, 0, w, gapTop);
    // Draw bottom part
    rect(x, gapTop + gapSize, w, height - gapTop - gapSize);
  }
  
  boolean offscreen() {
    return x + w < 0;
  }
  
  boolean hits(float px, float py) {
    return px + 20 > x && px - 20 < x + w && (py - 20 < gapTop || py + 20 > gapTop + gapSize);
  }
}
