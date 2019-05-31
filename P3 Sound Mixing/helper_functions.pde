//helper functions
AudioContext ac; //needed here because getSamplePlayer() uses it below

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

public void duckBG(SamplePlayer event) {
  VO1.pause(true);
  VO2.pause(true);
  gBGGlide.setValue(0.25);
  event.setToLoopStart();
  event.start();
  println(event.getName() + " called. playing. ");
}

public void soundChecker(SamplePlayer event){
  if(event.getPosition() >= event.getSample().getLength()) {
    println(event.getName() + " finished playing.");
    event.pause(true);
    gBGGlide.setValue(1.0);
    event.setToLoopStart();
  }
}
