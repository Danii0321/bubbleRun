/*
   Assignment 2 - Danielle Rowe
   
   Bubble Run:
   The user's ball is represented by myBall, and follows the cursor with a delay.
   Must avoid the red enemies moving around screen and collect all 10 coins.
   Press shift to begin game, q to reset
   
   Extras:
   -game over/ game won conditional screen
   -instruction screen
   -adding third enemy when game is half-won (score >= 5)
  
*/

//Variables:
//enemy balls

PShape enemyBall1;
PShape enemyBall2;
PShape enemyBall3;
float enemyBallX, enemyBallY; //Positions of the ball
float enemyBallX2, enemyBallY2;
float enemyBallX3, enemyBallY3;
float ebVelX = 3; //Velocities of the ball
float ebVelY = 5;
float ebVelX2 = -7; //Velocities of the ball
float ebVelY2 = 4;
float ebVelX3 = -6; //Velocities of the ball
float ebVelY3 = 6;
int dim = 100; //Size of the ellipse

//user's ball
PShape myBall;
float myX;
float myY;
int myDim = 50;
float speed = 0.01;

//coins
PShape coin1;
float c1X = random(20, 800);
float c1Y = random(20, 800);
color c1Color = color(random(80, 255), random(80, 255), random(80, 255));

PShape coin2;
float c2X = random(20, 800);
float c2Y = random(20, 800);
color c2Color = color(random(80, 255), random(80, 255), random(80, 255));

PShape coin3;
float c3X = random(20, 800);
float c3Y = random(20, 800);
color c3Color = color(random(80, 255), random(80, 255), random(80, 255));

PShape coin4;
float c4X = random(20, 800);
float c4Y = random(20, 800);
color c4Color = color(random(80, 255), random(80, 255), random(80, 255));

PShape coin5;
float c5X = random(20, 800);
float c5Y = random(20, 800);
color c5Color = color(random(80, 255), random(80, 255), random(80, 255));

PShape coin6;
float c6X = random(20, 800);
float c6Y = random(20, 800);
color c6Color = color(random(80, 255), random(80, 255), random(80, 255));

PShape coin7;
float c7X = random(20, 800);
float c7Y = random(20, 800);
color c7Color = color(random(80, 255), random(80, 255), random(80, 255));

PShape coin8;
float c8X = random(20, 800);
float c8Y = random(20, 800);
color c8Color = color(random(80, 255), random(80, 255), random(80, 255));

PShape coin9;
float c9X = random(20, 800);
float c9Y = random(20, 800);
color c9Color = color(random(80, 255), random(80, 255), random(80, 255));

PShape coin10;
float c10X = random(20, 800);
float c10Y = random(20, 800);
color c10Color = color(random(80, 255), random(80, 255), random(80, 255));

//state of game
boolean gameOver = false;
boolean gameWon = false;
boolean gameStarted = false;
boolean gameReset = false;
int coinsCollected = 0;

//extras
PFont font;

void setup(){
  size(800, 800);
  setupBalls();
}

