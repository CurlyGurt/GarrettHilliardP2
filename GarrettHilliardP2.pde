PFont digi;
PFont reg;
int temperature = 0;
int lowTemperature = 0;
int dayOfWeek;
import java.util.Calendar;
import java.lang.*;
import grafica.*;
import processing.video.*;
String weekAbb = "";
String[] articles = new String[10];
int currArticle = 0;
PImage img[] = new PImage[10];
String imageString[] = new String[10];
boolean rectLeft = false;
boolean rectRight = false;
int leftButtonX = 0;
int rightButtonX = 0;
int newsButtonY = 0;
String month = "";
String[] DOW = {"SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"}; //days of the week
int weekOfMonth = 0;
String[] weeklySchedule = new String[7];
Capture cam;
GPointsArray points = new GPointsArray(5);
boolean loadPic = true;
int newsX = 1022;
int newsY = 158;
int plotX = 4;
int plotY = 4;
int calX = 4;
int calY = 206;
int weathX = 1022;
int weathY = 8;
int middle = 640;
int clockY = 60;
boolean overNews = false;
boolean overPlot = false;
boolean overCal = false;
boolean overWeath = false;
boolean overClock = false;
int displacementX;
int displacementY;



void setup() {
  size(1280, 720);
  frameRate(60);
  digi = createFont("digital-7.ttf", 128);
  reg = createFont("ostrich-sans.sans-rounded-medium.ttf", 128);
  //reg = createFont("Arialic Hollow.ttf", 64);
  
  //Weather JSONs
  String weatherUrl = "https://api.weather.gov/gridpoints/LUB/50,36/forecast";
  JSONObject weather = loadJSONObject(weatherUrl);
  JSONObject props = weather.getJSONObject("properties");
  JSONArray periods = props.getJSONArray("periods");
  temperature = periods.getJSONObject(0).getInt("temperature");
  lowTemperature = periods.getJSONObject(1).getInt("temperature");
  Calendar c = Calendar.getInstance();
  dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
  int monthNum = c.get(Calendar.MONTH);
  weekOfMonth = c.get(Calendar.WEEK_OF_MONTH);
  //print(dayOfWeek);
  switch (dayOfWeek) {
    case 1: weekAbb = "SUN"; break;
    case 2: weekAbb = "MON"; break;
    case 3: weekAbb = "TUE"; break;
    case 4: weekAbb = "WED"; break;
    case 5: weekAbb = "THU"; break;
    case 6: weekAbb = "FRI"; break;
    case 7: weekAbb = "SAT"; break;
  }
  switch (monthNum) {
    case 0: month  = "January"; break;
    case 1: month  = "February"; break;
    case 2: month  = "March"; break;
    case 3: month  = "April"; break;
    case 4: month  = "May"; break;
    case 5: month  = "June"; break;
    case 6: month  = "July"; break;
    case 7: month  = "August"; break;
    case 8: month  = "September"; break;
    case 9: month  = "October"; break;
    case 10: month  = "November"; break;
    case 11: month  = "December"; break;
  }
  
  //News JSONs
  String newsUrl = "https://newsdata.io/api/1/news?apikey=pub_13429437e9849ed6ef67682b1a3a113daadb0&q=texas&language=en";
  JSONObject news = loadJSONObject(newsUrl);
  JSONArray results = news.getJSONArray("results");
  int i;
  for(i = 0; i < results.size() && i < 10; i++) {
    //println(results.size());
    //println("i = " + i);
    articles[i] = results.getJSONObject(i).getString("title");
    if(!results.getJSONObject(i).isNull("image_url")) {
      imageString[i] = results.getJSONObject(i).getString("image_url");
    }
    //println(imageString[i]);
  }
  //articles[0] = results.getJSONObject(0).getString("title");
  
  //Calendar JSONs
  JSONObject cal = loadJSONObject("calendar.json");
  JSONArray currWeek = cal.getJSONArray("week");
  for(i = 0; i < currWeek.size() && i < 7; i++) {
    weeklySchedule[i] = currWeek.getJSONObject(i).getString("event");
    //println(weeklySchedule[i]);
  }
  
  //camera setup
  String[] cameras = Capture.list();
  cam = new Capture(this, cameras[0]);
  cam.start();
  
  Table csvfile = loadTable("weight.csv", "header");
  
  //println(csvfile.getRowCount() + " total rows in table");
  for(TableRow row : csvfile.rows()) {
    int week = row.getInt("week");
    int weight = row.getInt("weight");
    points.add(week, weight);
    //println("W"+week+" Weight: "+weight);
  }
}


void draw() {
  background(255);
  if(cam.available()) cam.read();
  image(cam, 0, 0, 1280, 720);
  update(mouseX, mouseY);
  clock();
  weather();
  news();
  plot();
  calendar();
}

