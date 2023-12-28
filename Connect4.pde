import ddf.minim.*;
import controlP5.*;

Minim minim;
AudioPlayer player, dropSound;

ControlP5 cp5;
DropdownList colorDropdown;

// specifications
int BOARDWIDTH = 7, BOARDHEIGHT = 6;
int DIFFICULTY = 2;
int SPACESIZE = 50;
int FPS = 20;
int XMARGIN = (640 - BOARDWIDTH * SPACESIZE)/ 2, YMARGIN = (480 - BOARDHEIGHT * SPACESIZE) / 2;
int XREDPILE = int(SPACESIZE / 2);
int YREDPILE = 480 - int(3 * SPACESIZE / 2);
int XYELLOWPILE = 640 - int(3 * SPACESIZE / 2);
int YYELLOWPILE = 480 - int(3 * SPACESIZE / 2);

// variables
PImage backg, red, yellow, green, blue, boardim, arrow, computer, human, tie, mainmenu, rules, player1, player2;
PFont orbitron, unicode;
Board board = new Board(BOARDHEIGHT, BOARDWIDTH, 1); // human: 1, computer: -1

int column_g;
int xcor, ycor; // coordinates of the currently active tile
int step;
float speed, dropSpeed;

int beginning, end;
int turn; // human: 1, computer: -1
int pressed;
int gameScreen; // mainMenu: 0, game: 1, endGame: 2, rules: 3
boolean showHelp, isFirstGame;
boolean draggingToken, humanMove;
int tokenx, tokeny;
boolean mouseR;
int winner;
boolean win;
RectBtn playBtn, rulesBtn, quitBtn, easyBtn, mediumBtn, hardBtn, ppBtn, modeBtn, exitBtn;
int r, t; // r: rules, t==0: dark theme, t==1; light theme

boolean isTwoPlayersMode = true;
int currentPlayer = 1; //multiplayer mode

int player1Wins = 0;
int player2Wins = 0;

int colour1=1; // 1-red, 2-yellow, 3-blue, 4-green
int colour2=2;

void setup(){
  minim = new Minim(this);
  cp5 = new ControlP5(this);
  
  colorDropdown = cp5.addDropdownList("Color")
                      .setPosition(525, 50)
                      .addItem("Red", 1)
                      .addItem("Yellow", 2)
                      .addItem("Blue", 3)
                      .addItem("Green", 4)
                      .setColorBackground(color(255,0,0))
                      .setColorForeground(color(255))
                      .setColorLabel(color(255))
                      .setLabel("Select Disk Color")
                      .setSize(120, 200)
                      .setBarHeight(20)
                      .setItemHeight(20);
                      
  colorDropdown.hide();
                      
  player = minim.loadFile("bgMusic.wav");
  dropSound = minim.loadFile("dropSound.wav");
  dropSound.setVolume(50); 
  player.loop();
  player.setVolume(50); 
  
  size(640, 480);
  frameRate(FPS);
  
  backg = loadImage("background.png");
  backg.resize(640, 480);
  red = loadImage("red.png");
  red.resize(SPACESIZE, SPACESIZE);
  yellow = loadImage("yellow.png");
  yellow.resize(SPACESIZE, SPACESIZE);
  blue = loadImage("blue.png");
  blue.resize(SPACESIZE, SPACESIZE);
  green = loadImage("green.png");
  green.resize(SPACESIZE, SPACESIZE);
  boardim = loadImage("boardim.png");
  boardim.resize(SPACESIZE, SPACESIZE);
  
  arrow = loadImage("arrow.png");
  arrow.resize(int(SPACESIZE * 3.75),int(1.5 * SPACESIZE));
  computer = loadImage("computer.png");
  human = loadImage("human.png");
  player1 = loadImage("player1.png");
  player2 = loadImage("player2.png");
  tie = loadImage("tie.png");
  
  mainmenu = loadImage("mainmenu.png");
  mainmenu.resize(640, 480);
  rules = loadImage("rules.png");
  rules.resize(640, 480);
  
  orbitron = createFont("orbitron-light.otf", 25);
  unicode = createFont("BabelStoneHan.ttf", 30);
  
  isFirstGame = true;
  beginning = 1;
  end = 0;
  pressed = 0;
  gameScreen = 0;
  draggingToken = false;
  humanMove = false;
  mouseR = false;
  r = 0;
  win = false;
  
  playBtn = new RectBtn(150, 150, 160, 100, 185, 59, 50, 50, orbitron, "PLAY", false);
  rulesBtn = new RectBtn(320, 150, 160, 100, 185, 59, 50, 50, orbitron, "RULES",false);
  quitBtn = new RectBtn(490, 150, 160, 100, 185, 59, 50, 50, orbitron, "QUIT",false);
  easyBtn = new RectBtn(320, 330, 250, 35, 206, 66, 56, 355, 185, 59, 50, orbitron, "Easy",false);
  mediumBtn = new RectBtn(320, 375, 250, 35, 206, 66, 56, 255, 185, 59, 50, orbitron, "Medium",false);
  hardBtn = new RectBtn(320, 420, 250, 35, 206, 66, 56, 255, 185, 59, 50, orbitron, "Hard",false);
  ppBtn = new RectBtn(600, 20, 80, 40, 185, 59, 50, 50, unicode, "\u23F8",false);
  modeBtn = new RectBtn(320, 230, 250, 35, 206, 66, 56, 255, 185, 59, 50, orbitron, "One Player", true);

  rectMode(CENTER);
  textAlign(CENTER, CENTER);
}