void draw(){
  background(color(0, 26, 26));
  
  //setting font
  font = createFont("Verdana-Bold", 32);
  textFont(font);
  
  //checking if game has been started, if not, display instructions
  if(!gameStarted){
    background(color(0, 26, 26));
    
    //game title
    fill(255, 162, 124);
    textSize(60);
    text("Bubble Run", 200, height/4);
    
    //game instructions
    fill(0, 218, 185);
    textSize(20);
    text("Instructions: \nAvoid the red enemies and collect all 10 coins!"
    + "\nClick and hold to speed up\nPress q to restart\nPress shift to start", 200, 400); 
    
    //decorative bubbles
    noStroke();
    fill(color(255, 102, 89));
    ellipse(100, 400, 100, 100);
    fill(255);
    ellipse(640, 200, myDim, myDim);
  }
  
  else {
  //drawing the score
  textSize(32);
  text("Score: " + this.coinsCollected, 10, 30); 
  fill(0, 102, 153);
  
  //calling functions necessary to gameplay (descriptions below)
  moveToMouse();
  checkEnemyScreenCollisions();
  checkMyBallScreenCollisions();
  updateBall();
  drawBall();
  isReset();
  
  //check if myBall has collided with any coins
  checkCoins();
  
  //check myBall is not collided with an enemy
  checkMyBallEnemyCollisions(myX, myY, myDim, enemyBallX, enemyBallY, dim);
  checkMyBallEnemyCollisions(myX, myY, myDim, enemyBallX2, enemyBallY2, dim);
  
  /*
    If score is greater than or equal to 5, another enemy has been added
    that we need to check
  */
  if(this.coinsCollected >= 5){
    checkMyBallEnemyCollisions(myX, myY, myDim, enemyBallX3, enemyBallY3, dim);
  }
  
  //Added gameOver screen and condition
  if(this.gameOver){
    background(color(255, 102, 89));
    textSize(32);
    text("You Lose!", 300, 400); 
    textSize(18);
    text("Press q to restart", 300, 450);
    fill(0, 102, 153);
  }
  
  //Winning condition and screen
  if(this.coinsCollected == 10){
    background(0, 230, 138);
    textSize(32);
    text("You Win!", 300, 400); 
    textSize(18);
    text("Press q to restart", 300, 450);
    fill(0, 102, 153);
  }
 }
}

//All the code for initializing enemy balls, myBall, and all coins
void setupBalls(){
  //set up enemy ball #1
  enemyBallX = height/2; //initial positions
  enemyBallY = width/2;
  enemyBall1 = createShape(ELLIPSE, 0, 0, dim, dim);
  noStroke();
  enemyBall1.setFill(color(255, 102, 89));
  
  //set up enemy ball #2
  enemyBallX2 = height/2;//initial positions
  enemyBallY2 = width/2;
  enemyBall2 = createShape(ELLIPSE, 0, 0, dim, dim);
  noStroke();
  enemyBall2.setFill(color(255, 102, 89));
  
  //set up enemy ball #3
  enemyBallX3 = height/2;//initial positions
  enemyBallY3 = width/2;
  enemyBall3 = createShape(ELLIPSE, 0, 0, dim, dim);
  noStroke();
  enemyBall3.setFill(color(255, 102, 89));
  
  //set up myBall
  //problem - all load in same position
  //or if i modify this, collision does not work right with coins
  myX = 0; //initial positions
  myY = 0;
  myBall = createShape(ELLIPSE, 0, 0, myDim, myDim);
  noStroke();
  myBall.setFill(255);
  
  //set up coins
  coin1 = createShape(ELLIPSE, 0, 0, myDim/3, myDim/3);
  noStroke();
  coin1.setFill(c1Color);
  
  coin2 = createShape(ELLIPSE, 0, 0, myDim/3, myDim/3);
  noStroke();
  coin2.setFill(c2Color);
  
  coin3 = createShape(ELLIPSE, 0, 0, myDim/3, myDim/3);
  noStroke();
  coin3.setFill(c3Color);
  
  coin4 = createShape(ELLIPSE, 0, 0, myDim/3, myDim/3);
  noStroke();
  coin4.setFill(c4Color);
  
  coin5 = createShape(ELLIPSE, 0, 0, myDim/3, myDim/3);
  noStroke();
  coin5.setFill(c1Color);
  
  coin6 = createShape(ELLIPSE, 0, 0, myDim/3, myDim/3);
  noStroke();
  coin6.setFill(c6Color);
  
  coin7 = createShape(ELLIPSE, 0, 0, myDim/3, myDim/3);
  noStroke();
  coin7.setFill(c7Color);
  
  coin8 = createShape(ELLIPSE, 0, 0, myDim/3, myDim/3);
  noStroke();
  coin8.setFill(c8Color);
  
  coin9 = createShape(ELLIPSE, 0, 0, myDim/3, myDim/3);
  noStroke();
  coin9.setFill(c9Color);
  
  coin10 = createShape(ELLIPSE, 0, 0, myDim/3, myDim/3);
  noStroke();
  coin10.setFill(c10Color);
}

