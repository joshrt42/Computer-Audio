/*************************************************
                    DEFINITIONS
 *************************************************/
import beads.*;
import controlP5.*;
import org.jaudiolibs.beads.*;

ControlP5 p5;

NotificationServer ns;
ArrayList<Notification> notifications;

Pusher pusher;

SamplePlayer contextPublicTransit;
SamplePlayer contextJogging;
SamplePlayer contextParty;
SamplePlayer contextLecture;

SamplePlayer tweetHi;
SamplePlayer tweetMed;
SamplePlayer tweetLo;

SamplePlayer textHi;
SamplePlayer textMed;
SamplePlayer textLo;

SamplePlayer emailHi;
SamplePlayer emailMed;
SamplePlayer emailLo;

SamplePlayer phoneHi;
SamplePlayer phoneMed;
SamplePlayer phoneLo;

SamplePlayer voiceHi;
SamplePlayer voiceMed;
SamplePlayer voiceLo;

WavePlayer batteryStatus;
WavePlayer serviceStatus;
Glide batteryGlide;
Glide serviceGlide;
Glide statusGainGlide;
Gain batteryGain;
Gain serviceGain;
Gain statusGain;

Glide notifGlide;
Glide contextGlide;
Gain notifGain;
Gain contextGain;

String context;

boolean doTwitter;
boolean doText;
boolean doEmail;
boolean doPhoneCall;
boolean doVoiceMail;

int eventStream = 1;
int statusOn = 0;
int statusLength = 100;



/*************************************************
                    Setup
 *************************************************/