void draw(){
  if (gameScreen == 0){
    background(mainmenu);

    playBtn.drawBtn();
    rulesBtn.drawBtn();
    quitBtn.drawBtn();
    modeBtn.drawBtn();
    easyBtn.drawBtn();
    mediumBtn.drawBtn();
    hardBtn.drawBtn();
    ppBtn.drawBtn();

    fill(0,0,0,0);
    if (overCircle(40, 423, 62)) stroke(255);
    else noStroke();
    ellipse(40, 423, 62, 62);
    if (overCircle(108, 423, 62)) stroke(0);
    else noStroke();
    ellipse(108, 423, 62, 62);
    
    if (mousePressed){
      if (easyBtn.isOverBtn()) DIFFICULTY = 1;
      else if (mediumBtn.isOverBtn()) DIFFICULTY = 2;
      else if (hardBtn.isOverBtn()) DIFFICULTY = 3;
      else if (playBtn.isOverBtn()) gameScreen = 1;
      else if (rulesBtn.isOverBtn()) gameScreen = 3;
      else if (quitBtn.isOverBtn()) exit();
      else if (overCircle(40, 423, 62)){
        darkTheme(); 
        t = 0;
      }
      else if (overCircle(108, 423, 62)){
        lightTheme();
        t = 1;
      }
    }
  }
  
  if (gameScreen == 1 || gameScreen == 2){
    background(backg);
    ppBtn.drawBtn();
    colorDropdown.show();
    drawTile(xcor,ycor,turn);
    
    if(colour1==1 && colour2==2){
      board.drawBoard(XMARGIN, YMARGIN, SPACESIZE, red, yellow, boardim);
    }
    else if(colour1==1 && colour2==3){
      board.drawBoard(XMARGIN, YMARGIN, SPACESIZE, red, blue, boardim);
    }
    else if(colour1==1 && colour2==4){
      board.drawBoard(XMARGIN, YMARGIN, SPACESIZE, red, green, boardim);
    }
    else if(colour1==2 && colour2==1){
      board.drawBoard(XMARGIN, YMARGIN, SPACESIZE, yellow, red, boardim);
    }
    else if(colour1==2 && colour2==3){
      board.drawBoard(XMARGIN, YMARGIN, SPACESIZE, yellow, blue, boardim);
    }
    else if(colour1==2 && colour2==4){
      board.drawBoard(XMARGIN, YMARGIN, SPACESIZE, yellow, green, boardim);
    }
    else if(colour1==3 && colour2==1){
      board.drawBoard(XMARGIN, YMARGIN, SPACESIZE, blue, red, boardim);
    }
    else if(colour1==3 && colour2==2){
      board.drawBoard(XMARGIN, YMARGIN, SPACESIZE, blue, yellow, boardim);
    }
    else if(colour1==3 && colour2==4){
      board.drawBoard(XMARGIN, YMARGIN, SPACESIZE, blue, green, boardim);
    }
    else if(colour1==4 && colour2==1){
      board.drawBoard(XMARGIN, YMARGIN, SPACESIZE, green, red, boardim);
    }
    else if(colour1==4 && colour2==2){
      board.drawBoard(XMARGIN, YMARGIN, SPACESIZE, green, yellow, boardim);
    }
    else if(colour1==4 && colour2==3){
      board.drawBoard(XMARGIN, YMARGIN, SPACESIZE, green, blue, boardim);
    }
    
    if (showHelp) image(arrow, int(SPACESIZE / 2) + SPACESIZE, 470 - int(3 * SPACESIZE / 2));
  }
  
  if (gameScreen == 1){
    displayWinCounts();
    colorDropdown.show();
    
    RectBtn exitBtn = new RectBtn(600, 20, 100, 40, 255, 0, 0, 255, orbitron, "Exit",false);
    exitBtn.drawBtn();
    
    if (exitBtn.isOverBtn() && mousePressed) {
      restartGame();
      colorDropdown.hide();
      gameScreen = 0;
    }
    
    if (beginning == 1){
      if(!isTwoPlayersMode){
        if (isFirstGame){
          turn = 1; // player 1
          showHelp = true;
        }
        else {
          if (round(random(0,1)) == 0) turn = -1;
          else turn = -1; //player 2
          showHelp = false;
        }
      }
      else{
        if (isFirstGame){
          turn = 1; //human
          showHelp = true;
        }
        else {
          if (round(random(0,1)) == 0) turn = -1;
          else turn = -1; //computer
          showHelp = false;
        }
      }
    
      board.reset();
      step = 0;
      if(turn == 1){
        xcor = XREDPILE;
        ycor = YREDPILE;
      }
      else{
        xcor = XYELLOWPILE;
        ycor = YYELLOWPILE;
      }
      beginning = 0;
    }
    
    if(!isTwoPlayersMode){ //multiplayer mode
      if(turn == 1){ // player1
        humanMove = true;
        
        if(t == 0) fill(246, 27, 31);
        else fill(80, 7, 45);
        text("Player 1's turn!", 320, 40);
        
        if (step == 0){
            if (mousePressed && draggingToken == false && mouseX > XREDPILE && mouseX < XREDPILE + SPACESIZE
            && mouseY > YREDPILE && mouseY < YREDPILE + SPACESIZE){
            // start of dragging on red token pile
              draggingToken = true;
              xcor = mouseX - SPACESIZE / 2;
              ycor = mouseY - SPACESIZE / 2;
             }
            if (mouseR){
              column_g = (int)((xcor + SPACESIZE / 2 - XMARGIN) / SPACESIZE);
              if (board.isValidMove(column_g)){
                dropSpeed = 1.0;
                step = 1;
              }
            }
        }
        else if (step == 1){
          draggingToken = false;
          mouseR = false;  
        
          int row = board.getLowestEmptySpace(column_g);
        
          if(int((ycor + int(dropSpeed) - YMARGIN) / SPACESIZE) < row){
            ycor += int(dropSpeed);
            dropSpeed += 0.5;
          }
          else step = 2;
        }
        else if (step == 2){
          dropSound.rewind();
          dropSound.play();
          board.makeMove(1, column_g);
          showHelp = false;
          if (board.isWinner(1)){
            winner = 1;
            player1Wins++;
            gameScreen = 2; // RESTART
            win = true;
          }
          turn =- 1;
          humanMove = false;
          xcor = XYELLOWPILE;
          ycor = YYELLOWPILE;
          step = 0;
        }
      }
      else{ //player 2
        humanMove = true;
        
        if(t == 0) fill(246, 27, 31);
        else fill(80, 7, 45);
        text("Player 2's turn!", 320, 40);
        
        if (step == 0){
            if (mousePressed && draggingToken == false && mouseX > XYELLOWPILE && mouseX < XYELLOWPILE + SPACESIZE
            && mouseY > YYELLOWPILE && mouseY < YYELLOWPILE + SPACESIZE){
            // start of dragging on yellow token pile
              draggingToken = true;
              xcor = mouseX - SPACESIZE / 2;
              ycor = mouseY - SPACESIZE / 2;
             }
            if (mouseR){
              column_g = (int)((xcor + SPACESIZE / 2 - XMARGIN) / SPACESIZE);
              if (board.isValidMove(column_g)){
                dropSpeed = 1.0;
                step = 1;
              }
            }
        }
        else if (step == 1){
          draggingToken = false;
          mouseR = false;  
        
          int row = board.getLowestEmptySpace(column_g);
        
          if(int((ycor + int(dropSpeed) - YMARGIN) / SPACESIZE) < row){
            ycor += int(dropSpeed);
            dropSpeed += 0.5;
          }
          else step = 2;
        }
        else if (step == 2){
          dropSound.rewind();
          dropSound.play();
          board.makeMove(-1, column_g);
          showHelp = false;
          if (board.isWinner(-1)){
            winner = -1;
            player2Wins++;
            gameScreen = 2; // RESTART
            win = true;
          }
          turn = 1;
          humanMove = false;
          xcor = XREDPILE;
          ycor = YREDPILE;
          step = 0;
        }
      }
    }
    else{ // computer
      if(turn == 1){ // human
      humanMove = true;
      
      if(t == 0) fill(246, 27, 31);
      else fill(80, 7, 45);
      text("Your turn!", 320, 40);
      
      if (step == 0){
          if (mousePressed && draggingToken == false && mouseX > XREDPILE && mouseX < XREDPILE + SPACESIZE
          && mouseY > YREDPILE && mouseY < YREDPILE + SPACESIZE){
          // start of dragging on red token pile
            draggingToken = true;
            xcor = mouseX - SPACESIZE / 2;
            ycor = mouseY - SPACESIZE / 2;
           }
          if (mouseR){
            column_g = (int)((xcor + SPACESIZE / 2 - XMARGIN) / SPACESIZE);
            if (board.isValidMove(column_g)){
              dropSpeed = 1.0;
              step = 1;
            }
          }
      }
      else if (step == 1){
        draggingToken = false;
        mouseR = false;  
      
        int row = board.getLowestEmptySpace(column_g);
      
        if(int((ycor + int(dropSpeed) - YMARGIN) / SPACESIZE) < row){
          ycor += int(dropSpeed);
          dropSpeed += 0.5;
        }
        else step = 2;
      }
      else if (step == 2){
        dropSound.rewind();
        dropSound.play();
        board.makeMove(1, column_g);
        showHelp = false;
        if (board.isWinner(1)){
          winner = 1;
          player1Wins++;
          gameScreen = 2; // RESTART
          win = true;
        }
        turn =- 1;
        humanMove = false;
        xcor = XYELLOWPILE;
        ycor = YYELLOWPILE;
        step = 0;
      }
    }
    else{ // computer
        textFont(orbitron);
        if(t == 0) fill(246, 27, 31);
        else fill(80, 7, 45);
        text("Computer's turn!", 320, 40);
      
        if (step == 0){
          column_g = getComputerMove(DIFFICULTY);
          dropSpeed = 1.0;
          speed = 1.0;
          xcor = XYELLOWPILE;
          ycor = YYELLOWPILE;
          step = 1;
        }
        else if (step == 1){  
          if (ycor > (YMARGIN - SPACESIZE)){
            speed += 0.1;
            ycor -= int(speed);
          }
          else step = 2;
        }
        else if (step == 2){
          if (xcor > (XMARGIN + column_g * SPACESIZE + 10)){
            xcor -= int(speed);
            speed += 0.1;
          }
          else {
            xcor = XMARGIN + column_g * SPACESIZE; 
            step = 3;
          }
        }
        else if (step == 3){
          int row = board.getLowestEmptySpace(column_g);
  
          if (int((ycor + int(dropSpeed) - YMARGIN) / SPACESIZE) < row){
            ycor += int(dropSpeed);
            dropSpeed += 0.5;
          }
          else step = 4;
        }
        else if (step == 4){
          dropSound.rewind();
          dropSound.play();
          board.makeMove(-1, column_g);
          if (board.isWinner(-1)){
            winner = -1;
            player2Wins++;
            gameScreen = 2; // RESTART
            win = true;
          }
          turn = 1;
          step = 0;
          xcor = XREDPILE;
          ycor = YREDPILE;
        }
      }
    }
  
    if (!win && board.isBoardFull()){
      winner = 0;
      gameScreen = 2; // RESTART
    }
  }
  
    if(gameScreen == 2){
      ppBtn.drawBtn();
      isFirstGame = false;
      imageMode(CENTER);
      if(!isTwoPlayersMode){ //multiplayer mode
       if (winner == 1) image(player1, 640 / 2, 480 / 2);
       else if (winner == -1) image(player2, 640/2, 480 / 2);
       else image(tie, 640 / 2, 480 / 2);
      }else{
        if (winner == 1) image(human, 640 / 2, 480 / 2);
        else if (winner == -1) image(computer, 640/2, 480 / 2);
        else image(tie, 640 / 2, 480 / 2);
      }
      imageMode(CORNER);
      win = false;
    }
  
  if(gameScreen == 3){
    background(rules);
    ppBtn.drawBtn();
    r++;
  }
}

