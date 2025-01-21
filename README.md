# Ahoj!

A text-to-speech iOS application built with Flutter that provides an accessible way to communicate through speech output.

## Current Features

- Text-to-speech functionality with high-quality voice output
- Integration with the native iOS keyboard for word and sentence prediction
- Save and manage frequently used phrases
  - Quick access to saved phrases
  - Swipe-to-delete functionality
  - Delete button for each phrase
- Clear text button for easy input management
- iMessage integration for sharing text
- Language selection support (🔧 in progress)

## Planned Features

### Voice Personalization (🔧 in progress)
- Custom voice recording feature to allow users to use their own voice
  - Initial implementation will focus on creating a personalized voice model of myself for my brother to use
  - Future expansion to allow any user to record and use their own voice
  - This will enable more personal and meaningful communication, especially valuable for users who want to maintain their identity through their voice

## Technical Details

Built with:
- Flutter 3.27.1
- Dart 3.6.0
- iOS-native Cupertino widgets
- SharedPreferences for local storage
- flutter_tts for text-to-speech capabilities
- url_launcher for iMessage integration

## Getting Started

Since I don't have an apple dev subscription, this app can only be ran from your IDE. 

To run this project:

1. Ensure you have Flutter 3.27.0 or higher installed
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Open the iOS simulator or connect an iOS device
5. Run `flutter run` to start the app
