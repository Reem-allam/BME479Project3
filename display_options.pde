PImage boltImg; 

void game1Screen() {
  boltImg = loadImage("bolt_game_image.png"); 
  
  
  float scaleFactor = 0.75; // Scale factor to reduce the image size by 50%
  float imgX = (width - boltImg.width * scaleFactor) / 2; // Calculate the x-coordinate for the top-left corner of the image
  float imgY = (height - boltImg.height * scaleFactor) / 2; // Calculate the y-coordinate for the top-left corner of the image
  image(boltImg, imgX, imgY+50, boltImg.width * scaleFactor, boltImg.height * scaleFactor); // Display the scaled-down image
  
  int x = 0;
  int y= 0;
  int remainingTime = max(0, (int)((game1StartTime + game1Duration - millis()) / 1000)); // Convert milliseconds to seconds
  
  //println("this one will light up: " + chosenOption); 
  
  for (int i = 1; i < options+1; i++) {
    
    if (i==1){
      x=305;
      y=205; 
    }
    else if (i==2){
      x=525;
      y=385; 
    }
    else if (i==3){
      x=345;
      y=385; 
    }
    else if (i==4){
      x=480;
      y=550; 
    }
    else if (i==5){
      x=430;
      y=395; 
    }
    
    if (i == chosenOption) {
      fill(0, 255, 0); // Highlighted circle in green
    } else {
      fill(255, 0, 0); // Other circles in red
    }
    ellipse(x, y, 50, 50); // Draw circles
    fill(0);
    text(i, x, y); // Display number inside circles
  }
  
   // Display countdown timer
  fill(255); 
  textSize(30);
  textAlign(CENTER, CENTER);
  text("Time Remaining: " + remainingTime + " seconds", width/2, 125);
  
  fill(255); 
  textSize(50);
  textAlign(CENTER, CENTER);
  text("Touch the green pad!", width/2, 60);
  
  textSize(20);
  text("Highscore: " + highScore, width/2 + 300, height-40); // Display high score
  text("Current Streak: " + streak , 100, height-40);
}