void controlEvent(ControlEvent theEvent) {
  if(theEvent.getController().getValue()==0.0 && turn==1){
    if(colour2!=1)colour1=1;
  }else if(theEvent.getController().getValue()==1.0 && turn==1){
    if(colour2!=2)colour1=2;
  }else if(theEvent.getController().getValue()==2.0 && turn==1){
    if(colour2!=3)colour1=3;
  }else if(theEvent.getController().getValue()==3.0 && turn==1){
    if(colour2!=4)colour1=4;
  }else if(theEvent.getController().getValue()==0.0 && turn==-1){
    if(colour1!=1)colour2=1;
  }else if(theEvent.getController().getValue()==1.0 && turn==-1){
    if(colour1!=2)colour2=2;
  }else if(theEvent.getController().getValue()==2.0 && turn==-1){
    if(colour1!=3)colour2=3;
  }else if(theEvent.getController().getValue()==3.0 && turn==-1){
    if(colour1!=4)colour2=4;
  }
}

void switchPlayerTurn() {
    if (turn == 1) {
        turn = -1;
    } else {
        turn = 1;
    }
}

void restartGame() {
  isFirstGame = false;
  turn = 1;
  board.reset();
}

void displayWinCounts() {
  textSize(20);
  if(t==0)fill(255);
  else fill(0);
  if(!isTwoPlayersMode){
    text("Player 1 Wins: " + player1Wins, 100, 20);
    text("Player 2 Wins: " + player2Wins, 100, 50);
  }else{
    text("Player Wins: " + player1Wins, 100, 20);
    text("Computer Wins: " + player2Wins, 100, 50);
  } 
}

