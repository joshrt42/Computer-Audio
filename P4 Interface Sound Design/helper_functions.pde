//Helper Functions
AudioContext ac;
double tapeSize;

Sample getSample(String fileName) {
  return SampleManager.sample(dataPath(fileName));
}

SamplePlayer getSamplePlayer(String fileName, Boolean killOnEnd) {
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

SamplePlayer getSamplePlayer(String fileName) {
  return getSamplePlayer(fileName, false);
}

//Updates the tape!
public void updateTape() {
  tapeSize = 300.0*(music.getPosition()/music.getSample().getLength());
  
  //Draw tape itself
  fill(30);
  stroke(30);
  ellipse(170, 200, 300 - (float)tapeSize, 300 - (float)tapeSize);
  ellipse(430, 200, (float)tapeSize, (float)tapeSize);
  line(170, 200 + 150-(float)tapeSize/2, 430, 200+(float)tapeSize/2);
  
  //Draw those little circles in the middle
  fill(205);
  ellipse(170, 200, 75, 75);
  ellipse(430, 200, 75, 75);
  
  //Draw some lines to spin as the music plays
  line(170.0 + 20*sin((float)music.getPosition()/130 + 0.6),
       200.0 + 20*cos((float)music.getPosition()/130 + 0.6),
       170.0 - 20*sin((float)music.getPosition()/130 + 0.6),
       200.0 - 20*cos((float)music.getPosition()/130 + 0.6));
  line(430.0 + 20*sin((float)music.getPosition()/130 - 0.6),
       200.0 + 20*cos((float)music.getPosition()/130 - 0.6),
       430.0 - 20*sin((float)music.getPosition()/130 - 0.6),
       200.0 - 20*cos((float)music.getPosition()/130 - 0.6));
}