void setup() {
  size(630, 530);
  ac = new AudioContext();
  p5 = new ControlP5(this);
  
  ns = new NotificationServer();
  
  pusher = new Pusher();
  
  ns.addListener(pusher);
  
  notifGlide = new Glide(ac, 1.0, 1);
  contextGlide = new Glide(ac, 1.0, 1);
  notifGain = new Gain(ac, 1, notifGlide);
  contextGain = new Gain(ac, 1, contextGlide);
  
  contextPublicTransit = getSamplePlayer("publictransit.wav");
  contextJogging = getSamplePlayer("jogging.wav");
  contextParty = getSamplePlayer("party.wav");
  contextLecture = getSamplePlayer("lecture.wav");
  
  tweetLo = getSamplePlayer("tweetLo.wav");
  tweetMed = getSamplePlayer("tweetMed.wav");
  tweetHi = getSamplePlayer("tweetHi.wav");
  
  textLo = getSamplePlayer("textLo.wav");
  textMed = getSamplePlayer("textMed.wav");
  textHi = getSamplePlayer("textHi.wav");
  
  emailLo = getSamplePlayer("emailLo.wav");
  emailMed = getSamplePlayer("emailMed.wav");
  emailHi = getSamplePlayer("emailHi.wav");
  
  phoneLo = getSamplePlayer("phoneLo.wav");
  phoneMed = getSamplePlayer("phoneMed.wav");
  phoneHi = getSamplePlayer("phoneHi.wav");
  
  voiceLo = getSamplePlayer("voiceLo.wav");
  voiceMed = getSamplePlayer("voiceMed.wav");
  voiceHi = getSamplePlayer("voiceHi.wav");
  
  contextPublicTransit.pause(true);
  contextJogging.pause(true);
  contextParty.pause(true);
  contextLecture.pause(true);
  
  tweetLo.pause(true);
  tweetMed.pause(true);
  tweetHi.pause(true);
  
  textLo.pause(true);
  textMed.pause(true);
  textHi.pause(true);
  
  emailLo.pause(true);
  emailMed.pause(true);
  emailHi.pause(true);
  
  phoneLo.pause(true);
  phoneMed.pause(true);
  phoneHi.pause(true);
  
  voiceLo.pause(true);
  voiceMed.pause(true);
  voiceHi.pause(true);
  
  contextPublicTransit.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  contextJogging.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  contextParty.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  contextLecture.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  
  contextGain.addInput(contextPublicTransit);
  contextGain.addInput(contextJogging);
  contextGain.addInput(contextParty);
  contextGain.addInput(contextLecture);
  
  notifGain.addInput(tweetLo);
  notifGain.addInput(tweetMed);
  notifGain.addInput(tweetHi);
  
  notifGain.addInput(textLo);
  notifGain.addInput(textMed);
  notifGain.addInput(textHi);
  
  notifGain.addInput(emailLo);
  notifGain.addInput(emailMed);
  notifGain.addInput(emailHi);
  
  notifGain.addInput(phoneLo);
  notifGain.addInput(phoneMed);
  notifGain.addInput(phoneHi);
  
  notifGain.addInput(voiceLo);
  notifGain.addInput(voiceMed);
  notifGain.addInput(voiceHi);
  
  batteryGlide = new Glide(ac, 1.0, 1);
  serviceGlide = new Glide(ac, 1.0, 1);
  statusGainGlide = new Glide(ac, 0.4, 1);
  
  statusGain = new Gain(ac, 1, statusGainGlide);
  batteryStatus = new WavePlayer(ac, batteryGlide, Buffer.SINE);
  serviceStatus = new WavePlayer(ac, serviceGlide, Buffer.SINE);
  batteryStatus.pause(true);
  serviceStatus.pause(true);
  
  statusGain.addInput(batteryStatus);
  statusGain.addInput(serviceStatus);
  
  ac.out.addInput(statusGain);
  ac.out.addInput(notifGain);
  ac.out.addInput(contextGain);
  
  background(0);
  p5.setColorBackground(color(100, 50, 0));





/*************************************************
                    UI Elements
 *************************************************/
  
//----------------------------------context UI elements
  p5.addLabel("Context:")
    .setPosition(20, 30);
 
  p5.addButton("contextPublicTransit")
    .setPosition(20, 50)
    .setSize(150, 100)
    .setLabel("Public Transit");
  
  p5.addButton("contextJogging")
    .setPosition(20, 170)
    .setSize(150, 100)
    .setLabel("Jogging");
  
  p5.addButton("contextParty")
    .setPosition(20, 290)
    .setSize(150, 100)
    .setLabel("Party");
  
  p5.addButton("contextLecture")
    .setPosition(20, 410)
    .setSize(150, 100)
    .setLabel("Lecture");
  
//----------------------------------notification UI elements
  p5.addLabel("Notifications:")
    .setPosition(200, 30);
    
  p5.addToggle("notificationTwitter")
    .setPosition(200, 50)
    .setSize(45, 45)
    .setLabel("twitter");
    
  p5.addToggle("notificationEmail")
    .setPosition(255, 50)
    .setSize(45, 45)
    .setLabel("email");
    
  p5.addToggle("notificationText")
    .setPosition(310, 50)
    .setSize(45, 45)
    .setLabel("text");
    
  p5.addToggle("notificationPhoneCall")
    .setPosition(200, 115)
    .setSize(45, 45)
    .setLabel("phonecall");
    
  p5.addToggle("notificationVoiceMail")
    .setPosition(255, 115)
    .setSize(45, 45)
    .setLabel("voicemail");
    
//----------------------------------json UI elements
  p5.addLabel("Example Event Stream:")
    .setPosition(200, 205);
    
  p5.addButton("stream1")
    .setPosition(200, 225)
    .setSize(45, 45);
    
  p5.addButton("stream2")
    .setPosition(255, 225)
    .setSize(45, 45);
    
  p5.addButton("stream3")
    .setPosition(310, 225)
    .setSize(45, 45);

//----------------------------------Play UI element
  p5.addSlider("contextVolume")
    .setPosition(200, 295)
    .setSize(150, 35)
    .setRange(0, 1)
    .setValue(0.99)
    .setLabel("Context Volume");
    
  p5.addSlider("notificationVolume")
    .setPosition(200, 355)
    .setSize(150, 35)
    .setRange(0, 1)
    .setValue(0.99)
    .setLabel("Alert Volume");

//----------------------------------Play UI element
  p5.addButton("playEvents")
    .setPosition(200, 410)
    .setSize(150, 100)
    .setLabel("Play Notifications");
    
//----------------------------------Status UI elements
  p5.addSlider("battery")
    .setPosition(450, 50)
    .setSize(60, 335)
    .setNumberOfTickMarks(4)
    .snapToTickMarks(true)
    .setRange(0,3);
    
  p5.addSlider("signal")
    .setPosition(540, 50)
    .setSize(60, 335)
    .setNumberOfTickMarks(4)
    .snapToTickMarks(true)
    .setRange(0,3);
  
  p5.addButton("playStatus")
    .setPosition(450, 410)
    .setSize(150, 100)
    .setLabel("Play Status Update");
    
    
    
    
  ac.start();
}