boolean overCircle(int x, int y, int diameter){
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter / 2 ) return true;
  return false;
}

void mouseClicked(){
  if (gameScreen == 2) {
    beginning = 1;
    gameScreen = 0;
  } else if (gameScreen == 3 && r > 5) {
    gameScreen = 0;
    r = 0;
  } else if (modeBtn.isOverBtn()) {
    isTwoPlayersMode = !isTwoPlayersMode;
    modeBtn.setLabel(isTwoPlayersMode ? "One Player" : "Two Players");
  }
}

void darkTheme(){
  backg = loadImage("background.png");
  backg.resize(640, 480);
  if(colour1==1)red = loadImage("red.png");
  else if(colour1==2)red = loadImage("yellow.png");
  else if(colour1==3)red = loadImage("blue.png");
  else if(colour1==4)red = loadImage("green.png");
  red.resize(SPACESIZE, SPACESIZE);
  if(colour2==1)yellow = loadImage("red.png");
  else if(colour2==2)yellow = loadImage("yellow.png");
  else if(colour2==3)yellow = loadImage("blue.png");
  else if(colour2==4)yellow = loadImage("green.png");
  yellow.resize(SPACESIZE, SPACESIZE);
  boardim = loadImage("boardim.png");
  boardim.resize(SPACESIZE, SPACESIZE);
}

