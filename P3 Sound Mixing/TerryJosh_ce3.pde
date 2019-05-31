import beads.*;
import controlP5.*;
import org.jaudiolibs.beads.*;

ControlP5 p5;

SamplePlayer BG;
SamplePlayer VO1;
SamplePlayer VO2;

Glide gAllGlide;
Glide gBGGlide;

Gain gAll;
Gain gBG;

void setup() {
  size(550,450);
  ac = new AudioContext();
  p5 = new ControlP5(this);
  
  BG = getSamplePlayer("intermission.wav");
  BG.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  
  VO1 = getSamplePlayer("vo1.wav");
  VO1.pause(true);
  
  VO2 = getSamplePlayer("vo2.wav");
  VO2.pause(true);
  
  gAllGlide = new Glide(ac, 0.5, 50);
  gBGGlide = new Glide(ac, 1.0, 200);
  gAll = new Gain(ac, 1, gAllGlide);
  gBG = new Gain(ac, 1, gBGGlide);
  
  gAll.addInput(VO1);
  gAll.addInput(VO2);
  gBG.addInput(BG);
  gAll.addInput(gBG);
  
  ac.out.addInput(gAll);
  
  p5.addButton("VO1button")
    .setPosition(100, 100)
    .setSize(200, 100)
    .setLabel("Voiceover #1");
    
  p5.addButton("VO2button")
    .setPosition(100, 250)
    .setSize(200, 100)
    .setLabel("Voiceover #1");
  
  p5.addSlider("gAllSlider")
    .setMin(0.0)
    .setMax(1.0)
    .setValue(0.5)
    .setPosition(350, 100)
    .setSize(100, 250)
    .setLabel("Volume");
    
  ac.start();
  BG.start();
}

void draw() {
  background(0);
  soundChecker(VO1);
  soundChecker(VO2);
}

public void VO1button() {
  duckBG(VO1);
}

public void VO2button() {
  duckBG(VO2);
}

public void gAllSlider(float value) {
  gAllGlide.setValue(value);
}
