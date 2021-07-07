***
# ⭐ THE IMAGE ITERATOR ⭐
***
***

### Teamproject Summer Term 2021 - Photography


## Table of Contents
1. [About the project](#about-the-project)
2. [Features](#features)
4. [Getting Started](#gettingstarted)
5. [Usage](#usage)
6. [Contributing](#contributing)
7. [Acknowledgements](#acknowledgements)
8. [License](#license)
9. [Sources](#sources)

## About the project 

This is the repository for the teamproject course, summer term 2021, working on automating photography manipulation


who are we?

We are 4 students at the University of Tübingen and we are all studying computer science (2 computer science, 1 medical informatics, 1 media informatics) and have been working together on this project since the summer semester began.
on 07/27/2021 is our final presentation of this project

Add:

* is used to edit image data sets
* language: Lua
* works with Adobe Lightroom Classic 10.3

## Features

(Of our plug-in)

* The special thing about our plugin is that you can select several images at once and import, export and edit them.

* import and export pictures
* save pictures in folder
* change settings (contrast, saturation, highlights)
* available settings: Exposure, Contrast, Highlights, Shadows, Whites, Blacks, Clarity, Vibrance, Saturation


## Getting Started

### 🛠 Set up
+ Make a new directory under the standard home directory called "TheImageIterator".

  Home directory..

     + for Windows: C/Users/username/
  
     + for Mac OS: /Users/username/
  
+ Make sure to save the configuration file "configurationFile.json" under this folder. 
+ Then execute the plugin.  


* Error messages have 3 parts:

lib/a_name_error.rb:3:in `<main>': undefined local variable or method `hello_world' for main:Object (NameError)


1. The location of the error, the "where".

lib/a_name_error.rb:3:in `<main>:

* lib/a_name_error.rb is the file the error occurred in.
* 3 is the line of code with the error.
* <main> is the scope of the error.
  
  
2. The description, the "why".
  
undefined local variable or method `hello_world' for main:Object
  
The interpreter does the best job it can to tell you what it thinks went wrong.
  
  
3. The type of error, the "who".
  
(NameError)

This is an example gif.

![testgif](testgif.gif)

1. Open the Plug-in Manager after starting Adobe Photoshop Lightroom Desktop: File > Plug-in Manager
2. Add the plug-in: Add-Button
3. Choose the pictures you want to edit.
4. Start the plug-in: Library > Plug-in Extras > The Image Iterator

Add:

* Gifs 
* Starting from Downloading the Folder for the plugin 


## Usage

Add:

* Gifs and description of the steps

1. Different Features of the plug-in 
2. How to export the pictures

### Config file
Example for Config file 
```json
{"highlights":0,"saturation":0,"contrast":30}
```
## Contributing

### How to compile
  
* luac -o
* 

### Debugging

## Acknowledgements
  
* interested in image editing
* programming skills would be an advantage

## License

Distributed under the [MIT](https://choosealicense.com/licenses/mit/) License.

## Sources
1. [JSON Library for Lua Accessed: May 20, 2021](https://github.com/rxi/json.lua/blob/master/json.lua)
2. [Sample pictures for testing the plug-in Accessed: May 22, 2021](https://pixabay.com/de/)
