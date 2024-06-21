import processing.serial.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer player;
String[] songFiles = {"FE!N-clean.mp3", "GoodDays.mp3", "Passionfruit-clean.mp3", "NormalGirl.mp3", "Redrum-clean.mp3", }; // Paths to your song files
int currentSongIndex = 0;

Serial myPort;      
int options = 5; // Number of options
char[] keys = {'1', '2', '3', '4', '5'}; // Keys for each option
boolean gameStarted = false;
int chosenOption = -1;
int pressed=0; 
long game1StartTime = 0; 
long startTime = 0;
long reactionTime = 0;
long game1Duration = 10000; 

long gameOverScreenDisplayTime = 0; // Variable to store the time when the game over screen is displayed
boolean delayOver = false; // Flag to indicate if the delay is over

int streak = 0; // Keep track of the streak
int highScore = 0; // All-time high score
boolean game1InProgress = false; // Track if Game 1 (reaction time game) is in progress
boolean game2InProgress = false; // Track if Game 2 is in progress
boolean correctButtonPressed= false; 
boolean hasReleased = false; 
boolean game1Over; 

// game 2 variables 
// Variables for player position and velocity
float playerX, playerY;
float playerVelocityY;
boolean isJumping;
boolean game2Over;

// Variables for obstacles
ArrayList<Obstacle> obstacles;
float obstacleSpeed = 2;
float obstacleInterval = 1500; // Milliseconds between obstacle spawns
float lastObstacleTime = 0;
float gapSize = 150; // Size of the gap between obstacles

int score = 0; // Variable to track the player's score


void setup() {
  size(800, 700);
  textSize(24);
  textAlign(CENTER, CENTER);
  background(0, 255, 255); // Set background color to cyan
  myPort = new Serial(this, "/dev/cu.usbmodem123456781", 115200);
  //obstacles = new ArrayList<Obstacle>();
  //game2Over = false; // Initialize game over state
  
  //minim = new Minim(this);
  //loadSong(songFiles[currentSongIndex]); 
}

void draw() {
  screen_setup();
  if (!gameStarted) {
    displayWelcome();
  } else {
    if (game1InProgress) {
      game1Screen();
    } else if (game2InProgress) {
      game2Screen(); 
      //displayGame2InProgressScreen();
    }
  }
  
  checkPressed(); // check what sensor is pressed
  handleSensorInput(pressed); 
  
}

void checkPressed(){
   while (myPort.available() > 0) { // If data is available from serial
    String data = myPort.readStringUntil('\n'); // Read the data until newline character
    if (data != null) {
      data = data.trim(); // Remove any leading/trailing whitespace
      if (data.contains("touched")) {
        hasReleased = false; 
        if (data.contains("1")){
          pressed = 1;
        }
        else if (data.contains("2")){
          pressed = 2; 
        }
        else if (data.contains("3")){
          pressed = 3; 
        }
        else if (data.contains("9")){
          pressed = 4; 
        }
        else if (data.contains("8")){
          pressed = 5; 
        }
        println("you pressed: " + pressed); 
      }
      else if (data.contains("released")){
        hasReleased = true; 
        pressed=0; 
        println("RELEASED!");  
      }
    }
   }
   
  
  
}

void displayWelcome() {
  background(#5097a4); // Cyan background (RGB values: 0, 255, 255)
  fill(255);
  textSize(24);
  text("Streak: " + streak, width/2, height/4 + 40); // Display streak
  text("All Time Highscore: " + highScore, width/2, height - 20); // Display high score
  welcomeScreen(); 
}

void screen_setup() {
  background(#5097a4); // Cyan background (RGB values: 0, 255, 255)
}


void startGame1() {
  gameStarted = true;
  streak = 0; // Reset streak
  chosenOption = int(random(1, options+1));
  startTime = millis();
  println("1. Chosen Option: " + (chosenOption));
  println("1. Press key " + keys[chosenOption-1]);
  game1StartTime = millis(); 
}


void startGame2() {
  gameStarted = true;
  playerX = 100;
  playerY = height / 2;
  playerVelocityY = 0;
  obstacles = new ArrayList<Obstacle>();
  game2Over = false; // Initialize game over state
  
  minim = new Minim(this);
  loadSong(songFiles[currentSongIndex]);
}

void handleSensorInput(int pressed) {
  
  if (!gameStarted) {
    if (pressed == 1) {
      startGame1();
      game1InProgress = true; // Set game 1 in progress
    } else if (pressed == 2) {
      startGame2();
      game2InProgress = true; // Set game 2 in progress
    }
  } 
  
  else {
    if (game1InProgress) {
      
      if (millis()-game1StartTime > game1Duration){
        pressed = 0; 
        game1Over = true; 
        displayGameOverScreen();
      }
      
        if (pressed==chosenOption){
          reactionTime = millis() - startTime;
          startTime = reactionTime;
          println("Reaction Time: " + reactionTime + " ms");
          streak++; // Increment streak
            
          chosenOption = int(random(1, options + 1)); // Randomize chosenOption
          println("Chosen Option: " + chosenOption);
          println("Press key " + keys[chosenOption - 1]);
          //pressed=0;
          
          return;
        }
     }
     else if (game2InProgress){
       if (!game2Over && pressed==5) {
          playerVelocityY = -5; // Jump
        } else if (game2Over) {
          if (pressed ==3){
            restartGame();
          }
          else if (pressed == 4){
            gameStarted = false; 
          }
       }
     }
  }
}

void displayGameOverScreen() {
  background(#5097a4); // Cyan background
  fill(255);
  textSize(70);
  text("Game Over!", width/2, height/2-20);
  textSize(50);
  text("Streak: " + streak, width/2, height/2 + 80); // Display streak
  if (streak > highScore) { // Update high score if the streak is higher
    highScore = streak;
  }
  textSize(25); 
  text("Press the bottom button to return to home screen", width/2 , height/2 + 200); 
  textSize(25);
  text("All Time Highscore: " + highScore, width/2 + 250, 30); // Display high score
  
  if (pressed == 4){
    gameStarted = false; // Reset game state
  }
}
