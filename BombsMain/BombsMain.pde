/*  Project FYS BombRunner Winand Metz 500851135, Ole Neuman 500827044, 
 Ruben Verheul 500855129, Jordy Post 500846919, Alex Tarnòki 500798826 */

//Page code credit Winand Metz, Ole Neuman, Jordy Post

//Code credit Winand Metz
import samuelal.squelized.*;
import processing.sound.*;

Game game;
InputHandler input;
MainMenu mainMenu;
GameOver gameOver;
PauseMenu pauseMenu;
AchievementMenu achievementMenu;
HighscoreMenu highscoreMenu;
SettingsMenu settingsMenu;
//StatisticsMenu statisticsMenu;
TextureAssets textureAssets;
SoundAssets soundAssets;
ServerHandler serverHandler;

int gameState;
int userID;

boolean escapePressed;
boolean isPlaying;
boolean inMainMenu;
boolean playAsGuest;
boolean loaded = false;

final int KEY_LIMIT = 1024;
boolean[] keysPressed = new boolean[KEY_LIMIT];

void setup() {
  //fullScreen(P2D);
  size(1920, 1080, P2D);
  frameRate(FRAMERATE);

  final PFont MAIN_FONT = createFont("data/font/8bitlim.ttf", TEXT_RENDER_SIZE, true);

  textFont(MAIN_FONT);

  thread("loadFiles");
}

void loadFiles() {
  input = new InputHandler();
  soundAssets = new SoundAssets(this);
  textureAssets = new TextureAssets(TILE_SIZE);
  serverHandler = new ServerHandler();
  serverHandler.getSoundVol();
  settingsMenu = new SettingsMenu(textureAssets);
  soundAssets.update();
  game = new Game(TILE_SIZE, width, height, textureAssets, soundAssets, serverHandler);
  mainMenu = new MainMenu(textureAssets, soundAssets);
  gameOver = new GameOver(textureAssets, serverHandler);
  pauseMenu = new PauseMenu(textureAssets);
  highscoreMenu = new HighscoreMenu(textureAssets, serverHandler);
  //statisticsMenu = new StatisticsMenu(textureAssets, serverHandler);
  achievementMenu = new AchievementMenu(textureAssets, serverHandler);

  gameState = 0; //gameState for the main menu

  synchronized(this) {
    loaded = true;
  }
}

//Code credit Jordy Post
void toMainMenu() {
  //zet de gamestate naar de main menu en reset de game
  gameState = 0;
  game = new Game(TILE_SIZE, width, height, textureAssets, soundAssets, serverHandler);

  //update alle highscore tabellen
  highscoreMenu.topHighscores = serverHandler.getTopHighscores(HIGHSCORE_TABLE_LIMIT);
  highscoreMenu.topPlayers = serverHandler.getTopPlayers(HIGHSCORE_TABLE_LIMIT);
  highscoreMenu.topHighscoresUser = serverHandler.getTopHighscoresUser(HIGHSCORE_TABLE_LIMIT);
  
  mainMenu.playMusic();
  soundAssets.stopGameMusicAmbient();
}

//-----------------------------Draw & Key functies---------------------------------

//Code credit Ole Neuman
synchronized void draw() {
  if (!loaded) {
    background(0);
    textSize(50);
    fill(255);
    text("Loading...", width/2 - textWidth("Loading...")/2, height/2 - 25);
  } else {
    instructionPicker();
  }
}

//This method calls certain other methods based on the current gameState
void instructionPicker() {     
  switch(gameState) {
  case 0:
    mainMenu.update();
    mainMenu.draw();
    break;

  case 1:
    //isPlaying bepaald of het pause menu zichtbaar is en of de update functie van game wordt uitgevoerd
    if (isPlaying) {
      game.update();
    }

    game.draw();

    if (!isPlaying) {
      pauseMenu.update();
      pauseMenu.draw();
    }
    break;

  case 2:
    gameOver.update(game.highscore);
    gameOver.draw();
    break;

    // Highscore
  case 3:
    highscoreMenu.update();
    highscoreMenu.draw();
    break;

    // Achievements
  case 4:
    achievementMenu.update();
    achievementMenu.draw();
    break;

    // Settings
  case 5:
    settingsMenu.update();
    settingsMenu.draw();
    break;

    //Statistics
    //case 6:
    //  statisticsMenu.update();
    //  statisticsMenu.draw();
    //  break;

  default:
    mainMenu.update();
    mainMenu.draw();
    break;
  }
}

//Orginele bron workshops DLO
void keyPressed() {  
  if (keyCode >= KEY_LIMIT) return;
  keysPressed[keyCode] = true;

  //rebind van escape
  if (key == ESC) {
    key = 0;
    escapePressed = true;
  }
}

void keyReleased() {
  if (keyCode >= KEY_LIMIT) return;
  keysPressed[keyCode] = false;
  escapePressed = false;
}
