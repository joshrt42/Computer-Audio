/*************************************************
                  DECLARATIONS
 *************************************************/
 
//Importing a few libraries
import beads.*;
import controlP5.*;
import org.jaudiolibs.beads.*;

//We're gonna use a ControlP5
ControlP5 p5;

//We'll have 10 waves
int waveCount = 10;

//Gonna keep track of the type of wave playing
int mode = 0;

//And a waveplayer for each one, as well as Glides and Gains
WavePlayer[] wavePlayerArray = new WavePlayer[waveCount];
Glide[] gainGlideArray = new Glide[waveCount];
Glide[] freqGlideArray = new Glide[waveCount];
Gain[] gainArray = new Gain[waveCount];

Glide masterGainGlide;
Gain masterGain;



/*************************************************
                     SETUP
 *************************************************/
 
void setup() {
  //Establishing that the canvas, ac, and p5 exist and are real. far out.
  size(350, 350);
  ac = new AudioContext();
  p5 = new ControlP5(this);
  masterGainGlide = new Glide(ac, 1.0, 1);
  masterGain = new Gain(ac, 1, masterGainGlide);
  
  //Setting the default setting of each wave.
  for (int wave = 0; wave < waveCount; wave++) {
    freqGlideArray[wave] = new Glide(ac, 1.0, 1);
    wavePlayerArray[wave] = new WavePlayer(ac, freqGlideArray[wave], Buffer.SINE);
    
    gainGlideArray[wave] = new Glide(ac, 1.0, 1);
    gainArray[wave] = new Gain(ac, 1, gainGlideArray[wave]);
    
    gainArray[wave].addInput(wavePlayerArray[wave]);
    masterGain.addInput(gainArray[wave]);
  }
  
  //Hey speakers. Listen to this.
  ac.out.addInput(masterGain);



/*************************************************
                 BUTTONS / SLIDERS
 *************************************************/
  
  p5.addLabel("waveform")
    .setPosition(15, 30);
    
  p5.addButton("Sine")
    .setPosition(15, 50)
    .setSize(100, 100);
  
  p5.addButton("Square")
    .setPosition(130, 50)
    .setSize(100, 100);
    
  p5.addButton("Triangle")
    .setPosition(15, 165)
    .setSize(100, 100);
    
  p5.addButton("Sawtooth")
    .setPosition(130, 165)
    .setSize(100, 100);
    
  p5.addSlider("Fundamental")
    .setPosition(15, 280)
    .setSize(215, 30)
    .setRange(0.0, 20000.0)
    .setValue(200)
    .setLabel("Fundamental Frequency");
    
  p5.addSlider("Gain")
    .setPosition(245, 50)
    .setSize(30, 215)
    .setRange(0.0, 1.0)
    .setValue(0.5)
    .setLabel("Master Gain");
    
  ac.start();
}


/*************************************************
                      DRAW
 *************************************************/

void draw() {
  background(15);
}



/*************************************************
                    LISTENERS
 *************************************************/
 
 public void Sine() {
   playSine();
   mode = 0;
 }
 
 public void Square() {
   playSquare();
   mode = 1;
 }
 
 public void Triangle() {
   playTriangle();
   mode = 2;
 }
 
 public void Sawtooth() {
   playSawtooth();
   mode = 3;
 }
 
 public void Fundamental(float value) {
   freqGlideArray[0].setValue(value);
   updateFundamentals(mode);
 }
 
 public void Gain(float value) {
   gainGlideArray[0].setValue(value);
 }
