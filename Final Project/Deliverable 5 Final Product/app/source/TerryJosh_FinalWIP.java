import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import beads.*; 
import controlP5.*; 
import org.jaudiolibs.beads.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class TerryJosh_FinalWIP extends PApplet {

/*************************************************
                    DEFINITIONS
 *************************************************/




ControlP5 p5;

SamplePlayer bpmLo;
SamplePlayer bpmHi;
SamplePlayer tempLo;
SamplePlayer tempHi;
SamplePlayer notificationLo;
SamplePlayer notificationMed;
SamplePlayer notificationHi;

Glide bpmGlide;
Glide tempGlide;
Glide masterGlide;

Gain bpmGain;
Gain tempGain;
Gain masterGain;

float priority;
float tempPriority;
float bpmPriority;
boolean playStress;
boolean playTemp;

/*************************************************
                    Setup
 *************************************************/

public void setup() {
  
  ac = new AudioContext();
  p5 = new ControlP5(this);
  
  bpmGlide = new Glide(ac, 1.0f, 1);
  tempGlide = new Glide(ac, 1.0f, 1);
  masterGlide = new Glide(ac, 1.0f, 1);
  
  bpmGain = new Gain(ac, 1, bpmGlide);
  tempGain = new Gain(ac, 1, tempGlide);
  masterGain = new Gain(ac, 1, masterGlide);
  
  bpmLo = getSamplePlayer("bpm low - snoring.wav");
  bpmHi = getSamplePlayer("bpm hi - bark.wav");
  tempLo = getSamplePlayer("temp low - blizzard.wav");
  tempHi = getSamplePlayer("temp hi - match.wav");
  notificationLo = getSamplePlayer("notify low.wav");
  notificationMed = getSamplePlayer("notify med.wav");
  notificationHi = getSamplePlayer("notify hi.wav");
  
  bpmLo.pause(true);
  bpmHi.pause(true);
  tempLo.pause(true);
  tempHi.pause(true);
  notificationLo.pause(true);
  notificationMed.pause(true);
  notificationHi.pause(true);
  
  bpmGain.addInput(bpmLo);
  bpmGain.addInput(bpmHi);
  tempGain.addInput(tempLo);
  tempGain.addInput(tempHi);
  masterGain.addInput(notificationLo);
  masterGain.addInput(notificationMed);
  masterGain.addInput(notificationHi);
  masterGain.addInput(bpmGain);
  masterGain.addInput(tempGain);
  
  ac.out.addInput(masterGain);
  
  background(0);
  p5.setColorBackground(color(100, 100, 100));
 
 
 
/*************************************************
                    UI Elements
 *************************************************/
 
//----------------------------------BPM + Temperature Sliders
  p5.addSlider("stressLevel")
    .setPosition(40, 40)
    .setSize(400, 40)
    .setNumberOfTickMarks(4)
    .snapToTickMarks(false)
    .setRange(0, 1)
    .setValue(0.5f)
    .setLabel("Stress\nLevel");
    
  p5.addSlider("tempLevel")
    .setPosition(40, 120)
    .setSize(400, 40)
    .setNumberOfTickMarks(4)
    .snapToTickMarks(false)
    .setRange(0, 1)
    .setValue(0.5f)
    .setLabel("Temp\nLevel");
 
//----------------------------------BPM + Temperature Toggles
  p5.addToggle("stressToggle")
    .setPosition(40, 200)
    .setSize(40, 40)
    .setLabel("Stress\nToggle");
    
  p5.addToggle("tempToggle")
    .setPosition(100, 200)
    .setSize(40, 40)
    .setLabel("Temp\nToggle");
 
//----------------------------------Gain Slider
  p5.addSlider("gainLevel")
    .setPosition(160, 200)
    .setSize(160, 40)
    .setRange(0,1)
    .setValue(0.9f)
    .setLabel("");
  
  p5.addLabel("VOLUME")
    .setPosition(160, 245);
 
//----------------------------------Play
  p5.addButton("play")
    .setPosition(340, 200)
    .setSize(100, 40);

  ac.start();
}

/*************************************************
                    DRAW
 *************************************************/

public void draw() {
  background(0);
}



/*************************************************
                    LISTENERS
 *************************************************/
 
//----------------------------------BPM + Temperature Sliders
public void stressLevel(float value) {
  bpmGlide.setValue(value);
  priority = 0 + bpmPriority + tempPriority;
  bpmPriority = abs(0.5f - bpmGlide.getValue());
  println("bpmPriority updated to: " + bpmPriority +
          "\nPriority updated to: " + priority);
}

public void tempLevel(float value) {
  tempGlide.setValue(value);
  priority = 0 + bpmPriority + tempPriority;
  tempPriority = abs(0.5f - tempGlide.getValue());
  println("tempPriority updated to: " + tempPriority +
          "\nPriority updated to: " + priority);
}
 
//----------------------------------BPM + Temperature Toggles
public void stressToggle(boolean value) {
  playStress = value;
  println(playStress);
}

public void tempToggle(boolean value) {
  playTemp = value;
  println(playTemp);
}
 
//----------------------------------Gain Slider
public void gainLevel(float value) {
  masterGlide.setValue(value);
  println(masterGlide.getValue());
}
 
//----------------------------------Play
public void play() {
 if (bpmPriority > 0.16f && tempPriority > 0.16f
     || priority >= 0.5f) {
   notificationHi.setPosition(0);
   notificationHi.start();
 } else if (bpmPriority > 0.16f || tempPriority > 0.16f) {
   notificationMed.setPosition(0);
   notificationMed.start();
 } else {
   notificationLo.setPosition(0);
   notificationLo.start();
 }
 delay(1000);
 if (playStress && bpmGlide.getValue() > 0.666f) {
   bpmHi.setPosition(0);
   bpmHi.start();
 } else if (playStress && bpmGlide.getValue() < 0.333f) {
   bpmLo.setPosition(0);
   bpmLo.start();
 }
 delay(1000);
 if(playTemp && tempGlide.getValue() > 0.666f) {
   tempHi.setPosition(0);
   tempHi.start();
 } else if (playTemp && tempGlide.getValue() < 0.333f) {
   tempLo.setPosition(0);
   tempLo.start();
 }
}
//Helper Functions
AudioContext ac;

public Sample getSample(String fileName) {
  return SampleManager.sample(dataPath(fileName));
}

public SamplePlayer getSamplePlayer(String fileName, Boolean killOnEnd) {
  SamplePlayer player = null;
  try {
    player = new SamplePlayer(ac, getSample(fileName));
    player.setKillOnEnd(killOnEnd);
    player.setName(fileName);
  }
  catch(Exception e) {
    println("Exception while attempting to load sample: " + fileName);
    e.printStackTrace();
    exit();
  }
  
  return player;
}

public SamplePlayer getSamplePlayer(String fileName) {
  return getSamplePlayer(fileName, false);
}
  public void settings() {  size(480, 300); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "TerryJosh_FinalWIP" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
