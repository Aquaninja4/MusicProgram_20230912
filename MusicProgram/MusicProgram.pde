import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
//Global Variables
Minim minim; //crates object to access all functions
AudioPlayer song1; // creates "playlist" variable holding extensions WAV, AIFF, AU, mp3
Boolean loopOn = false;
void  setup() {
  //fullScreen();
  //size(300, 700); //Portrait size
  size(1200, 800);
  minim = new Minim(this);
  String pathway = "../MusicUsed/";
  String yoasobiIphone = "YOASOBI - Yoru ni Kakeru (iPhone Ringtone Remix).mp3";
  String extension = ".mp3";
  String path = sketchPath(pathway + yoasobiIphone);
  song1 = minim.loadFile(path);
  //song1.loop(0);
} //End setup
//
void draw() {
  //if (song1.isLooping() )println(there is 
  if (loopOn==true) {
    song1.loop(-1);
  } else {
    song1.loop(0);
  }
} //End draw
//
void keyPressed() {
  if ( key=='p' | key =='P' )  song1.play();

  if (key == 'l' | key == 'L') {
      if (loopOn==true) {  //Nightmode, basic control is Boolean
        loopOn = false;
      } else {
        loopOn = true;
      }
    }
} //End keyPressed
//
void mousePressed() {
} //End mousePressed
//
//End MAIN Program
