// demo for all the abilities of the RGBmatrixPanel library. public domain!

#include "RGBmatrixPanel.h"
#include <TimerOne.h>

#define A     A0
#define B     A1
#define C     A2
#define OE    A3
#define LAT   9

boolean TICK;
boolean isPaused;
boolean wasPaused;
boolean countingUp; // if 1 then we ARE going up else counting down
boolean inMenu;

int seconds, hours;
int minutes = 8;

long mytimer;

int CurX;
int CurY;

int defaultTimeYpos = 1; // 4x4 is centere for text size 1  
int defaultTimeXpos = 0;  


const int CountingUp   = 0;
const int CountingDown = 1;
const int Yes          = 1;
const int No           = 0;

int timerRunning = 0; // is the timer currently running?
int timerIndex = 0; // index num for our Timer arrays;

int timerTime[]         = {30,  6,  7, 15};                                       // Time (in seconds) we should start with.  Thinking > is going to count down
int timerCountingUp[]   = {CountingDown, CountingUp, CountingDown, CountingUp};    // Should we count up or down? 0 = counting up and 1 is counting down
int timerShowRounds[]   = {Yes, Yes, Yes, Yes};    // should we show the Round Numbers after we start/repeat?
int timerDelayedStart[] = {Yes,  Yes,  Yes, Yes};  // Do we do a delayed start 3.2.1 GO before begin?
int timerRepeatRounds[] = {4,  4,  4, 4};  // how many times do we repeat EVERYTHING including any intervals?
int timerIntTime[]      = {1, 4, 3, 2};    // interval time in seconds
int timerIntNum[]       = {5, 4, 3, 2};    // number of intervals to do
int timerWarnOnEnd[]    = {Yes, No, Yes, Yes};    // should we do a 3.2.1 at the end of the interval time?

// used when we're looking for timing with millis
//unsigned long start, finished, elapsed;

// constants won't change. They're used here to set pin numbers:
const int ReadyToRecPin  = 10; // dig pin that we'll go HIGH when we're ready to get next code
const int PinsSetPin     = 11;   // sender is finished setting pins

const int DigSerPinOne   = 12;   // this is the pin(s) that (IR) sender will set
const int DigSerPinTwo   = 13; 
const int DigSerPinThree = 19;  // this is really analog pin 5

// The clock pin must be digital 8
// The data pins must connect to digital 2-7

RGBmatrixPanel matrix(A, B, C, LAT, OE);

// wrapper for the redrawing code, this gets called by the interrupt
void refresh() { 
  matrix.updateDisplay();
  // 5000 is 1 second
  if (mytimer++ > 5000) { 
    TICK++; 
    mytimer=0; 
  } // this should hit every 200us which is means 5000 should be 1 second
}

// m ranges from 0 to 100%
void setCPUmaxpercent(uint8_t m) {
  float time = 100;        // 100 %

  time *=  150;           // each redraw takes 150 microseconds
  time /= m;              // how long between interrupts

  Serial.print("Using Interrupt Time of: ");
  Serial.println(time);
  Timer1.initialize(time);  // microseconds per tick
  Timer1.attachInterrupt(refresh);
}

void drawIntroConerDots()
{
  // draw a pixel in solid white
  matrix.drawPixel(0, 0, matrix.Color333(7, 7, 7)); 
  delay(50);

  matrix.drawPixel(0, 15, matrix.Color333(7, 7, 7)); 
  delay(50);

  matrix.drawPixel(31, 15, matrix.Color333(7, 7, 7)); 
  delay(50);

  matrix.drawPixel(31, 0, matrix.Color333(7, 7, 7)); 
  delay(500);

  // fill the screen with 'black'
  matrix.fill(matrix.Color333(0, 0, 0));
}

