PImage img; 

void welcomeScreen() {
  img = loadImage("lightning_bolt_homescreen.png"); 
  pushStyle();
  background(#5097a4); // Cyan background (RGB values: 0, 255, 255)
  fill(255);
   game1InProgress = false; // Track if Game 1 (reaction time game) is in progress
   game2InProgress = false; // Track if Game 2 is in progress
   gameStarted = false;
   
  
  textSize(50);
  textAlign(CENTER, CENTER);
  text("Welcome to Lab 3!", width/2, 60);
  
  textSize(20);
  textAlign(CENTER, CENTER);
  text("By: Sohaib, Naveed, Hafsa, Reem\n", width/2, 120);
  
  textSize(25);
  textAlign(CENTER, CENTER);
  text("click to begin!", width/2, 150);
  
  
 
  float scaleFactor = 0.75; // Scale factor to reduce the image size by 50%
  float imgX = (width - img.width * scaleFactor) / 2; // Calculate the x-coordinate for the top-left corner of the image
  float imgY = (height - img.height * scaleFactor) / 2; // Calculate the y-coordinate for the top-left corner of the image
  image(img, imgX, imgY+50, img.width * scaleFactor, img.height * scaleFactor); // Display the scaled-down image
  

  
  popStyle();
}
