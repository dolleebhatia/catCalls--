//PROCESSING CODE

//import cc.arduino.*;
import java.io.*;
import processing.serial.*;
Serial myPort; 

int startTime;  
int analogPin = 5;
int myV; // PIR sensor value
int fsr = 0;
int fsr1 = 0;
int counter = 0;
boolean call = false;
PFont font;
//Arduino arduino;
 
//////////////////////////////////////////////////////////////////////////////
void setup(){
  size(400, 300);
  font = createFont("ArialUnicodeMS-12.vlw",22, false); 
 
 
  //my board is the 2nd serial device, hence Arduino.list()[1]
// println(arduino.list());
  //arduino = new Arduino(this, Arduino.list()[1], 57600);
  startTime = millis();
  println(Serial.list()); 
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');
 // myPort.clear();
}
 
//////////////////////////////////////////////////////////////////////////////
void draw(){
    background(0);
    fill(255);
    textFont(font, 22); 
    textAlign(CENTER,CENTER);
    text("PIR sensor value: " + myV,width/2,height/2);
    text("Active for " + round(millis()/1000) + " seconds",width/2,height*3/4);



//After 1 minute, set counter to 0
 int now = millis();
  if (now - startTime > 5000) {
    counter = 0;
    startTime = now;
  }


 if (fsr==0 && call == true){

   callme();
    call = false;
    println("Calling..");
    myPort.clear();
  }
  else if (fsr > 80){
   
    call = false; 
  }
  
  
  
  
}
  
  
void callme(){
 counter ++;
 println(counter);
 if (counter < 2){
 link("skype:echo123?call");
 }
 
}

void serialEvent (Serial myPort) 
{
  String myString = myPort.readStringUntil('\n');
  if (myString != null)
 
    myString = trim(myString);
  int sensors[] = int (split(myString, ','));
  for (int sensorNum = 0; sensorNum < sensors.length; sensorNum++)
    print("Sensor" + sensorNum + ":" + sensors[sensorNum] + "\t"); 
  println();

  if (sensors.length > 1)
  { 
    
    fsr = sensors[0];
    if (fsr==0){
      call = true; 
    }
    else if (fsr != 0){
     call = false; 
    }
    fsr1 = sensors[1];
    myPort.clear();
  }
}

