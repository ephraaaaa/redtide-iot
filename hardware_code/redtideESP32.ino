#include<Firebase_ESP_Client.h>
#include <WiFiClient.h>
#include <NTPClient.h>
#include <TimeLib.h>
#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"

#define API_KEY "AIzaSyCAzkH5lIyVoOYAtIpfRdhsK611AuPV2lk"
#define DB_URL "https://red-tide-monitoring-default-rtdb.asia-southeast1.firebasedatabase.app/"

#define USER_EMAIL "redtidemonitoring.hardware@gmail.com" // hardware credentials for firebase
#define USER_PASSWORD "redtideeeee" // 


#ifndef STASSID
#define STASSID "Ephra" // replace with your own wifi credentials
#define STAPSK "myAcccount3"// replace with your own wifi credentials
#endif

//SENSOR VARIABLES
const int turbidityPin = 34;
const int pHSensorPin = 35;
unsigned long int avgValue;  
float b;
int buf[10],temp;
  



const char* ssid = STASSID;
const char* password = STAPSK;
const char* firebase_email = USER_EMAIL;
const char* firebase_password = USER_PASSWORD;
const char* api_key = API_KEY;
const char* database_url = DB_URL;
String FIREBASE_PROJECT_ID = "red-tide-monitoring";


FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;


WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP);

void setup(void) {
  
  Serial.begin(115200);
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  Serial.println("");

  // Wait for connection
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  
  Serial.print("Connected to ");
  Serial.println(ssid);
  timeClient.begin();
  config.api_key = api_key;
  config.database_url = database_url;



  auth.user.email = firebase_email;
  auth.user.password = firebase_password;
  
  Firebase.reconnectWiFi(true);
  Firebase.begin(&config, &auth);


}

void loop(void) {
  timeClient.update();
  
    //TURBIDITY
    int sensorValue = analogRead(turbidityPin);
    int ntuValue = sensorValue*(5.0/1024)*3;
    //PH
    for(int i=0;i<10;i++)       //Get 10 sample value from the sensor for smooth the value
    { 
      buf[i]=analogRead(pHSensorPin);
      delay(10);
    }
    for(int i=0;i<9;i++)        //sort the analog from small to large
    {
      for(int j=i+1;j<10;j++)
      {
        if(buf[i]>buf[j])
        {
          temp=buf[i];
          buf[i]=buf[j];
          buf[j]=temp;
        }
      }
    }
    avgValue=0;
    for(int i=2;i<8;i++)                      //take the average value of 6 center sample
    avgValue+=buf[i];
    int phValue=(float)avgValue*5.0/1024/6; //convert the analog into millivolt
    phValue=3.5*phValue;  

    
  
  /*double turbidityAnalogOut = analogRead(A0);
  double phAnalogOut = analogRead(A1);
  int acidity_level = random(14);
  int turbidity_level = random(5);   */
  int numberOfDay = timeClient.getDay();

  
  unsigned long epochTime = timeClient.getEpochTime();
  
  tmElements_t tm;
  breakTime(epochTime, tm);
  String dateStr = String(tm.Year + 1970) + "-" + twoDigits(tm.Month) + "-" + twoDigits(tm.Day);
  //FOR REALTIME MONITORING
  realtimeData(ntuValue, phValue);
  //DATA LOGGING
  logs(ntuValue, phValue, dateStr);
  // SEVEN DAY BROADCAST
  sevenDayBroadcast(ntuValue, phValue, numberOfDay);  
 delay(5000);
}











































void realtimeData(int ntuValue, int phValue){

    if(Firebase.RTDB.setInt(&fbdo,"real-time-data/turbidity", ntuValue) && Firebase.RTDB.setInt(&fbdo, "real-time-data/pH", phValue)){
      Serial.println("Uploaded data. - Realtime Data");
      }
    else {
      Serial.println("Error uploading data. - Realtime Data");
      }
}
void logs(int ntuValue, int phValue, String dateStr){
  timeClient.update();
  String epochTime = String(timeClient.getEpochTime()); 
  if(Firebase.RTDB.setInt(&fbdo,"logs/"+dateStr+"/"+epochTime+"/turbidity", ntuValue) && Firebase.RTDB.setInt(&fbdo, "logs/"+dateStr+"/"+epochTime+"/pH", phValue))
  {
    Serial.println("Uploaded data. - Logs");
    }
  else{
    Serial.println("Error uploading data. - Logs");
    }  
  }

  
void sevenDayBroadcast(int ntuValue, int phValue, int numberOfDay){
  FirebaseJson contentWeeks;
  String forGraphPath = "weekdays/"+String(numberOfDay);
        // integer
         contentWeeks.set("fields/turbidity/integerValue", ntuValue);
         contentWeeks.set("fields/pH/integerValue", phValue);
        if (Firebase.Firestore.patchDocument(&fbdo, FIREBASE_PROJECT_ID, "", forGraphPath.c_str(), contentWeeks.raw(), "turbidity","pH"))
            {
              Serial.println("Uploaded data: 7-day broadcast");
            }
        else
            {
            Serial.println("Error uploading data: 7-day broadcast");
            }
}
  
String twoDigits(int number) {
  if (number < 10) {
    return "0" + String(number);
  }
  return String(number);
}
