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

//Update the color of the 4 context buttons
public void updateContextColor(String contextName) {
  p5.getController("contextPublicTransit").setColorBackground(color(100, 50, 0));
  p5.getController("contextJogging").setColorBackground(color(100, 50, 0));
  p5.getController("contextParty").setColorBackground(color(100, 50, 0));
  p5.getController("contextLecture").setColorBackground(color(100, 50, 0));
  p5.getController(contextName)
    .setColorBackground(color(0, 75, 150));
}

//Update the color of the 3 stream buttons
public void updateStreamColor(String streamName) {
  p5.getController("stream3").setColorBackground(color(100, 50, 0));
  p5.getController("stream2").setColorBackground(color(100, 50, 0));
  p5.getController("stream1").setColorBackground(color(100, 50, 0));
  p5.getController(streamName)
    .setColorBackground(color(0, 75, 150));
}

//Pause and restart all  contexts, then start the audio of the button pressed
public void updateContextAudio(SamplePlayer newContext) {
  contextPublicTransit.setPosition(0);
  contextPublicTransit.pause(true);
  contextJogging.setPosition(0);
  contextJogging.pause(true);
  contextParty.setPosition(0);
  contextParty.pause(true);
  contextLecture.setPosition(0);
  contextLecture.pause(true);
  newContext.start();
}

public void changeContext(String newContext) {
  context = newContext;
  println("Context changed to " + newContext);
}
