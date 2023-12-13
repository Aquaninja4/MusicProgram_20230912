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
Minim minim; //crates object to access all functions
int numberOfSongs = 4;//number of files in folder, os to count
int numberOfSoundEffects = 1;
int numberOfsongMetaData = 5;
AudioPlayer[] song = new AudioPlayer [numberOfSongs]; // creates "playlist" variable holding extensions WAV, AIFF, AU, mp3
AudioPlayer [] soundEffect = new AudioPlayer [numberOfSoundEffects]; //Playlist for Sound Effects
AudioMetaData [] songMetaData = new AudioMetaData [numberOfsongMetaData]; //stores everything from .mp3 properties TAB
float actionBarX, actionBarY, actionBarWidth, actionBarHeight;
float playPauseButtonX, playPauseButtonY, playPauseButtonDiameter;
float songTitleX, songTitleY, songTitleWidth, songTitleHeight;
float NextButtonX,NextButtonY,NextButtonWidth,NextButtonHeight;
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
  //NextButtonX = ;
  NextButtonY = actionBarY+playPauseButtonDiameter*1/1.65;
  NextButtonWidth = playPauseButtonDiameter;
  NextButtonHeight = playPauseButtonDiameter;
  //
  //DIVs
  rect(songTitleX, songTitleY, songTitleWidth, songTitleHeight);
  noStroke();
  rect(actionBarX, actionBarY, actionBarWidth, actionBarHeight);
  stroke(1);
  ellipse(playPauseButtonX, playPauseButtonY, playPauseButtonDiameter, playPauseButtonDiameter);
  rect(NextButtonX,NextButtonY,NextButtonWidth,NextButtonHeight);
  //
  minim = new Minim(this);
  String yoasobiIphone = "YOASOBI - Yoru ni Kakeru (iPhone Ringtone Remix).mp3";
  String TwelveSpeed = "Twelve Speed - Slynk.mp3";
  String extension = ".mp3";
  String pathway = "MusicUsed/";
  String path = sketchPath(pathway + yoasobiIphone);
  song[0] = minim.loadFile(path);
  songMetaData[0] = song[0].getMetaData();
  //
  //
  //song[0].loop(0);
  //
  // Meta Data PRintln Testing
  // for prototyping, print all info to the console  first
  //verifying meta data, 18 println's
  //println("?", songMetaData[0].?());
  println("File Name", songMetaData[0].fileName());
  //must use pure java at os level to list fileName before loading Playlist
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

  if (key == 'L' | key == 'l') {
    /*
    String songStr = String.valueOf(song[0].position());
     int loopFix = int(songStr);*/
    if (song[0].isLooping()) {
      song[0].loop(0);
    } else {
      song[0].loop(-1);
    }

  }

  //
  if (key == 'M' | key == 'm') {//MUTE Button
    //MUTE Behavior: stops electricy to speakers, does not stop file
    //NOTE: MUTE has NO built-in PAUSE button, NO built-in rewind button
    //ERROR: if song near end of file, user will not know song is at the end
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
  if (key == CODED && keyCode == UP) song[0].play(song[0].length());  //song next or end
  //
  //Simple STOP Behaviour: ask if.playing()
  if (key == ' ') {
    if (song[0].isPlaying() ) {
      song[0].pause();
    } else {
      song[0].play();
    }
  }
  //simple Pause Button
} //End keyPressed
//
void mousePressed() {
} //End mousePressed
//
//End MAIN Program
