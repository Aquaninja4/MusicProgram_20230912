//Library //download "minim" sketch > import library > manage... 

//Global Variables
Minim minim; //crates object to access all functions
AudioPlayer song1; // creates "playlist" variable holding extensions WAV, AIFF, AU, mp3
void  setup() {
  //fullScreen();
  //size(300, 700); //Portrait size
  size(1200, 800);
  //Display algorithm
  displayAlgorithm();
  minim = new Minim(this);
  String pathway = "../MusicUsed/";
  String TwelveSpeed = "Twelve Speed - Slynk";
  String extension = ".mp3";
  song1 = minim.loadFile(pathway + TwelveSpeed + extension);
} //End setup
//
void draw() {
} //End draw
//
void keyPressed() {
  song1.loop(0);
} //End keyPressed
//
void mousePressed() {
} //End mousePressed
//
//End MAIN Program
