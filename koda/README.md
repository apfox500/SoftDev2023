# koda

koda is an app similar to Duolingo that teaches coding to people with daily activities and lessons, as well as allowing the user to take pictures of code and have it translated to understandable, easy-to-read pseudocode.


## An outline of the lib folder
### /models - Collection of data
##### This folder contains collections of data sourced from our api/server, so for us that is the Global file and variable

### /providers - Interactions outside the app
##### This folder is stuff that deals with the cloud, api and JSON requests and the like

### /screens - Screens and UI
##### Holds actual the UI of the app, divided into three sub folders:
####  - /screens/common - Frequently used pages
####  - /screens/flash - loading screens, sign in pages, etc.
####  - /screens/uncommon - pages that are rarely used

### /utilities - Logic
##### This contains logic, custom classes, and other functions to help run the app smoothly

### /widgets - Custom Widgets/Layouts
##### Those in multiple parts of the app or not a full screen