/*************************************************
                    DRAW
 *************************************************/
void draw() {
  background(0);

}



/*************************************************
                    LISTENERS
 *************************************************/

//----------------------------------contexts
public void contextPublicTransit() {
  updateContextColor("contextPublicTransit");
  updateContextAudio(contextPublicTransit);
  changeContext("PublicTransit");
}

public void contextJogging() {
  updateContextColor("contextJogging");
  updateContextAudio(contextJogging);
  changeContext("Jogging");
}

public void contextParty() {
  updateContextColor("contextParty");
  updateContextAudio(contextParty);
  changeContext("Party");
}

public void contextLecture() {
  updateContextColor("contextLecture");
  updateContextAudio(contextLecture);
  changeContext("Lecture");
}

//----------------------------------notification listeners
public void notificationTwitter(boolean value) {
  doTwitter = value;
  println("Twitter notifications set to: " + doTwitter);
}

public void notificationEmail(boolean value) {
  doEmail = value;
  println("Email notifications set to: " + doEmail);
}

public void notificationText(boolean value) {
  doText = value;
  println("Email notification set to: " + doText);
}

public void notificationPhoneCall(boolean value) {
  doPhoneCall = value;
  println("Phone call notifications set to: " + doPhoneCall);
}

public void notificationVoiceMail(boolean value) {
  doVoiceMail = value;
  println("Voicemail notifications set to: " + doVoiceMail);
}

//----------------------------------json listeners
public void stream1() {
  ns.stopEventStream();
  updateStreamColor("stream1");
  eventStream = 1;
}

public void stream2() {
  ns.stopEventStream();
  updateStreamColor("stream2");
  eventStream = 2;
}

public void stream3() {
  ns.stopEventStream();
  updateStreamColor("stream3");
  eventStream = 3;
}

//----------------------------------play listener
public void contextVolume(float value) {
  contextGlide.setValue(value);
  println("Changed context Volume to " + value);
}

public void notificationVolume(float value) {
  notifGlide.setValue(value);
  println("Changed notification Volume to " + value);
}

//----------------------------------play listener
public void playEvents() {
  String jsonToLoad = "ExampleData_" + eventStream + ".json";
  println(jsonToLoad);
  ns.loadEventStream(jsonToLoad);
}

//----------------------------------status listeners
public void battery(float value) {
  batteryGlide.setValue((value * 80) + 500);
}

public void signal(float value) {
  serviceGlide.setValue(value * 20 + 40);
  statusLength = Math.round(100+value*100);
  println(statusLength);
}

public void playStatus() {
  batteryStatus.start();
  serviceStatus.start();
  delay(statusLength);
  batteryStatus.pause(true);
  serviceStatus.pause(true);
}


