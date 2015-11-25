# Visual Studio Team Services (VSTS) for iOS

Main development repository for iOS application for Visual Studio Team Services.

## Contributors ##

- Raul Guerra Gomez
- Jose Rodrigo Gonzales
- <a href='https://github.com/fidmor89'>Fidel Esteban Morales Cifuentes</a>.
- <a href='https://github.com/giobt'>Giorgio Andre Balconi Taracena</a>.
- <a href='https://github.com/chirislash'>Luis Roberto Rosales Enriquez</a>.
- <a href='https://github.com/chepix10'>Jose Luis Morales Ruiz</a>.
- <a href='https://github.com/manu1217'>Manuel Andres Santizo Avila</a>.
- <a href='https://github.com/oscargarciacolon'>Oscar Garcia Colon - Teacher and Facilitator</a>.  

Special Thanks to Guillermo Zepeda for all his help with this project.

## Description ##

iOS client app for VSTS. Connect to your Visual Studio Online account to view 
your Project Collections, see the current state of your Projects and
Teams and the status of Work Items.

#Installation

- Install cocoapods: https://guides.cocoapods.org/using/getting-started.html

- Create a pod file with the following contents in the project director:

This can be done by running $ touch Podfile.

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.3'
use_frameworks!

pod 'SwiftHTTP', '~> 0.9.4'
pod 'SwiftyJSON', '~> 2.2.1'
pod 'MBProgressHUD', '~> 0.9.1'
```
For more information about creating the Podfile: https://guides.cocoapods.org/using/using-cocoapods.html


- Open a terminal window, and $ cd into your project directory.
- To install the pod run:
```
pod install
```

## Tags ##

VSO, TFS, Visual Studio Online, Visual Studio Team Services