//Draw the ball PShape for enemies, myBall, and coins
void drawBall(){
  //draw enemy balls
  shape(enemyBall1, enemyBallX, enemyBallY);
  shape(enemyBall2, enemyBallX2, enemyBallY2);
  
  //if the score is >= 5, another enemy has been added, must be drawn
  if(this.coinsCollected >= 5){
    shape(enemyBall3, enemyBallX3, enemyBallY3);
  }
  
  //draw myBall
  shape(myBall, myX, myY);
  
  //draw coins
  shape(coin1, c1X, c1Y);
  shape(coin2, c2X, c2Y);
  shape(coin3, c3X, c3Y);
  shape(coin4, c4X, c4Y);
  shape(coin5, c5X, c5Y);
  shape(coin6, c6X, c6Y);
  shape(coin7, c7X, c7Y);
  shape(coin8, c8X, c8Y);
  shape(coin9, c9X, c9Y);
  shape(coin10, c10X, c10Y);
}

//Update the ball position and velocity of enemy balls
void updateBall(){
  enemyBallX += ebVelX;
  enemyBallY += ebVelY;
  enemyBallX2 += ebVelX2;
  enemyBallY2 += ebVelY2;
  
  //must update third enemy if score >= 5
  if(this.coinsCollected >= 5){
    enemyBallX3 += ebVelX3;
    enemyBallY3 += ebVelY3;
  }
}

//for myBall, move towards mouse with a slight delay
void moveToMouse(){
 float xDiff = mouseX - myX;
 float yDiff = mouseY - myY;
 
 myX += xDiff * speed;
 myY += yDiff * speed;
}

//increase speed when mouse is pressed
void mousePressed(){
  speed +=0.03;
}

//reset speed to normal when mouse is released
void mouseReleased(){
  speed -=0.03;
}

/*
  Checks if keys important to the game have been pressed
  -If shift is pressed, sets gameStarted to true because game has started
  -If q is pressed, sets gameReset to true because game has been reset
*/
void keyPressed(){
  if (key == CODED){
    if(keyCode == SHIFT){
      this.gameStarted = true;
    }
  }
  if(key == 'q'){
    this.gameReset = true;
  }
}

//resets game if gameReset is true
void isReset(){
  if(this.gameReset){
    
  //resetting gameState
  this.gameOver = false;
  this.gameWon = false;
  this.gameStarted = false;
  this.gameReset = false;
  this.coinsCollected = 0;
  
  //resetting coins
  coin1.setVisible(true);
  coin2.setVisible(true);
  coin3.setVisible(true);
  coin4.setVisible(true);
  coin5.setVisible(true);
  coin6.setVisible(true);
  coin7.setVisible(true);
  coin8.setVisible(true);
  coin9.setVisible(true);
  coin10.setVisible(true);
  }
}

void checkMyBallScreenCollisions(){
  myX = checkLeftRightCollisions(myX, myDim);
  myY = checkTopBottomCollisions(myY, myDim);
}

float checkLeftRightCollisions(float x, int dim){
 //check to see if the position is beyond the wall
 //left
 if(x < dim/2){
    x = dim/2;
  }
  //right
  else if(x > width-dim/2){
    x = width-dim/2;
  }
  return x;
}

/*
  Checks if the given fields representing the position of the ball indicate
  that the ball has collided with the top or bottom sides of the screen,
  ...if so, direction of the ball is switched by modifying its velocities
*/
float checkTopBottomCollisions(float y, int dim){
  //top
  if(y < dim/2){ 
    y = dim/2;
  }
  //bottom
  else if(y > height-dim/2){
    y = height-dim/2;
  }
  return y;
}



//Check if the enemy balls have collided with any of the sides of the screen
void checkEnemyScreenCollisions(){
  //check to see if the ball hits the sides
  ebVelX = checkLeftRightEnemyScreenCollisions(enemyBallX, ebVelX, dim);
  ebVelY = checkTopBottomEnemyScreenCollisions(enemyBallY, ebVelY, dim);
  ebVelX2 = checkLeftRightEnemyScreenCollisions(enemyBallX2, ebVelX2, dim);
  ebVelY2 = checkTopBottomEnemyScreenCollisions(enemyBallY2, ebVelY2, dim);
  ebVelX3 = checkLeftRightEnemyScreenCollisions(enemyBallX3, ebVelX3, dim);
  ebVelY3 = checkTopBottomEnemyScreenCollisions(enemyBallY3, ebVelY3, dim);
}

