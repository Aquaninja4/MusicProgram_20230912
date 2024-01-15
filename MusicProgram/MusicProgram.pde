import java.io.*;
//
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
//
/* to do
 sound effects
 turn off/on autoplay
 loop to back of playlist
 display algorithm
 fix button errors
 shuffle using random, making next go to a random song?
 */
//Global Variables
int appWidth, appHeight, smallerDimension;
File musicFolder, soundEffectFolder;
Minim minim; //crates object to access all functions
int numberOfSongs = 1, numberOfSoundEffects = 1, currentSong = 0;//number of musicFiles in folder, os to count
Boolean test = false, loopOn = false, pauseBoolean = false, FFHold = false, rewindHold = false, hoverHoldFF = false, hoverHoldFR = false;
//int numberOfsongMetaData = 5;
AudioPlayer[] song = new AudioPlayer [numberOfSongs]; // creates "playlist" variable holding extensions WAV, AIFF, AU, mp3
AudioPlayer [] soundEffects = new AudioPlayer [numberOfSoundEffects]; //Playlist for Sound Effects
AudioMetaData [] songMetaData = new AudioMetaData [numberOfSongs]; //stores everything from .mp3 properties TAB
float actionBarX, actionBarY, actionBarWidth, actionBarHeight;
float playPauseElipseX, playPauseElipseY, playPauseDiameter, playPauseButtonX, playPauseButtonY;
float songTitleX, songTitleY, songTitleWidth, songTitleHeight;
float nextButtonX, nextButtonY, nextButtonWidth, nextButtonHeight;
float previousButtonX, previousButtonY, previousButtonWidth, previousButtonHeight;
float FFButtonX, FFButtonY, FFButtonWidth, FFButtonHeight;
float rewindButtonX, rewindButtonY, rewindButtonWidth, rewindButtonHeight;
float loopButtonX, loopButtonY, loopButtonWidth, loopButtonHeight;
PImage playImage, pauseImage, FFImage, FRImage, nextImage, previousImage, mutedImage, unmutedImage;
PFont generalFont;
color black =#000000, grey = #e6e6e6, darkerGrey = #cacacb, resetColour = #FFFFFF;
color hoverOverColour = resetColour, holdColour = darkerGrey;
//int currentSong = numberOfSongs - numberOfSongs + int (random(numberOfSongs));
//String  = ;

