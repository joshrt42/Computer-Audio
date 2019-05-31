import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;

ControlP5 p5;

SamplePlayer sp;
Glide gainGlide;
Glide lpGlide;
Glide hpGlide;
Gain g;

BiquadFilter lpFilter;
BiquadFilter hpFilter;

void setup() {
  size(500, 500);
  ac = new AudioContext();
  
  p5 = new ControlP5(this);
     
  sp = getSamplePlayer("27882__stickinthemud__bike-horn-double-toot.wav");
  sp.setKillOnEnd(false);
  sp.pause(true);
  
  gainGlide = new Glide(ac, 0.0, 50);
  lpGlide = new Glide(ac, 0.0, 50);
  hpGlide = new Glide(ac, 0.0, 50);
  g = new Gain(ac, 1, gainGlide);
  
  lpFilter = new BiquadFilter(ac, BiquadFilter.LP, lpGlide, 0.5f);
  hpFilter = new BiquadFilter(ac, BiquadFilter.HP, hpGlide, 0.5f);
  
  lpFilter.addInput(sp);
  hpFilter.addInput(sp);
  g.addInput(lpFilter);
  g.addInput(hpFilter);
  
  ac.out.addInput(g);
  
  //Implement more of p5 here!
  p5.addButton("play")
    .setValue(0)
    .setPosition(100,150)
    .setSize(200,50);
    
  p5.addSlider("lpSlider")
    .setMin(0.0)
    .setMax(20000.0)
    .setValue(10000.0)
    .setPosition(100,225)
    .setSize(200,50)
    .setLabel("Low Pass");
    
  p5.addSlider("hpSlider")
    .setMin(0.0)
    .setMax(20000.0)
    .setValue(10000.0)
    .setPosition(100,300)
    .setSize(200,50)
    .setLabel("High Pass");
  
  p5.addSlider("gainSlider")
    .setMin(0.0)
    .setMax(1.0)
    .setValue(0.5)
    .setPosition(375,150)
    .setSize(50,200)
    .setLabel("Gain");
  
  ac.start();
}

void draw() {
  background(0);
  text("Honk honk", 100, 100);
}

void controlEvent(ControlEvent theEvent) {
  if(theEvent.isController()) {
    print("control event from : " + theEvent.getController().getName());
    println(", value : " + theEvent.getController().getValue());
    
  }
}

public void play() {
  println("Play pressed.");
  sp.setToLoopStart();
  sp.start();
}

public void lpSlider(float value) {
  lpGlide.setValue(value);
}

public void hpSlider(float value) {
  hpGlide.setValue(value);
}

public void gainSlider(float value) {
  gainGlide.setValue(value);
}
