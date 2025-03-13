# Time Management Tool

English | [中文](README.md)

A Flutter-based time management application that helps users improve productivity and time management skills.

![App Screenshot](assets/time_management_image.png)

## Project Introduction

This is a time management tool designed based on the Pomodoro Technique, which helps users stay focused and improve work efficiency by properly arranging work and rest periods. The application interface is simple and intuitive, easy to operate, and suitable for all types of users.

## Features

- **Work/Rest Timer**: Provides default 25-minute work time and 5-minute rest time timing functions
- **Custom Duration**: Allows users to customize work and rest time lengths according to personal habits
- **Status Indication**: Clearly indicates current status (working/resting/paused) through different colors and text
- **Sound Alerts**: Plays sound effects when time ends to remind users to switch status
- **Pause/Resume**: Supports pausing and resuming timing function at any time
- **Beautiful Interface**: Adopts modern UI design, providing a comfortable visual experience

## Technology Stack

- **Development Framework**: Flutter
- **Programming Language**: Dart
- **State Management**: StatefulWidget
- **Audio Playback**: audioplayers plugin
- **Animation Effects**: AnimationController and Animation

## Project Structure

```
lib/
├── main.dart              # Application entry file
├── models/
│   └── timer_model.dart   # Timer model
└── pages/
    └── timer_page.dart    # Timer page UI
```

## Usage Instructions

1. **Start Working**: Click the "Start Work" button to enter work timing mode
2. **Start Resting**: Click the "Start Rest" button to enter rest timing mode
3. **Pause/Resume**: Pause or resume at any time during timing
4. **Stop Timing**: Click the "Stop" button to end the current timing
5. **Custom Settings**: Click the settings icon in the upper right corner to adjust work and rest time lengths

## Installation and Running

Ensure that the Flutter development environment is installed, then execute:

```bash
# Get dependencies
flutter pub get

# Run the application
flutter run
```

## Future Plans

- Add task management functionality
- Implement data statistics and visualization
- Support custom themes
- Add achievement system

## Contribution Guidelines

Welcome to submit Issues and Pull Requests to improve this project together!

## License

[MIT License](LICENSE)