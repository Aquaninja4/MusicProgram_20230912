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
 display algorithm
 fix replay button errors
 */
//Global Variables
int appWidth, appHeight, smallerDimension;
File musicFolder, soundEffectFolder;
Minim minim; //crates object to access all functions
int numberOfSongs = 4;//number of musicFiles in folder, os to count
int numberOfSoundEffects = 1;
//int numberOfsongMetaData = 5;
AudioPlayer[] song = new AudioPlayer [numberOfSongs]; // creates "playlist" variable holding extensions WAV, AIFF, AU, mp3
AudioPlayer [] soundEffects = new AudioPlayer [numberOfSoundEffects]; //Playlist for Sound Effects
AudioMetaData [] songMetaData = new AudioMetaData [numberOfSongs]; //stores everything from .mp3 properties TAB
float actionBarX, actionBarY, actionBarWidth, actionBarHeight;
float playPauseButtonX, playPauseButtonY, playPauseButtonDiameter;
float songTitleX, songTitleY, songTitleWidth, songTitleHeight;
float nextButtonX, nextButtonY, nextButtonWidth, nextButtonHeight;
float previousButtonX, previousButtonY, previousButtonWidth, previousButtonHeight;
float FFButtonX, FFButtonY, FFButtonWidth, FFButtonHeight;
float rewindButtonX, rewindButtonY, rewindButtonWidth, rewindButtonHeight;
float loopButtonX, loopButtonY, loopButtonWidth, loopButtonHeight;
PFont generalFont;
color black =#000000, resetColour = #FFFFFF;
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
  playPauseButtonDiameter = smallerDimension*1/12;
  playPauseButtonX = appWidth*1/2;
  playPauseButtonY = actionBarY+playPauseButtonDiameter*1/1.65;
  //
  nextButtonWidth = smallerDimension*1/12;
  nextButtonHeight = playPauseButtonDiameter;
  nextButtonX =  playPauseButtonX+nextButtonWidth;
  nextButtonY = smallerDimension-nextButtonWidth*1.1;
  //
  previousButtonWidth = nextButtonWidth;
  previousButtonHeight = nextButtonHeight;
  previousButtonX = playPauseButtonX-previousButtonWidth*2;
  previousButtonY = nextButtonY;
  //
  FFButtonWidth = previousButtonWidth;
  FFButtonHeight = previousButtonHeight;
  FFButtonX = playPauseButtonX+FFButtonWidth*2.5;
  FFButtonY = previousButtonY;
  //
  rewindButtonWidth = FFButtonWidth;
  rewindButtonHeight = FFButtonHeight;
  rewindButtonX = playPauseButtonX-rewindButtonWidth*3.5;
  rewindButtonY = FFButtonY;
  //
  loopButtonWidth = rewindButtonWidth;
  loopButtonHeight = rewindButtonHeight;
  loopButtonX = playPauseButtonX+loopButtonWidth*4;
  loopButtonY = rewindButtonY;
  //DIVs
  rect(songTitleX, songTitleY, songTitleWidth, songTitleHeight);
  noStroke();
  rect(actionBarX, actionBarY, actionBarWidth, actionBarHeight);
  stroke(1);
  ellipse(playPauseButtonX, playPauseButtonY, playPauseButtonDiameter, playPauseButtonDiameter);
  rect(nextButtonX, nextButtonY, nextButtonWidth, nextButtonHeight);
  rect(previousButtonX, previousButtonY, previousButtonWidth, previousButtonHeight);
  rect(FFButtonX, FFButtonY, FFButtonWidth, FFButtonHeight);
  rect(rewindButtonX, rewindButtonY, rewindButtonWidth, rewindButtonHeight);
  rect(loopButtonX, loopButtonY, loopButtonWidth, loopButtonHeight);
  //
  //String yoasobiIphone = "YOASOBI - Yoru ni Kakeru (iPhone Ringtone Remix).mp3";
  //String TwelveSpeed = "Twelve Speed - Slynk.mp3";
  //String extension = ".mp3";
  //music load
  String pathway = "MusicUsed/";
  String directory = sketchPath(pathway);
  println("Directory to Music Folder", directory);
  musicFolder = new File(directory);
  int musicFileCount = musicFolder.list().length;
  File[] musicFiles = musicFolder.listFiles();
  println("File Count of the Music Folder:", musicFileCount);
  println("List of all Directories of Each Song to Load into music playlist:");
  printArray(musicFiles);

  for ( int i = 0; i < musicFiles.length; i++ ) {
    println("Music File Name ", musicFiles[i].getName() );
  }
  //
  String[] songFilePathway = new String[musicFileCount];
  for (int i =0; i<musicFiles.length; i++) {
    songFilePathway[i] = ( musicFiles[i].toString() );
  }
  int numberOfSongs = musicFileCount;
  song = new AudioPlayer[numberOfSongs];
  songMetaData = new AudioMetaData[numberOfSongs];
  minim = new Minim(this);
  //
  for (int i=0; i<musicFileCount; i++) {
    song[i]= minim.loadFile( songFilePathway[i] );
    songMetaData[i] = song[i].getMetaData();
  }
  //
  //
  song[0] = minim.loadFile(songFilePathway[0] );
  songMetaData[0] = song[0].getMetaData();
  //
  song[1] = minim.loadFile(songFilePathway[1] );
  songMetaData[1] = song[1].getMetaData();
  //
  song[2] = minim.loadFile(songFilePathway[2] );
  songMetaData[2] = song[2].getMetaData();
  //
  song[3] = minim.loadFile(songFilePathway[3] );
  songMetaData[3] = song[3].getMetaData();
  //
  //song[4] = minim.loadFile(songFilePathway[4] );
  //songMetaData[4] = song[4].getMetaData();
  //
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
  //println("?", songMetaData[0].?());
  println("File Name", songMetaData[0].fileName());
  //must use pure java at os level to list musicFileName before loading Playlist
  println("Song Length (in Milliseconds)", songMetaData[0].length());
  println("Song Length (in Seconds)", songMetaData[0].length()/1000);
  println("Song Length (in Minutes and Seconds)", songMetaData[0].length()/1000/60, "Minutes", songMetaData[0].length()/1000 - (songMetaData[0].length()/1000/60*60), "Seconds" );
  println("Song Title", songMetaData[0].title());
  println("Author", songMetaData[0].author());
  println("Composer", songMetaData[0].composer());
  println("Orchestra", songMetaData[0].orchestra());
  println("Album", songMetaData[0].album());
  println("Disc", songMetaData[0].disc());
  println("Publisher", songMetaData[0].publisher());
  println("Date Released", songMetaData[0].date());
  println("Copyright", songMetaData[0].copyright());
  println("Comments", songMetaData[0].comment());
  println("Lyrics", songMetaData[0].lyrics()); //Optional: music and sing along (i have no lyrics in my songs...)
  println("Track", songMetaData[0].track());
  println("Genre", songMetaData[0].genre());
  println("Encoded", songMetaData[0].encoded());
  //
  generalFont = createFont("Georgia", 55);
  fill(black);
  textAlign(CENTER, CENTER);
  int size = 20;
  textFont(generalFont, size);
  text(songMetaData[0].title(), songTitleX, songTitleY, songTitleWidth, songTitleHeight);
  fill(resetColour);
} //End setup
//
void draw() {
  //

  if ( song[0].isLooping() && song[0].loopCount()==-1 ) println("Looping Forever");
  if ( song[0].isPlaying() && !song[0].isLooping() ) println("Playing Once");
  //
  println("Song Position", song[0].position()/1000, "Song Length", song[0].length()/1000 );
} //End draw
//
void keyPressed() {
  if (key=='p' || key=='p' ) {
    soundEffects[0].play();
  }

  if (key == 'L' | key == 'l') {

    String songStr = String.valueOf(song[0].position());
    int loopFix = int(songStr);
    if (song[0].isLooping()) {
      song[0].loop(0);
      delay(8000);
      song[0].play(loopFix);
    } else {
      song[0].loop(-1);
      delay(8000);
      song[0].play(loopFix); 
    }
  }

  //
  if (key == 'M' | key == 'm') {//MUTE Button
    //MUTE Behavior: stops electricy to speakers, does not stop musicFile
    //NOTE: MUTE has NO built-in PAUSE button, NO built-in rewind button
    //ERROR: if song near end of musicFile, user will not know song is at the end
    // Know ERROR: once song plays; MUTE acts like it doesn't work
    if (song[0].isMuted()) {
      // ERROR song might not be playing
      //CATCH: ask .isPlaying() or !.isPlaying()
      song[0].unmute();
    } else {
      //Possible ERROR: song could go back and go to the start; acts if its a play button
      song[0].mute();
    }
  } //End MUTE
  //
  //Actual .skip() allows for variable ff and fr using .position()+-
  if (key == CODED && keyCode == RIGHT) song[0].skip(1000);
  if (key == CODED && keyCode == LEFT) song[0].skip(-1000);
  //
  //Simple STOP Behaviour: ask if.playing()
  if (key == ' ') {
    if (song[0].isPlaying() ) {
      song[0].pause();
    } else {
      song[0].play();
    }
  }
  //if (key == CODED && keyCode == UP)   0 =musicFileCount-1;
  //if (key == CODED && keyCode == DOWN)0 = musicFileCount+1;
} //End keyPressed
//
void mousePressed() {
  if (mouseX>playPauseButtonX && mouseX<playPauseButtonX+playPauseButtonDiameter && mouseY>playPauseButtonY && mouseY<playPauseButtonY+playPauseButtonDiameter) exit(); //doesnt work
  if (mouseX>nextButtonX && mouseX<nextButtonX+nextButtonWidth && mouseY>nextButtonY && mouseY<nextButtonY+nextButtonHeight )
    if (mouseX>previousButtonX && mouseX<previousButtonX+previousButtonWidth && mouseY>previousButtonY && mouseY<previousButtonY+previousButtonHeight );
  if (mouseX>FFButtonX && mouseX<FFButtonX+FFButtonWidth && mouseY>FFButtonY && mouseY<FFButtonY+FFButtonHeight );
  if (mouseX>rewindButtonX && mouseX<rewindButtonX+rewindButtonWidth && mouseY>rewindButtonY && mouseY<rewindButtonY+rewindButtonHeight );
  if (mouseX>loopButtonX && mouseX<loopButtonX+loopButtonWidth && mouseY>loopButtonY && mouseY<loopButtonY+loopButtonHeight );
} //End mousePressed
//
//End MAIN Program