void plot() {
  
  GPlot plot = new GPlot(this);
  plot.setPos(plotX, plotY);
  plot.setTitleText(month + " Progress");
  plot.getXAxis().setAxisLabelText("Week");
  plot.getYAxis().setAxisLabelText("Weight");
  
  plot.setPoints(points);
  
  //plot.size();
  plot.setDim(250,100);
  plot.defaultDraw();
  //plot.align(plotX+4,plotY+4, 346, 196);
  
  fill(255,255,255,0);
  stroke(0);
  strokeWeight(8);
  rect(plotX, plotY, 350, 200);
  
}

void calendar() {
  fill(255);
  stroke(0);
  strokeWeight(8);
  rect(calX, calY, 254, 250);
  textSize(40);
  //rect(30, 8, 200, 50);
  fill(0);
  textAlign(CENTER);
  text(month, calX+26, calY+4, 200, 50);
  fill(0);
  //rect(calX+200, calY+4, 50, 75);
  textAlign(RIGHT);
  text("W" + weekOfMonth, calX+200, calY+4, 50, 75);
  strokeWeight(2);
  fill(255);
  rect(calX+4, calY+36, 246, 30);
  rect(calX+4, calY+66, 246, 30);
  rect(calX+4, calY+96, 246, 30);
  rect(calX+4, calY+126, 246, 30);
  rect(calX+4, calY+156, 246, 30);
  rect(calX+4, calY+186, 246, 30);
  rect(calX+4, calY+216, 246, 30);
  
  fill(130, 130, 130, 100);
  noStroke();
  rect(calX+4, calY+36, 246, 30*(dayOfWeek-1));
  
  textSize(30);
  fill(0);
  textAlign(LEFT);
  text(DOW[0]+": " + weeklySchedule[0], calX+8, calY+63);
  text(DOW[1]+": " + weeklySchedule[1], calX+8, calY+63+30);
  text(DOW[2]+": " + weeklySchedule[2], calX+8, calY+63+60);
  text(DOW[3]+": " + weeklySchedule[3], calX+8, calY+63+90);
  text(DOW[4]+": " + weeklySchedule[4], calX+8, calY+63+120);
  text(DOW[5]+": " + weeklySchedule[5], calX+8, calY+63+150);
  text(DOW[6]+": " + weeklySchedule[6], calX+8, calY+63+180);
  
  
  
}

void mousePressed() {
  if(rectLeft) {
    if(currArticle == 0) currArticle = 9;
    else currArticle--;
    loadPic = true;
  }
  if(rectRight) {
    if(currArticle == 9) currArticle = 0;
    else currArticle++;
    loadPic = true;
  }
  if(overNews) {
    displacementX = mouseX - newsX;
    displacementY = mouseY - newsY;
  }
  if(overPlot) {
    displacementX = mouseX - plotX;
    displacementY = mouseY - plotY;
  }
  if(overCal) {
    displacementX = mouseX - calX;
    displacementY = mouseY - calY;
  }
  if(overWeath) {
    displacementX = mouseX - weathX;
    displacementY = mouseY - weathY;
  }
  if(overClock) {
    displacementX = mouseX - (middle - 150);
    displacementY = mouseY - clockY;
  }
}

void mouseReleased() {
  displacementX = 0;
  displacementY = 0;
}

/*
int newsX = 1022;
int newsY = 158;
int plotX = 4;
int plotY = 4;
int calX = 4;
int calY = 206;
int weathX = 1022;
int weathY = 8;
int middle = 640;
int clockY = 60;
boolean overNews = false;
boolean overPlot = false;
boolean overCal = false;
boolean overWeath = false;
boolean overClock = false;
*/
void mouseDragged() {
  if(overNews) {
    newsX = mouseX - displacementX;
    newsY = mouseY - displacementY;
    //println("mouseCoords = (" + mouseX + "," + mouseY + ") newsCoords = (" + newsX + "," + newsY + ") displacements = (" + displacementX + "," + displacementY + ")");
  }
  if(overPlot) {
    plotX = mouseX - displacementX;
    plotY = mouseY - displacementY;
  }
  if(overCal) {
    calX = mouseX - displacementX;
    calY = mouseY - displacementY;
  }
  if(overWeath) {
    weathX = mouseX - displacementX;
    weathY = mouseY - displacementY;
  }
  if(overClock) {
    middle = mouseX - displacementX;
    clockY = mouseY - displacementY;
  }
}

