# MaiWallat

## Short Description
* A simple expenses applications implemented using Flutter!
* Contains a simple UI, and SQLite data storage for user to store their budget/saving/event data.

## Table of Content
* [Preview](#Preview)
* [Installation](#Installation)
* [About The Application](#About-The-Application)
* [Development Procedure](#Development-Procedure)

## Preview

## Installation
* You can download the file using ```git clone``` with HTTPS or 
```https://github.com/DaveHo19/Flutter-MaiWallat.git```
* The flutter required library will be :
  * intl 
  * table_calendar
  * sqflite
  * path
  * sizer
  * syncfusion_flutter_charts
  * flutter_launcher_icons

## About The Application
The MaiWallat application is developed using dart/flutter in Visual Studio Code. 
The applications is used to record expenses, saving and events and allows user to track these components.
Besides, it also allow user to check the statistic based on several conditions.

## Development Procedure
The procedure of develop the application is based on the step below:
* Create 3 screens in main screen and use ```BottomNavigationBar``` to swipe the screen layout.
* Design and create each of the screens in main screen.
* Design and create ```FloatingActionButton``` in main screen for data operations. 
* Connect ```Navigator``` operations with buttons in screen.
* Design and create 3 screens, which are ```ViewitemListScreen```, ```ViewItemScreen```, ```ManageItemScreen```.
* Implementation of database using ```sqflite```.
* Implement ```FutureBuilder``` for screen that required data from database,
