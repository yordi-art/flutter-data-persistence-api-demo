# Flutter Data Persistence API Demo

A beginner-friendly Flutter project demonstrating local data storage, file handling, REST API interaction, and JSON parsing. The app is designed for a simple university assignment with clean code and a modern, easy-to-follow interface.

## Features

- Save a user name locally using key-value storage.
- Write and retrieve a short note from a local text file.
- Fetch user data using an HTTP GET request.
- Parse JSON data and display user names with email addresses.

## Technologies Used

- Flutter
- Dart
- SharedPreferences
- Local file storage
- HTTP REST API requests
- JSON parsing

## Packages Used

- `shared_preferences` - save and load simple key-value data.
- `path_provider` - locate the app documents directory for file storage.
- `http` - perform network requests to retrieve API data.
- `cupertino_icons` - app icons and visual polish.

## How to Run the Project

1. Open the project folder in VS Code.
2. Run `flutter pub get` to install dependencies.
3. Launch the app with `flutter run`.

## Project Folder Structure

- `pubspec.yaml` - project metadata and dependencies.
- `lib/main.dart` - the main app screen, UI, and app logic.
- `lib/models/user.dart` - data model for parsed API users.
- `lib/services/storage_service.dart` - SharedPreferences and local file handling.
- `lib/services/api_service.dart` - HTTP GET request and JSON parsing.
- `lib/widgets/user_list.dart` - reusable widget for displaying fetched users.

## Short Explanation of Each Feature

- **Save name locally:** The app stores a typed name in `SharedPreferences`, demonstrating simple key-value storage.
- **Save note to file:** A note entered by the user is saved to a plain text file in the app documents directory.
- **Fetch users from API:** The app calls `https://jsonplaceholder.typicode.com/users` to retrieve a list of users.
- **Display parsed users:** The app converts JSON response data into Dart `User` objects and displays each user name and email.

## Summary

This project is intentionally simple and suitable for demonstration in a class presentation. It highlights common Flutter concepts like stateful UI, local storage, file I/O, networking, and JSON parsing in a beginner-friendly way.