/*
  Checks if the given fields representing the position of the ball indicate
  that the ball has collided with the right or left sides of the screen,
  ...if so, direction of the ball is switched by modifying its velocities
*/
float checkLeftRightEnemyScreenCollisions(float x, float xV, int dim){
 //check to see if the position is beyond the wall
 //left
 if(x < dim/2){
    xV*=-1;
    x = dim/2;
  }
  //right
  else if(x > width-dim/2){
    xV*=-1;
    x = width-dim/2;
  }
  
  return xV;
}

/*
  Checks if the given fields representing the position of the ball indicate
  that the ball has collided with the top or bottom sides of the screen,
  ...if so, direction of the ball is switched by modifying its velocities
*/
float checkTopBottomEnemyScreenCollisions(float y, float yV, int dim){
  //top
  if(y < dim/2){ 
    yV*=-1;
    y = dim/2;
  }
  //bottom
  else if(y > height-dim/2){
    yV*=-1;
    y = height-dim/2;
  }
  return yV;
}

//Circle collision between myBall and an enemy
//if they have collided --> game is lost
void checkMyBallEnemyCollisions(float x1, float y1, int d1, float x2, float y2, int d2){
  
  int xDiff = int(x1)-int(x2);
  int yDiff = int(y1)-int(y2);
  
  //Pythags
  int cSq = xDiff*xDiff+yDiff*yDiff;
  int r1 = d1/2;
  int r2 = d2/2;
  
  if(cSq < r1*r1+r2*r2){
    this.gameOver = true;
  }
}

//Checks each coin to see if the ball has collided with it if it is not 
//already collected (is still visible)
void checkCoins(){
  if(coin1.isVisible()){
  checkCoinCollision(myX, myY, myDim, c1X, c1Y, myDim/3, coin1);
  }

  if(coin2.isVisible()){
  checkCoinCollision(myX, myY, myDim, c2X, c2Y, myDim/3, coin2);
  }

  if(coin3.isVisible()){
  checkCoinCollision(myX, myY, myDim, c3X, c3Y, myDim/3, coin3);
  }

  if(coin4.isVisible()){
  checkCoinCollision(myX, myY, myDim, c4X, c4Y, myDim/3, coin4);
   }

  if(coin5.isVisible()){
  checkCoinCollision(myX, myY, myDim, c5X, c5Y, myDim/3, coin5);
   }

  if(coin6.isVisible()){
  checkCoinCollision(myX, myY, myDim, c6X, c6Y, myDim/3, coin6);
   }

  if(coin7.isVisible()){
  checkCoinCollision(myX, myY, myDim, c7X, c7Y, myDim/3, coin7);
   }

  if(coin8.isVisible()){
  checkCoinCollision(myX, myY, myDim, c8X, c8Y, myDim/3, coin8);
   }

  if(coin9.isVisible()){
  checkCoinCollision(myX, myY, myDim, c9X, c9Y, myDim/3, coin9);
   }

  if(coin10.isVisible()){
  checkCoinCollision(myX, myY, myDim, c10X, c10Y, myDim/3, coin10);
  }
}

//check collision between myBall and the given coin
//if they have collided --> increase score and "delete" coin (make invisible)
void checkCoinCollision(float x1, float y1, int d1, float x2, float y2, int d2, PShape coin){
  
  int xDiff = int(x1)-int(x2);
  int yDiff = int(y1)-int(y2);
  
  // stroke(255);
  //line(x1, y1, x2, y2);
  
  //Pythags
  int cSq = xDiff*xDiff+yDiff*yDiff;
  float r1 = d1/2;
  float r2 = d2/2;
 
  if(cSq < r1*r1+r2*r2){
    coin.setVisible(false);
    this.coinsCollected += 1;
    print(x1 + " " + x2);
  }
}