void  setup() {
  //fullScreen();
  //size(300, 700); //Portrait size
  size(1200, 800);
  appWidth = width;
  appHeight = height;
  smallerDimension = (appWidth >= appHeight) ? appHeight : appWidth;
  //
  //Population
  songTitleX = appWidth*1/4;
  songTitleY = appHeight*0;
  songTitleWidth = appWidth*1/2;
  songTitleHeight = appHeight*1/15;
  //
  actionBarWidth =appWidth-1;
  actionBarHeight =appHeight*1/10;
  actionBarX = appWidth*0;
  actionBarY = smallerDimension-actionBarHeight;
  //
  //
  playPauseDiameter = smallerDimension*1/12;
  playPauseElipseX = appWidth*1/2;
  playPauseElipseY = actionBarY+playPauseDiameter*1/1.65;
  //
  playPauseButtonX = playPauseElipseX-playPauseDiameter/2;
  playPauseButtonY = smallerDimension-playPauseDiameter*1.1;
  //
  FFButtonWidth = smallerDimension*1/12;
  FFButtonHeight = playPauseDiameter;
  FFButtonX = playPauseElipseX+FFButtonWidth;
  FFButtonY = playPauseButtonY;
  //
  rewindButtonWidth = FFButtonWidth;
  rewindButtonHeight = FFButtonHeight;
  rewindButtonX = playPauseElipseX-rewindButtonWidth*2;
  rewindButtonY = FFButtonY;
  //
  nextButtonWidth = rewindButtonWidth;
  nextButtonHeight = rewindButtonHeight;
  nextButtonX =  playPauseElipseX+nextButtonWidth*2.5;
  nextButtonY = rewindButtonY;
  //
  previousButtonWidth = nextButtonWidth;
  previousButtonHeight = nextButtonHeight;
  previousButtonX = playPauseElipseX-previousButtonWidth*3.5;
  previousButtonY = nextButtonY;
  //
  //
  loopButtonWidth = rewindButtonWidth;
  loopButtonHeight = rewindButtonHeight;
  loopButtonX = playPauseElipseX+loopButtonWidth*4;
  loopButtonY = rewindButtonY;
  //

  //DIVs
  // rect(songTitleX, songTitleY, songTitleWidth, songTitleHeight);
  noStroke();
  rect(actionBarX, actionBarY, actionBarWidth, actionBarHeight);
  stroke(1);
  ellipse(playPauseElipseX, playPauseElipseY, playPauseDiameter, playPauseDiameter);
  rect(FFButtonX, FFButtonY, FFButtonWidth, FFButtonHeight);
  rect(rewindButtonX, rewindButtonY, rewindButtonWidth, rewindButtonHeight);
  rect(nextButtonX, nextButtonY, nextButtonWidth, nextButtonHeight);
  rect(previousButtonX, previousButtonY, previousButtonWidth, previousButtonHeight);
  rect(loopButtonX, loopButtonY, loopButtonWidth, loopButtonHeight);
  //rect(playPauseButtonX, playPauseButtonY, playPauseDiameter, playPauseDiameter);
  //
  //Images
  String imagePathway = "ImagesUsed/";
  String imageDirectory = sketchPath(imagePathway);
  playImage = loadImage(imageDirectory + "play.png");
  pauseImage = loadImage(imageDirectory + "pause.png");
  FFImage = loadImage(imageDirectory + "FF.png");
  FRImage = loadImage(imageDirectory + "FR.png");
  nextImage = loadImage(imageDirectory + "next-button.png");
  previousImage = loadImage(imageDirectory + "back.png");
  mutedImage = loadImage(imageDirectory + "no-sound.png");
  unmutedImage = loadImage(imageDirectory + "volume-up.png");
  //
  //String yoasobiIphone = "YOASOBI - Yoru ni Kakeru (iPhone Ringtone Remix).mp3";
  //String TwelveSpeed = "Twelve Speed - Slynk.mp3";
  //String extension = ".mp3";
  //music load
  minim = new Minim(this);
  //
  String musicPathway = "MusicUsed/";
  String musicDirectory = sketchPath(musicPathway);
  println("Directory to Music Folder", musicDirectory);
  musicFolder = new File(musicDirectory);
  int musicFileCount = musicFolder.list().length;
  File[] musicFiles = musicFolder.listFiles();
  String[] songFilePathway = new String[musicFileCount];
  for (int i =0; i<musicFiles.length; i++) {
    songFilePathway[i] = ( musicFiles[i].toString() );
  }
  println("File Count of the Music Folder:", musicFileCount);
  println("List of all Directories of Each Song to Load into music playlist:");
  printArray(musicFiles);
  numberOfSongs = musicFileCount;
  song = new AudioPlayer[numberOfSongs];
  songMetaData = new AudioMetaData[numberOfSongs];
  //
  for ( int i = 0; i < musicFiles.length; i++ ) {
    println("Music File Name ", musicFiles[i].getName() );
  }
  //
  for (int i=0; i<musicFileCount; i++) {
    song[i]= minim.loadFile( songFilePathway[i] );
    songMetaData[i] = song[i].getMetaData();
  }
  //
  //
  song[currentSong] = minim.loadFile(songFilePathway[currentSong] );
  songMetaData[currentSong] = song[currentSong].getMetaData();
  //End music
  //

  // Sound Effects Load
  String soundEffectPathway = "SoundUsed/";
  String soundEffectDirectory = sketchPath(soundEffectPathway);
  soundEffectFolder = new File(soundEffectDirectory);
  int soundEffectFileCount = soundEffectFolder.list().length;
  File[] soundEffectFiles = soundEffectFolder.listFiles(); //String of Full Directies
  String[] soundEffectFilePathway = new String[soundEffectFileCount];
  for ( int i = 0; i < soundEffectFiles.length; i++ ) {
    soundEffectFilePathway[i] = ( soundEffectFiles[i].toString() );
  }
  //Re-execute Playlist Population, similar to DIV Population
  numberOfSoundEffects = soundEffectFileCount; //Placeholder Only, reexecute lines after fileCount Known
  soundEffects = new AudioPlayer[numberOfSoundEffects]; //song is now similar to song1
  for ( int i=0; i<soundEffectFileCount; i++ ) {
    soundEffects[i]= minim.loadFile( soundEffectFilePathway[i] );
  } //End Music Load
  //

  minim = new Minim(this);
  //
  // Meta Data Println Testing
  // for prototyping, print all info to the console  first
  //verifying meta data, 18 println's
  //println("?", songMetaData[currentSong].?());
  println("File Name", songMetaData[currentSong].fileName());
  //must use pure java at os level to list musicFileName before loading Playlist
  println("Song Length (in Milliseconds)", songMetaData[currentSong].length());
  println("Song Length (in Seconds)", songMetaData[currentSong].length()/1000);
  println("Song Length (in Minutes and Seconds)", songMetaData[currentSong].length()/1000/60, "Minutes", songMetaData[currentSong].length()/1000 - (songMetaData[currentSong].length()/1000/60*60), "Seconds" );
  println("Song Title", songMetaData[currentSong].title());
  println("Author", songMetaData[currentSong].author());
  println("Composer", songMetaData[currentSong].composer());
  println("Orchestra", songMetaData[currentSong].orchestra());
  println("Album", songMetaData[currentSong].album());
  println("Disc", songMetaData[currentSong].disc());
  println("Publisher", songMetaData[currentSong].publisher());
  println("Date Released", songMetaData[currentSong].date());
  println("Copyright", songMetaData[currentSong].copyright());
  println("Comments", songMetaData[currentSong].comment());
  println("Lyrics", songMetaData[currentSong].lyrics()); //Optional: music and sing along (i have no lyrics in my songs...)
  println("Track", songMetaData[currentSong].track());
  println("Genre", songMetaData[currentSong].genre());
  println("Encoded", songMetaData[currentSong].encoded());
  //
  //random beginning song
  currentSong = int(random(0, numberOfSongs-1)); //casting truncates the decimal
} //End setup
//
void draw() {
  //
  if ( song[currentSong].isPlaying()  && loopOn==true ) println("Looping Forever");
  if ( song[currentSong].isPlaying() && loopOn==false ) println("Playing Once");
  //
  println("Song Position:", song[currentSong].position()/1000, "Song Length:", song[currentSong].length()/1000 );
  println("Song Playing:", songMetaData[currentSong].title());
  //
  if (loopOn == true && !song[currentSong].isPlaying()) {
    song[currentSong].rewind();
    song[currentSong].play();
  } else {
  }
  //
  //autoplay, next song automatically plays

  if ( song[currentSong].isPlaying() ) {
    if ( pauseBoolean==true) {
      song[currentSong].pause();
    }
  } else {
    //currentSong at end of FILE
    if ( pauseBoolean == true ) {
      song[currentSong].pause();
    } else {
      if ( song[currentSong].position() < 10000 && currentSong < numberOfSongs-1) {
        song[currentSong].rewind();
        currentSong = currentSong + 1;
        song[currentSong].play();
      } else if ( song[currentSong].position() > song[currentSong].length()-song[currentSong].length()*0.1 && currentSong < numberOfSongs-1) {
        song[currentSong].rewind();
        currentSong = currentSong + 1;
        song[currentSong].play();
      } else {
        song[currentSong].rewind();
        song[currentSong].play();
      }
    }
  }
  //
  if ( mouseX>FFButtonX && mouseX<FFButtonX+FFButtonWidth && mouseY>FFButtonY && mouseY<FFButtonY+FFButtonHeight ) {
    hoverOverColour = grey;
    fill( hoverOverColour );
    rect( FFButtonX, FFButtonY, FFButtonWidth, FFButtonHeight );
    fill( resetColour );
    //
  } else if ( mouseX>rewindButtonX && mouseX<rewindButtonX+rewindButtonWidth && mouseY>rewindButtonY && mouseY<rewindButtonY+FFButtonHeight ) {
    hoverOverColour = grey;
    fill( hoverOverColour );
    rect( rewindButtonX, rewindButtonY, rewindButtonWidth, rewindButtonHeight );
    fill( resetColour );
    //
  } else if ( mouseX>nextButtonX && mouseX<nextButtonX+nextButtonWidth && mouseY>nextButtonY && mouseY<nextButtonY+nextButtonHeight ) {
    hoverOverColour = grey;
    fill( hoverOverColour );
    rect(nextButtonX, nextButtonY, nextButtonWidth, nextButtonHeight);
    fill( resetColour );
    //
  } else if ( mouseX>previousButtonX && mouseX<previousButtonX+previousButtonWidth && mouseY>previousButtonY && mouseY<previousButtonY+previousButtonHeight ) {
    hoverOverColour = grey;
    fill( hoverOverColour );
    rect( previousButtonX, previousButtonY, previousButtonWidth, previousButtonHeight);
    fill( resetColour );
    //
  } else { //No Buttons
    fill( resetColour );
    rect( FFButtonX, FFButtonY, FFButtonWidth, FFButtonHeight );
    rect( rewindButtonX, rewindButtonY, rewindButtonWidth, rewindButtonHeight );
    rect(nextButtonX, nextButtonY, nextButtonWidth, nextButtonHeight);
    rect( previousButtonX, previousButtonY, previousButtonWidth, previousButtonHeight);
  }
  //
  if (hoverHoldFF == true) {
    hoverOverColour = holdColour;
    fill( hoverOverColour );
    rect( FFButtonX, FFButtonY, FFButtonWidth, FFButtonHeight);
    fill( resetColour );
  }
  //
  if (hoverHoldFR == true) {
    hoverOverColour = holdColour;
    fill( hoverOverColour );
    rect( rewindButtonX, rewindButtonY, rewindButtonWidth, rewindButtonHeight);
    fill( resetColour );
  }
  if (FFHold == true) {
    delay(200);
    song[currentSong].skip(1000);
  } else {
  }
  //
  if (rewindHold == true) {
    delay(200);
    song[currentSong].skip(-1000);
  } else {
  }
  //
  //image(playImage,);
  //image(pauseImage,);
  image(FFImage, FFButtonX, FFButtonY, FFButtonWidth, FFButtonHeight);
  image(FRImage, rewindButtonX, rewindButtonY, rewindButtonWidth, rewindButtonHeight);
  image(nextImage, nextButtonX, nextButtonY, nextButtonWidth, nextButtonHeight);
  image(previousImage, previousButtonX, previousButtonY, previousButtonWidth, previousButtonHeight);
  //image(mutedImage,);
  //image(unmutedImage,);
  //
  rect(songTitleX, songTitleY, songTitleWidth, songTitleHeight);
  int size = 20;
  generalFont = createFont("Georgia", 55);
  fill(black);
  textAlign(CENTER, CENTER);
  textFont(generalFont, size);
  text(songMetaData[currentSong].title(), songTitleX, songTitleY, songTitleWidth, songTitleHeight);
  fill(resetColour);
} //End draw
//
void keyPressed() {
  if (key=='p' || key=='p' ) {
    soundEffects[currentSong].play();
  }


  if (key == 'L' | key == 'l') {
    if (loopOn==true) {
      loopOn = false;
    } else {
      loopOn = true;
    }
  }

  /* // loop playlist
   if (song[currentSong].isPlaying() ) {
   if (currentSong >= numberOfSongs) {
   song[0].play();}
   */

  //
  if (key == 'M' | key == 'm') {//MUTE Button
    //MUTE Behavior: stops electricy to speakers, does not stop musicFile
    //NOTE: MUTE has NO built-in PAUSE button, NO built-in rewind button
    //ERROR: if song near end of musicFile, user will not know song is at the end
    // Know ERROR: once song plays; MUTE acts like it doesn't work
    if (song[currentSong].isMuted()) {
      // ERROR song might not be playing
      //CATCH: ask .isPlaying() or !.isPlaying()
      song[currentSong].unmute();
    } else {
      //Possible ERROR: song could go back and go to the start; acts if its a play button
      song[currentSong].mute();
    }
  } //End MUTE
  //
  //Actual .skip() allows for variable ff and fr using .position()+-
  if (key == CODED && keyCode == RIGHT) song[currentSong].skip(1000);
  if (key == CODED && keyCode == LEFT) song[currentSong].skip(-1000);
  //
  //Simple STOP Behaviour: ask if.playing()
  if (key == ' ') {
    if (pauseBoolean==true) {
      pauseBoolean = false;
    } else {
      pauseBoolean = true;
    }
  }
  //simple Next and previous Buttons

  if (key==CODED && keyCode == UP) {//NEXT
    if (currentSong < numberOfSongs-1) {
      song[currentSong].pause();
      song[currentSong].rewind();
      currentSong=currentSong+1;
      song[currentSong].play();
    }
  }
  if (key==CODED && keyCode == DOWN) {//PREVIOUS
    if (currentSong > 0) {
      song[currentSong].pause();
      song[currentSong].rewind();
      currentSong=currentSong-1;
      song[currentSong].play();
    }
  }
  //
  //simple stop
  if ( key=='S' | key=='s' ) {
    if ( song[currentSong].isPlaying() ) {
      pauseBoolean = true;
    } else {
      pauseBoolean = false;
    }
  }
  //
  if ( key=='T' | key=='t' ) {
    if ( test == false ) {
      test = true;
    } else {
      test = false;
    }
  }
} //End keyPressed
//
void mousePressed() {

  if (mouseX>playPauseButtonX && mouseX<playPauseButtonX+playPauseDiameter && mouseY>playPauseButtonY&& mouseY<playPauseButtonY+playPauseDiameter) exit();
  //
  if (mouseX>FFButtonX && mouseX<FFButtonX+FFButtonWidth && mouseY>FFButtonY && mouseY<FFButtonY+FFButtonHeight ) {
    hoverHoldFF = true;
    delay(250);
    FFHold = true;
  }
  //
  if (mouseX>rewindButtonX && mouseX<rewindButtonX+rewindButtonWidth && mouseY>rewindButtonY && mouseY<rewindButtonY+rewindButtonHeight ) {
    hoverHoldFR = true;
    delay(250);
    rewindHold = true;
  }
  //
  //
  if (mouseX>loopButtonX && mouseX<loopButtonX+loopButtonWidth && mouseY>loopButtonY && mouseY<loopButtonY+loopButtonHeight );
} //End mousePressed
void mouseReleased() {
  hoverHoldFF = false;
  hoverHoldFR = false;
  FFHold = false;
  rewindHold = false;
} //End mouseReleased

void mouseClicked() {

  if (mouseX>FFButtonX && mouseX<FFButtonX+FFButtonWidth && mouseY>FFButtonY && mouseY<FFButtonY+FFButtonHeight ) {
    song[currentSong].skip(1000);
  }
  //
  if (mouseX>rewindButtonX && mouseX<rewindButtonX+rewindButtonWidth && mouseY>rewindButtonY && mouseY<rewindButtonY+rewindButtonHeight ) {
    song[currentSong].skip(-1000);
  }
  //
  if (mouseX>nextButtonX && mouseX<nextButtonX+nextButtonWidth && mouseY>nextButtonY && mouseY<nextButtonY+nextButtonHeight )if (currentSong < numberOfSongs-1) {
    song[currentSong].pause();
    song[currentSong].rewind();
    currentSong=currentSong+1;
    song[currentSong].play();
  }
  //
  if (mouseX>previousButtonX && mouseX<previousButtonX+previousButtonWidth && mouseY>previousButtonY && mouseY<previousButtonY+previousButtonHeight ) if (currentSong > 0) {
    song[currentSong].pause();
    song[currentSong].rewind();
    currentSong=currentSong-1;
    song[currentSong].play();
  }
  //
} //End mouseReleased

//
//End MAIN Program
