/*************************************************
                  DECLARATIONS
 *************************************************/
 
//Importing a few libraries
import beads.*;
import controlP5.*;
import org.jaudiolibs.beads.*;

//We're gonna use a ControlP5
ControlP5 p5;

//And music!
SamplePlayer music;

//And earcons for redundancy gain
SamplePlayer audioPlayPause;
SamplePlayer audioStop;
SamplePlayer audioFastForward;
SamplePlayer audioReverse;
SamplePlayer audioReset;

//Then a glide and a gain for volume stuff.
Glide musicGainGlide;
Glide foleyGainGlide;
Gain musicGain;
Gain foleyGain;

//Glides to determine playback speed
Glide playMode;
Glide fastMode;
Glide revMode;

//And some more flavor
PImage bg;



/*************************************************
                     SETUP
 *************************************************/
 
void setup() {
  //Establishing that the canvas, ac, and p5 exist and are real. far out.
  size(775, 600);
  bg = loadImage("background.png");
  ac = new AudioContext();
  p5 = new ControlP5(this)
    .setColorBackground(15);
  
  //This is the song. Don't play at first, song. Thanks.
  music = getSamplePlayer("wndrwll.wav");
  music.pause(true);
  
  //SFX! All from the same popping noise, filtered and such.
  audioPlayPause = getSamplePlayer("playpause.wav");
  audioStop = getSamplePlayer("stop.wav");
  audioFastForward = getSamplePlayer("fastforward.wav");
  audioReverse = getSamplePlayer("reverse.wav");
  audioReset = getSamplePlayer("reset.wav");
  audioPlayPause.pause(true);
  audioStop.pause(true);
  audioFastForward.pause(true);
  audioReverse.pause(true);
  audioReset.pause(true);
  
  //Setting music's gain and gain glide.
  musicGainGlide = new Glide(ac, 1.0, 50);
  musicGain = new Gain(ac, 1, musicGainGlide);
  musicGain.addInput(music);
  
  //SFX gain and gain glide!
  foleyGainGlide = new Glide(ac, 0.3, 50);
  foleyGain = new Gain(ac, 1, foleyGainGlide);
  foleyGain.addInput(audioPlayPause);
  foleyGain.addInput(audioStop);
  foleyGain.addInput(audioFastForward);
  foleyGain.addInput(audioReverse);
  foleyGain.addInput(audioReset);
  
  //Setting up glides for playback modes
  playMode = new Glide(ac, 1.0, 50);
  fastMode = new Glide(ac, 2.0, 50);
  revMode = new Glide(ac, -2.0, 50);
  
  //Hey speakers. Listen to these.
  ac.out.addInput(musicGain);
  ac.out.addInput(foleyGain);



/*************************************************
                 BUTTONS / SLIDERS
 *************************************************/
  
  p5.addButton("play")
    .setPosition(325, 450)
    .setSize(275, 125);
    
  p5.addButton("stopMusic")
    .setPosition(175, 450)
    .setSize(125, 125)
    .setLabel("Stop");
    
  p5.addButton("reset")
    .setPosition(25, 450)
    .setSize(125, 125);
  
  p5.addButton("fastForward")
    .setPosition(525, 375)
    .setSize(75, 50);
    
  p5.addSlider("playhead")
    .setMax(208)
    .setPosition(125, 375)
    .setSize(375, 50)
    .setColorForeground(color(255, 150, 0))
    .setColorActive(color(255, 200, 50))
    .setLabel(" ");
    
  p5.addButton("reverse")
    .setPosition(25, 375)
    .setSize(75, 50);
    
  p5.addSlider("musicGainSlider")
    .setValue(100)
    .setPosition(625, 25)
    .setSize(50, 550)
    .setColorForeground(color(255, 150, 0))
    .setColorActive(color(255, 200, 50))
    .setLabel("music volume");
    
  p5.addSlider("foleyGainSlider")
    .setValue(100)
    .setPosition(700, 25)
    .setSize(50, 550)
    .setColorForeground(color(255, 150, 0))
    .setColorActive(color(255, 200, 50))
    .setLabel("SFX volume");
  
  ac.start();
  
  //Some visualizer things
  strokeWeight(7.5);
}



/*************************************************
                      DRAW
 *************************************************/

void draw() {
  background(bg);
  updateTape();
  if (music.getPosition() > music.getSample().getLength()) {
    music.setPosition(music.getSample().getLength());
    music.pause(true);
    p5.setColorBackground(15);
    println("Playhead reached end");
  } else if (music.getPosition() < 0) {
    music.setPosition(0);
    music.pause(true);
    p5.setColorBackground(15);
    println("Playhead reached beginning");
  }
  p5.getController("playhead").setValue(208*(float)(music.getPosition()/music.getSample().getLength()));
}



/*************************************************
                    LISTENERS
 *************************************************/

//Play music from current playhead
public void play() {
  p5.setColorBackground(15);
  p5.getController("play")
    .setColorBackground(color(0, 75, 150));
  audioPlayPause.setPosition(0);
  audioPlayPause.start();
  music.setRate(playMode);
  music.start();
  println("Pressed play");
}

//Pause playback of sound
public void stopMusic() {
  p5.setColorBackground(15);
  p5.getController("stopMusic")
    .setColorBackground(color(0, 75, 150));
  audioStop.setPosition(0);
  audioStop.start();
  music.pause(true);
  println("Pressed stop");
}

//Stop playback and set playhead to start
public void reset() {
  p5.setColorBackground(15);
  audioReset.setPosition(0);
  audioReset.start();
  music.setPosition(0);
  music.pause(true);
  println("Pressed reset");
  println("Playhead reset");
}

//Doubles playback speed
public void fastForward() {
  p5.setColorBackground(15);
  p5.getController("fastForward")
    .setColorBackground(color(0, 75, 150));
  audioFastForward.setPosition(0);
  audioFastForward.start();
  music.setRate(fastMode);
  music.start();
  println("Pressed fast forward");
}

//Displays playback position in seconds. Can be dragged
public void playhead(float value) {
  music.setPosition(value/208 * music.getSample().getLength());
}

//Reverses playback at an increased speed
public void reverse() {
  p5.setColorBackground(15);
  p5.getController("reverse")
    .setColorBackground(color(0, 75, 150));
  audioReverse.setPosition(0);
  audioReverse.start();
  music.setRate(revMode);
  music.start();
  println("Pressed reverse");
}

//Manipulates music volume
public void musicGainSlider(float value) {
  musicGainGlide.setValue(value/100);
  println("Changed music volume to " + value);
}

//Manipulates foley volume
public void foleyGainSlider(float value) {
  foleyGainGlide.setValue(value/200);
  println("Changed foley volume to " + value);
}
