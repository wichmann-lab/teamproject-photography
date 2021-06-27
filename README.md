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

Add:

* is used to edit image data sets
* language: Lua
* works with Adobe Lightroom Classic

## Features

(Of our plug-in)

* import and export pictures
* save pictures in folder
* change settings (contrast, saturation, highlights)


## Getting Started

### 🛠 Set up
+ Make a new directory under the standard home directory called "TheImageIterator".

  Home directory..

     + for Windows: C/Users/username/
  
     + for Mac OS: /Users/username/
  
+ Make sure to save the configuration file "configurationFile.json" under this folder. 
+ Then execute the plugin.  

Add:
* Error message if config file is missing

This is an example gif.

![testgif](https://user-images.githubusercontent.com/69016207/120100932-aa5b1e80-c143-11eb-814e-9273eefd4652.gif)

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

### Debugging

## Acknowledgements

## License

Distributed under the [MIT](https://choosealicense.com/licenses/mit/) License.

## Sources
1. [JSON Library for Lua Accessed: May 20, 2021](https://github.com/rxi/json.lua/blob/master/json.lua)
2. [Sample pictures for testing the plug-in Accessed: May 22, 2021](https://pixabay.com/de/)
