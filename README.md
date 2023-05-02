# V Notes

A Flutter note taking app that allows users to take notes and also record audio.

## Features:

* Splash
* App Icon
* local Storage
* Light and Dark Theme
* Riverpod (State Management)
* Audio recording and playback

### Up-Coming Features:

* Video recording

## Getting Started

A Flutter note taking app that allows users to take notes and also record audio. This is an offline app optimised for android devices but can work on IOS, MacOS, Windows and web platforms also.

## How to Use 

**Step 1:**

Download or clone this repo by using the link below:

```
https://github.com/zubairehman/flutter-boilerplate-project.git
```

**Step 2:**

Go to project root and execute the following command in console to get the required dependencies: 

```
flutter pub get 
```
For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### Libraries & Tools Used

* [sqflite](https://pub.dev/packages/sqflite)
* [http](https://pub.dev/packages/http)
* [audio_session](https://pub.dev/packages/audio_session)
* [flutter_screenutil](https://pub.dev/packages/flutter_screenutil)
* [flutter_riverpod](https://pub.dev/packages/flutter_riverpod)
* [path_provider](https://pub.dev/packages/path_provider)
* [permission_handler](https://pub.dev/packages/permission_handler)
* [shared_preferences](https://pub.dev/packages/shared_preferences)
* [intl](https://pub.dev/packages/intl)
* [flutter_sound_lite](https://pub.dev/packages/flutter_sound_lite)
* [json_theme](https://pub.dev/packages/json_theme)
* [flutter_native_splash](https://pub.dev/packages/flutter_native_splash)
* [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)

### Folder Structure
Here is the core folder structure which flutter provides.

```
flutter-app/
|- android
|- build
|- ios
|- lib
|- test
```

Here is the folder structure I used in this project

```
lib/
|- data/
|- ui/
|- constants.dart
|- main.dart
```