void setup() {
  Serial.begin(9600);
  Serial.println("Reader Starting...");

  pinMode(ReadyToRecPin, OUTPUT);      
  pinMode(PinsSetPin, INPUT);     

  pinMode(DigSerPinOne, INPUT);  
  pinMode(DigSerPinTwo, INPUT);  
  pinMode(DigSerPinThree, INPUT);  

  Serial.println("Setting RTR to HIGH - we are ready");
  digitalWrite(ReadyToRecPin, HIGH); 

  matrix.begin();

  // initialize the timer that refreshes the delay using our helper
  // 50% seems to be the minimum for 9 bit color, higher will make the display
  // look better
  setCPUmaxpercent(75);

  // draw something of logic before we begin
  drawIntroConerDots();

  wasPaused=0;    // were we *just* paused?
  isPaused=0;     // are we currently paused?

  matrix.setCursor(defaultTimeXpos, defaultTimeYpos);     
  matrix.setTextColor(matrix.Color333(7,7,7)); 
  matrix.setTextSize(1);

  // not sure what this does
  //matrix.dumpMatrix();

  //showRandomCircles();
  //showRainbowScreen();  
  timerRunning=1;
}

void loop() {

  //int startTime = millis();
  //matrix.setTextSize(1);    // size 1 == 8 pixels high

  checkIRpins();
  
  if (timerRunning) { runTimer(); }
  

// here we should check for setup and goto it
//  setupTimer();

  // random does a max-1 so we need inc that last number
  // matrix.drawPixel(random(0,33), 15, matrix.Color333(random(1,8), random(1,8), random(1,8))); 
  // matrix.drawPixel(random(0,33), 15, matrix.Color333(0, 0, 0)); 

  // check the pins for any IR commands coming in
  


} // end MAIN loop


void runTimer()
{

  if (TICK && !isPaused)
    {      
      TICK=0;
      if (wasPaused)
      {
        //Serial.println("wasPaused so going to erase PAUSE");
        matrix.fill(matrix.Color333(0, 0, 0));  
        wasPaused=0;
      }
      else  { 
        showTime(); 
      }

      if (timerCountingUp[timerIndex]) { seconds++; Serial.println("Counting Up"); }
      else { seconds--; }
    
    }
  else if (isPaused && !wasPaused) { showPaused(); }  
  
} // end runTimer

void setupTimer()
{
  
//  showStartMsg();
//  setupTimer();
  
  
}

void checkIRpins()
{
  if (digitalRead(PinsSetPin) == HIGH)
  {
    Serial.println("Got High from WRITER");
    Serial.println("Setting RTR to LOW while we read");
    digitalWrite(ReadyToRecPin, LOW); 

    // read in all the bits
    //PinOneState = digitalRead(DigSerPinOne);
    Serial.print("Got Pins of:");
    Serial.print(digitalRead(DigSerPinOne));
    Serial.print(digitalRead(DigSerPinTwo));
    Serial.println(digitalRead(DigSerPinThree));

    if (isPaused) { 
      isPaused=0; 
      wasPaused=1; 
    } 
    else          { 
      isPaused=1; 
    }

    // tell sender we're done
    //Serial.println("All done reading so let's set HIGH for NEXT");
    digitalWrite(ReadyToRecPin, HIGH); 
  } // end if PinsAreSet check

  //  int finishTime = millis() - startTime;
  //  Serial.print("total time: ");
  //  Serial.println(finishTime);
}

void showTime()
{
  // print secondsfs
  matrix.setCursor(defaultTimeXpos, defaultTimeYpos);     
  matrix.setTextColor(matrix.Color333(0,0,0)); 
  matrix.print(minutes); 
  //  matrix.print(":"); 
  padNumber(seconds-1);
  matrix.print(seconds-1);

  //  if (seconds > 59) { 
  if (seconds > 10) { 
    seconds=0; 
    minutes++; 
  }

  if (minutes > 59) { 
    minutes=0;
    hours++;
    defaultTimeXpos = defaultTimeXpos + 2;    
  }

  if (minutes == 10 && seconds == 0) { 
    defaultTimeXpos = defaultTimeXpos - 2; 
  }

  matrix.setCursor(defaultTimeXpos, defaultTimeYpos);  
  matrix.setTextColor(matrix.Color333(random(0,7),random(0,7),random(0,7))); 
  matrix.print(minutes); 
  //  matrix.print(":"); 
  padNumber(seconds);
  matrix.print(seconds);

}