void lightTheme(){
  backg = loadImage("backgroundl.png");
  backg.resize(640, 480);
  if(colour1==1)red = loadImage("red.png");
  else if(colour1==2)red = loadImage("yellow.png");
  else if(colour1==3)red = loadImage("blue.png");
  else if(colour1==4)red = loadImage("green.png");
  red.resize(SPACESIZE, SPACESIZE);
  if(colour2==1)yellow = loadImage("red.png");
  else if(colour2==2)yellow = loadImage("yellow.png");
  else if(colour2==3)yellow = loadImage("blue.png");
  else if(colour2==4)yellow = loadImage("green.png");
  yellow.resize(SPACESIZE, SPACESIZE);
  boardim = loadImage("boardl.png");
  boardim.resize(SPACESIZE, SPACESIZE);
}

void drawTile(int x, int y, int player){
  if (player == 1){
    if(colour1==1)image(red, x, y);
    else if(colour1==2)image(yellow,x,y);
    else if(colour1==3)image(blue,x,y);
    else if(colour1==4)image(green,x,y);
  }
  else{
    if(colour2==1)image(red, x, y);
    else if(colour2==2)image(yellow,x,y);
    else if(colour2==3)image(blue,x,y);
    else if(colour2==4)image(green,x,y);
  }
}

