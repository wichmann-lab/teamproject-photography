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
* includes export of your selected images in a matrix-modification format
* processes the images using all possible combinations e.g. Contrast = [10,20], Saturation = [30,40] <br>
the following combinations will be applied on your selected photos: <br>
{[Contrast = 10, Saturation = 30],[Contrast = 10 , Saturation = 40], [Contrast = 20, Saturation = 30], [Contrast = 20 , Saturation = 40]}
* available settings: Exposure, Contrast, Highlights, Shadows, Whites, Blacks, Clarity, Vibrance, Saturation


## Getting Started

### 🛠 Set up
+ Create a new directory called "TheImageIterator" under the standard home directory.

  Home directory..

     + for Windows: `C/Users/username/`
  
     + for Mac OS: `/Users/username/`
  
+ Make sure to save the configuration file [`imageIteratorSettings.json`](lightroom_plugin.lrdevplugin/imageIteratorSettings.json) under this folder. 
+ Add the Plug-in in Lightroom Classic: File -> Plug-in Manager... -> Add -> Select the folder of the plugin `lightroom_plugin.lrdevplugin` -> Done
+ Execute the Plug-in: Library -> Plug-in Extras -> The Image Iterator


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
{"Highlights":[0,20,50],"Saturation":[10,0,30],"Contrast":[30,40,60]}
```
## Contributing

### How to start programming my own plug-in?
* Read the Lightroom Classic SDK guide. (You don't have to read each chapter. We would recommend to read the first two chapters of the SDK.
* Try to programm your own small "Hello World" plug-in using the SDK.

### Which files do I need?
* Info.lua : This file describes your plug-in e.g. the Lightroom Version, the title of your plug-in and more
* Main file or as we call it "the UI file": in our case this file is called "LibraryMenuItemPluginUI.lua"
It is called by the Info.lua file as the main script.
This is where the magic happens. This file implements the whole User Interface of our plug-in as well as a few functions. (Those are interacting with UI-objects for example the text-fields.)
### Which files do I need for contributing to TheImageIterator?
* In our case the most important file is the configuration file called "imageIteratorSettings.json". Because it's a JSON-file, it isn't possible to use JSON-code in a Lua script. The solution is called "json.lua". It's a external file. 

If you are not sure, here is the License for the "json.lua" file: (You can find it in the json.lua as well.)
>-- Copyright (c) 2020 rxi
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of
-- this software and associated documentation files (the "Software"), to deal in
-- the Software without restriction, including without limitation the rights to
-- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
-- of the Software, and to permit persons to whom the Software is furnished to do
-- so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--
### Debugging

## Acknowledgements
  
* interested in image editing
* programming skills would be an advantage

## License

Distributed under the [MIT](https://choosealicense.com/licenses/mit/) License.

## Sources
1. [JSON Library for Lua Accessed: May 20, 2021](https://github.com/rxi/json.lua/blob/master/json.lua)
2. [Sample pictures for testing the plug-in Accessed: May 22, 2021](https://pixabay.com/de/)