void padNumber(int myNum)
{
  if (myNum < 10) { 
    matrix.print("0"); 
  }  
}

void showPaused()
{
  matrix.fill(matrix.Color333(0, 0, 0));  
  matrix.setCursor(2, 4);     
  matrix.setTextSize(1);    // size 1 == 8 pixels high
  matrix.setTextColor(matrix.Color333(8,8,8)); 
  matrix.print("PAUSE");    
  wasPaused=1;
}

void printTxtDelayErase(int Xpos, int Ypos, char msg[5], int delayTime, int redColor, int greenColor, int blueColor )
{
  matrix.setCursor(Xpos, Ypos);
  matrix.print(msg);   
  delay(delayTime);
  matrix.setCursor(Xpos, Ypos);
  matrix.setTextColor(matrix.Color333(0,0,0)); 
  matrix.print(msg);   
  matrix.setTextColor(matrix.Color333(redColor,greenColor,blueColor)); 
}

void showStopScreen()
{
}

void showRandomCircles()
{
  for (int myRadius=1; myRadius < 23; myRadius++)
  {
    matrix.drawCircle(16, 8, myRadius, matrix.Color333(random(0,8),random(0,8),random(0,8))); 
    delay(100);
    if (myRadius > 4) 
    {
      matrix.drawCircle(16, 8, myRadius-4, matrix.Color333(0,0,0)); 
    }
  }  
}



void showRainbowScreen()
{
  int sleepbetween=10;

  for (int myred=0; myred < 8; myred++)
  {
    for (int mygreen=0; mygreen < 8; mygreen++)
    {
      for (int myblue=0; myblue < 8; myblue++)
      {
        matrix.fillRect(0, 0, 32, 16, matrix.Color333(myred, mygreen, myblue));
        delay(sleepbetween);
        matrix.fill(matrix.Color333(0, 0, 0));
      }
    }
  }
}




void showStartMsg()
{

  matrix.setTextSize(2);    // size 1 == 8 pixels high

  printTxtDelayErase(10,1,"3",1000,5,5,5);
  printTxtDelayErase(10,1,"2",1000,5,5,5);
  printTxtDelayErase(10,1,"1",1000,5,5,5);

  // lets flash GO
  printTxtDelayErase(5,1,"GO",100,5,5,5);
  printTxtDelayErase(5,1,"GO",100,0,0,0);
  printTxtDelayErase(5,1,"GO",100,5,5,5);
  printTxtDelayErase(5,1,"GO",100,0,0,0);
  printTxtDelayErase(5,1,"GO",100,5,5,5);
  printTxtDelayErase(5,1,"GO",100,0,0,0);
  printTxtDelayErase(5,1,"GO",100,5,5,5);
  printTxtDelayErase(5,1,"GO",100,0,0,0);

  mytimer=0; 
  matrix.setTextSize(1);    // size 1 == 8 pixels high

  //  for (int c=1; c < 32; c++)
  //  {
  //    printTxtDelayErase(c,1,"GO",100);
  //  }

  // let's reset this so we're starting at a full ZERO seconds

  delay(1000);
}

void testFonts()
{
  //###############################################################

  matrix.setTextFont(1);
  for (int x=0; x<10; x++)  {    
    matrix.fill(matrix.Color333(0, 0, 0));  
    matrix.setCursor(12,0);     
    matrix.write(x);   
    delay(250);
  }

  delay(5000);
  //###############################################################

  matrix.fill(matrix.Color333(0, 0, 0));  
  matrix.setTextFont(2);
  matrix.setCursor(0,-2);   
  for (int x=0; x<5; x++)  {    
    matrix.write(x);   
  }

  delay(5000);
  //###############################################################

  matrix.fill(matrix.Color333(0, 0, 0));  
  matrix.setTextFont(3);

  for (int x=0; x<10; x++)  {    
    matrix.setCursor(8,-1);     
    matrix.write(x);   
    delay(1000);
    matrix.fill(matrix.Color333(0, 0, 0));  
  }

}



