void update(int x, int y) {
  if(overButt(leftButtonX, newsButtonY, 40, 25)) {
    rectLeft = true;
    rectRight = false;
  }
  else if(overButt(rightButtonX, newsButtonY, 40, 25)) {
    rectLeft = false;
    rectRight = true;
  }
  else {
    rectLeft = false;
    rectRight = false;
  }
  if(overButt(newsX, newsY, 254, 200)) {
    overNews = true;
    overPlot = false;
    overCal = false;
    overWeath = false;
    overClock = false;
  }
  else if(overButt(plotX, plotY, 350, 200)) {
    overNews = false;
    overPlot = true;
    overCal = false;
    overWeath = false;
    overClock = false;
  }
  else if(overButt(calX, calY, 254, 250)) {
    overNews = false;
    overPlot = false;
    overCal = true;
    overWeath = false;
    overClock = false;
  }
  else if(overButt(weathX, weathY, 254, 150)) {
    overNews = false;
    overPlot = false;
    overCal = false;
    overWeath = true;
    overClock = false;
  }
  else if(overButt((middle-150), clockY, 300, 65)) {
    overNews = false;
    overPlot = false;
    overCal = false;
    overWeath = false;
    overClock = true;
  }
  else {
    overNews = false;
    overPlot = false;
    overCal = false;
    overWeath = false;
    overClock = false;
  }
}

boolean overButt(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

/*
boolean overRight(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
} */

void news() {
  //regular text
  textFont(reg);
  
  leftButtonX = newsX+30;
  rightButtonX = newsX+185;
  newsButtonY = newsY+8;
  
  //outline
  fill(255);
  stroke(0);
  strokeWeight(8);
  rect(newsX, newsY, 254, 200);
  
  //news text
  textSize(40);
  fill(0);
  text("News", newsX+78, newsY+4, 100, 50);
  //rect(newsX+78, newsY+8, 100, 50);
  
  //buttons
  strokeWeight(2);
  fill(255);
  rect(newsX+30, newsY+8, 40, 25);
  rect(newsX+185, newsY+8, 40, 25);
  fill(0);
  rect(newsX+45-3, newsY+18, 20, 5);
  triangle(newsX+40-3, newsY+20, newsX+45-3, newsY+15, newsX+45-3, newsY+26);
  rect(newsX+45+150-2, newsY+18, 20, 5);
  triangle(newsX+218, newsY+20, newsX+213, newsY+15, newsX+213, newsY+26);
  
  //article title
  fill(0);
  textSize(20);
  //if(loadPic) {
    //loadPic = false;
    if(imageString[currArticle] != null) {
      if(loadPic) {img[currArticle] = loadImage(imageString[currArticle]); loadPic = false;}
      image(img[currArticle], newsX+5, newsY+35, 245, 115);
    }
    
  //}
  //println(imageString[currArticle]);
  //text(articles[currArticle].substring(0, Math.min(articles[currArticle].length(), 50)) + ". . .", newsX+10, newsY+150, 235, 50);
  text(articles[currArticle] + ". . .", newsX+10, newsY+150, 235, 50);
  //rect(newsX+10, newsY+150, 235, 50);
}

void weather() {
  //regular text
  textFont(reg);
  
  
  //outline
  fill(255);
  stroke(0);
  strokeWeight(8);
  rect(weathX, weathY, 254, 150);
  
  //City
  fill(0);
  textSize(50);
  text("Lubbock, TX", weathX+127, weathY+42);
  
  //High
  textSize(60);
  fill(150,50,50);
  text(temperature, weathX+223, weathY+90);
  
  //MidBar
  fill(0);
  noStroke();
  rect(weathX+198, weathY+92, 50, 3);
  
  //Low
  fill(50, 50, 150);
  textSize(60);
  text(lowTemperature, weathX+223, weathY+140);
  
  //Day of the week
  fill(0);
  textSize(50);
  text(weekAbb, weathX+40, weathY+80);
  text(month() + "/", weathX+27, weathY+120);
  text(day(), weathX+57, weathY+120);
  
  //
  if(hour() >= 6 && hour() <= 18) {
    fill(245, 157, 49);
    ellipse(weathX+130, weathY+90, 75, 75);
  }
  else {
    fill(72, 138, 134);
    ellipse(weathX+130, weathY+90, 75, 75);
    fill(255);
    ellipse(weathX+110, weathY+90, 75, 75);
  }
}

void clock() {
  
  fill(255);
  stroke(0);
  strokeWeight(8);
  rect(middle-150, clockY-55, 300, 65);
  int hour = hour();
  int minute = minute();
  int second = second();
  String trueSec;
  String trueMin;
  String trueHour;
  
  if((second / 10) < 1) {
    trueSec = "0" + str(second);
  }
  else {
    trueSec = str(second);
  }
  if((minute / 10) < 1) {
    trueMin = "0" + str(minute);
  }
  else {
    trueMin = str(minute);
  }
  if((hour / 10) < 1) {
    trueHour = "0" + str(hour);
  }
  else {
    trueHour = str(hour);
  }
  textAlign(CENTER);
  fill(0);
  textFont(digi);
  textSize(70);
  //text("88" + " : " + "88" + " : " + "88", middle-150, 10, 300, 50);
  text(trueHour, middle-100, clockY);
  text(":", middle-50, clockY);
  text(trueMin, middle, clockY);
  text(":", middle+50, clockY);
  text(trueSec, middle+100, clockY);
  textAlign(CENTER);
}