void mouseDragged(){
  if (humanMove && draggingToken){
    xcor = mouseX - SPACESIZE / 2;
    ycor = mouseY - SPACESIZE / 2;
  }
}

void mouseReleased(){
  if (humanMove && draggingToken) mouseR = true;
  else if (ppBtn.isOverBtn()) {
    if (player.isPlaying()){
      player.pause();
      ppBtn.setLabel("\u25B6");
    }
    else {
      player.loop();
      ppBtn.setLabel("\u23F8");
    }
  }
}

int getComputerMove(int diff){
  int[] potentialMoves = getPotentialMoves(board, -1, diff);
  int bestMoveFitness =- 1, i;
  for (i = 0; i < BOARDWIDTH; ++i)
    if (potentialMoves[i] > bestMoveFitness && board.isValidMove(i)) bestMoveFitness = potentialMoves[i];
  

  IntList bestMoves = new IntList();
  for (i = 0; i < potentialMoves.length; ++i)
    if (potentialMoves[i] == bestMoveFitness && board.isValidMove(i)) bestMoves.append(i);
  int choice = round(random(bestMoves.size() - 1));
  return bestMoves.array()[choice];
}

int[] getPotentialMoves(Board board, int player, int diff){
  int w = board.getW();
  int[] potentialMoves = new int[w];
  
  for (int i = 0; i < w; ++i) potentialMoves[i] = 0;
  if (diff == 0 || board.isBoardFull()) return potentialMoves;
  
  int enemy = player == 1 ? -1 : 1;
    
  for (int firstMove = 0; firstMove < w; ++firstMove){
    Board dupeBoard = new Board(board);
    if (!dupeBoard.isValidMove(firstMove)) continue;
    dupeBoard.makeMove(player, firstMove);
    if (dupeBoard.isWinner(player)){
      potentialMoves[firstMove] = 1;
      break;
    }
    else{
      if (dupeBoard.isBoardFull()) potentialMoves[firstMove] = 0;
      else {
        for (int counterMove = 0; counterMove < w; ++counterMove){
          Board dupeBoard2 = new Board(dupeBoard);
          if (!dupeBoard2.isValidMove(counterMove)) continue;
          dupeBoard2.makeMove(enemy, counterMove);
          if (dupeBoard2.isWinner(enemy)){
            potentialMoves[firstMove] = -1;
            break;
          }
          else {
            int[] results = getPotentialMoves(dupeBoard2, player, diff - 1);
            int sum = 0;
            for (int j = 0; j < w; ++j) sum += results[j];
            potentialMoves[firstMove] += (sum / w) / w;
          }
        }
      }
    }
  }
  return potentialMoves;
}
