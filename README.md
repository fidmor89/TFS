# TFS
TFS for iOS

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
