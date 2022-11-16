# Initial Design of the Magic Mirror:
![IMG_20221115_194433149](https://user-images.githubusercontent.com/114094237/202063333-82c5cd0d-92bd-4136-90ac-f1505e84de40.jpg)

I have decided to keep my design fairly simplistic. I decided to line the edges of the mirror with the interactive panels so that you can still easily see your self.
I put the date next to the weather so that you can see what day of the week it is at a glance. I put the clock at the middle in the top so that you can always see what time it is.
I initially decided to place the calendar in the top-left, but after implementing the design, I decided to place it under the weight graph.
I included a panel to switch between your personal messages and social accounts. Below that, I put a line graph that represents your weight.

# Implementing the design:
I began this project by implementing the Weather panel. I did this by learning and using the National Weather Service's API to recieve real-time data.
I was unable to accurately portray clouds or rain so I decided to make the sun turn into the moon depending on what time of day it is. I was able to retrieve the 
current date by using Java's Calendar class.

Next, I implemented the News panel. I began the News panel by finding a suitable news API; I decided that NewsData.IO's API was good and signed up for an account
to acquire an API key. I learned the ins and outs of their API and discovered that you could strip the headline from it. I then found where they made the 
articles images available and added them to make the panel more visually appealing. I added buttons so that you could scroll to different stories using my
button code from Project 1.

After the News Panel, I implemented the Calender panel. I again utilized Java's Calender class to extract the current month and display it at the top. The Calender
Class also contains a function to extrapolate the current week of the month and I utilized that as well. I decided against doing an entire month like I had 
planned in my sketch as I did not think I would have enough room, so I opted to go by week instead. I created my own JSON file to display the current upcoming 
events of the user. I decided to gray out days that had already passed so that It was clear as to what day it was.

Finally, I implemented the weight graph. Using a unique library by the name of Grafica, I was able to easily create a line graph that grabs data from a CSV file.
To grab the data, I used processing's loadTable function. I was then able to use Grafica's GPlot function to add values to the graph and then display them correctly.

To finish off the project, I implemented the capturing of the camera so that it looks like you are actually using a mirror. When I initially added he images to the News panel,
I decided to load the image every frame. This was not an issue until I began using the camera; using both simultaneously slowed the program down to a crawl.
I optimized the program by only a loading the image once and making some flags so that it would stay in place as intended.

# Implementing Advanced Features:
After finishing the main requirements, I decided to implement one of the advanced features. I chose to make it where you can drag and drop the panels wherever you please.
Fortunately, I had the foresight to base all of my panels coordinates off of their own variables, so this feature was fairly easy to implement. Using Processing's
 mouseDragged function and my button code from project 1, I was easily able to grab a panel move it. I unfortunately struggled for a bit as my initial code would 
 immediately move the panels top left corner to the mouse pointer instead of the panel staying where it was relative to the mouse panel. I was able to fix this
 using mousePressed and mouseReleased.
# Presentation:
