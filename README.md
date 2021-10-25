# sea-level-sensors-ios-app
Sea Sensors app was created to allow the general public, government officials, and business owners across Savannah to easily access the Smart Sea Level Sensors and to use that data to announce warnings and to make decisions.

## Tabs
This app has three main tabs: the learning tab, data tab, and favorites tab.

### Learning Tab
The learning tab allows the user to learn more about the project and why this project is important. There are 5 panels in this tab that the user can tap and learn about the different aspects of this project. The first panel, our mission pannel, discusses the purpose behind the project and shows the user an introductory video of what this project is all about. The second panel, the why pannel, presents to the user why this project is important and what this project hopes to solve. The third panel, the tech specifications panel, shows the different components of the sea level sensors and how the sensors record data. The fourth panel, the past storm data pannel, presents data to the user showing how hurricanes caused millions of dollars in damages just in Chatham county! This is to show the relevance and significance of this project. The fifth panel, the who are we pannel, shows the user who is working behind the scenes to make this project a reality and shows the contributors to this project.

### Data Tab
The data tab allows the users to access the sea level sensors throughout Chatham county. The sensors are presented in a table format in which the user can tap and access the specific sensor's data. The top right of the tab contains a refresh icon, in which the user can refresh the table if they wanted to reload the entire table. Each row of the table contains the specific sensor's location and a colored icon to represent the sensor's status. The sensor's status shows if that sensor's location's water level is high, which causes that area of Chatham county to flood. If the icon is blue that means there's no current warning for that location because the water level is less than 1.2 meters. If the icon is yellow, there is a warning for that sensor's location that there is possible flooding since the water level is greater than 1.2 meters. If the icon is red, there is a severe warning because the water level is greater than 1.5 meters. If the icon is pink that specific sensor is an air quality sensor and doesn't provide warnings about the water level.

### Favorites Tab
The favorites tab allows the user to favorite specific sensors, which allows the user to easily access those sensors instead of having to scroll through the data tab and find those sensors. The favorites tab is in a table format in which the user can easily click on the sensors that they view often. Favorited sensors' title are stored on the user's phone. This is to reduce the amount of storage required to favorite a specific sensor. To favorite a sensor, the user has to go to the data tab and find the sensor(s) that the user wants to favorite. The user has to click on that sensor which will display the sensor's data page (more information about the sensor's data page is down below). On the top right of the page, there is an empty heart icon which denotes that this sensor is not favorited. The user can top on this icon and the empty heart will change to a filled heart, which means that the user has favorited the sensor. The user can go to the favorites tab and access that sensor on the favorites tab. If the user wants to unfavorite that sensor, the user can tap on the filled-in heart in the sensor's data page, and it will unfavorite that sensor and remove the sensor from the favorites tab.
When the user has no sensors favorited, the favorites tab will say "N/A - Add sensors to favorites for quick view". Once the user favorites sensors, those sensors will be displayed in the favorites tab.

#### Sensor Data Page
When a user clicks on a sensor, the user will be taken to the sensor's data page. The data page contains the title of the sensor, which is the sensor's location. At the top right of the page, there is a heart icon in which the user can tap and favorite the sensor (more information on how to favorite sensor scroll up to read "Favorites Tab"). Below the title, there will be the sensor's status with a description of the status. The page also contains an Apple map of the location of the sensor. The page also contains multiple descriptions of the sensor such as the SensorThings ID, Device ID, Location description, and Sensor NAVD 88 elevation. Below the descriptions, the app will present the user with 50 latest data observations collected by the sensor. The user can scroll left and right to see multiple obervations. Each obervation has the time of that specfific obervation and the value collected by the sensor at that time. The left most observation is the most recent obervation, and the right most obervation at the scroll wheel is the 50th obervation in the list. There are 4 possible types of data that the sensor collects: air pressure, water level, battery level, and air temperature. Some sensors record all 4 data types, while some record only some of these 4. 

## Slide Menu
In each of the tabs, the top left contains a menu icon that when tapped on slides the menu open. The menu opens and presents the Smart Sea Level Sensors logo with 4 links that the user can click on. The user can click on learn more, dashboard website, contact us, and about this app.

### Learn More
When the user clicks on the learn more link, an in-app safari will open up and take the user to the official Smart Sea Level Sensors website. The user can then roam around the site and learn more about the project and new updates concerning the project.

[Website of the learn more link](https://www.sealevelsensors.org)

### Dashboard Website
When the user clicks on the dashboard website link, just like the learn more link, an in-app safari will open; however, this link takes the user to the Smart Sea Level Sensors dashboard in which they can see the web view of the data recorded by the sensors. If the user is interested to see a web version of the sensors' data, they can click on this link and view the web version.

[Website of the dashboard website link](https://dashboard.sealevelsensors.org)

### Contact Us
The contact us link will open an in-app safari to a google forms page. The user can give feedback on the app through the google form. **NOTE: This google form is exclusively for feedback on the Sea Sensors app.** The form asks for first name, last name, email address, city, how did you hear about the Smart Sea Level Sensor Project, how did you hear about the sea sensors app, and feedback.

[Website of the contact us link](https://docs.google.com/forms/d/e/1FAIpQLSdNXpt8COeKYSPTg64uU_ML25Hnd-m0DMsX6ziDYeDhAcfFKw/viewform?usp=sf_link)

### About This App
This link will direct the user to an about this app page. The page presents to the user what is the goal of this project and why this app was created. The page includes a picture of the creator of this app and gives a description of his goals and who he is. Below his description includes his contact information.

## Installation
If you are interested in downloading the app from this GitHub source code, first download XCode. XCode is an Apple developer software used to run Apple software. **NOTE: XCode only runs on Mac computers.** Once XCode is downloaded, download the Sea Sensor folder in the master branch of this repo. Once the Sea Sensor folder is downloaded, open "Sea Sensors.xcodeproj" with XCode. 