/*************************************************
                    NotificationListener
 *************************************************/
 
 class Pusher implements NotificationListener {
 
     
    public void notificationReceived(Notification notification) {
      println("<Pusher> " + notification.getType().toString() + " notification received at "
      + Integer.toString(notification.getTimestamp()) + "millis.");
      int p = notification.getPriorityLevel();
       
    switch (notification.getType()) {
      case Tweet:
        if (doTwitter) {
          if (context.equals("PublicTransit")) {
            if (p == 1) {
              tweetHi.setPosition(0);
              tweetHi.start();
            } else if (p == 2) {
              tweetMed.setPosition(0);
              tweetMed.start();
            } else if (p == 3) {
              tweetLo.setPosition(0);
              tweetLo.start();
            } else {
              tweetLo.setPosition(0);
              tweetLo.start();
            }
          } else if (context.equals("Jogging")) {
            if (p == 1) {
              tweetMed.setPosition(0);
              tweetMed.start();
            } else if (p == 2) {
              tweetLo.setPosition(0);
              tweetLo.start();
            } else if (p == 3) {
              tweetLo.setPosition(0);
              tweetLo.start();
            }
          } else if (context.equals("Party")) {
            if (p == 1) {
              tweetLo.setPosition(0);
              tweetLo.start();
            } else if (p == 2) {
              tweetLo.setPosition(0);
              tweetLo.start();
            }
          } else {
            println("invalid context");
          }
        }
        break;
      case Email:
        if (doEmail) {
           if (context.equals("PublicTransit")) {
             if (p == 1) {
               emailHi.setPosition(0);
               emailHi.start();
             } else if (p == 2) {
               emailMed.setPosition(0);
               emailMed.start();
             } else {
               emailLo.setPosition(0);
               emailLo.start();
             }
           } else if (context.equals("Jogging")) {
             if (p == 1) {
               emailMed.setPosition(0);
               emailMed.start();
             } else if (p == 2) {
               emailLo.setPosition(0);
               emailLo.start();
             } else if (p == 3) {
               emailLo.setPosition(0);
               emailLo.start();
             }
           } else if (context.equals("Party")) {
             if (p == 1) {
               emailLo.setPosition(0);
               emailLo.start();
             }
           } else if (context.equals("Lecture")) {
             if (p == 1) {
               emailLo.setPosition(0);
               emailLo.start();
             }
           } else {
             println("invalid context");
           }
        }
        break;
      case VoiceMail:
        if (doVoiceMail) {
           if (context.equals("PublicTransit")) {
             if (p == 1) {
               voiceHi.setPosition(0);
               voiceHi.start();
             } else if (p == 2) {
               voiceHi.setPosition(0);
               voiceHi.start();
             } else if (p == 3) {
               voiceMed.setPosition(0);
               voiceMed.start();
             } else {
               voiceLo.setPosition(0);
               voiceLo.start();
             }
           } else if (context.equals("Jogging")) {
             if (p == 1) {
               voiceHi.setPosition(0);
               voiceHi.start();
             } else if (p == 2) {
               voiceMed.setPosition(0);
               voiceMed.start();
             } else {
               voiceLo.setPosition(0);
               voiceLo.start();
             }
           } else if (context.equals("Party")) {
             if (p == 1) {
               voiceHi.setPosition(0);
               voiceHi.start();
             }
           } else if (context.equals("Lecture")) {
             if (p == 1) {
               voiceLo.setPosition(0);
               voiceLo.start();
             }
           } else {
             println("invalid context");
           }
        }
        break;
      case MissedCall:
        if (doPhoneCall) {
           if (context.equals("PublicTransit")) {
             if (p == 1) {
               phoneHi.setPosition(0);
               phoneHi.start();
             } else if (p == 2) {
               phoneHi.setPosition(0);
               phoneHi.start();
             } else if (p == 3) {
               phoneMed.setPosition(0);
               phoneMed.start();
             } else {
               phoneLo.setPosition(0);
               phoneLo.start();
             }
           } else if (context.equals("Jogging")) {
             if (p == 1) {
               phoneLo.setPosition(0);
               phoneLo.start();
             }
           } else if (context.equals("Party")) {
             if (p == 1) {
               phoneHi.setPosition(0);
               phoneHi.start();
             } else if (p == 2) {
               phoneLo.setPosition(0);
               phoneLo.start();
             }
           } else if (context.equals("Lecture")) {
             if (p == 1) {
               phoneLo.setPosition(0);
               phoneLo.start();
             }
           } else {
             println("invalid context");
           }
        }
        break;
      case TextMessage:
        if (doText) {
           if (context.equals("PublicTransit")) {
             if (p == 1) {
               textHi.setPosition(0);
               textHi.start();
             } else {
               textMed.setPosition(0);
               textMed.start();
             }
           } else if (context.equals("Jogging")) {
             if (p == 1) {
               textHi.setPosition(0);
               textHi.start();
             } else if (p == 2) {
               textMed.setPosition(0);
               textMed.start();
             } else if (p == 3) {
               textMed.setPosition(0);
               textMed.start();
             } else {
               textLo.setPosition(0);
               textLo.start();
             }
           } else if (context.equals("Party")) {
             if (p == 1) {
               textMed.setPosition(0);
               textMed.start();
             } else {
               textLo.setPosition(0);
               textLo.start();
             }
           } else if (context.equals("Lecture")) {
             if (p == 1) {
               textLo.setPosition(0);
               textLo.start();
             } else if (p == 2) {
               textLo.setPosition(0);
               textLo.start();
             }
           } else {
             println("invalid context");
           }
        }
        break;
     }
     }
 }
