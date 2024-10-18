# The Tiny Toes App

The Tiny Toes App is a Flutter application designed for users to manage and view albums associated with their accounts. The app features user authentication and provides a responsive interface for album management.

## Table of contents
- [The Tiny Toes App](#the-tiny-toes-app)
  - [Table of contents](#table-of-contents)
  - [Features](#features)
  - [Technologies Used](#technologies-used)
  - [Prerequisites](#prerequisites)
  - [Setup and Installation](#setup-and-installation)
  - [Running the Project](#running-the-project)
  - [Testing Login Credentials](#testing-login-credentials)

## Features

- User authentication with login and logout functionality.
- View and manage user-specific albums.
- Responsive design optimized for both mobile and tablet devices.

## Technologies Used

- **Flutter**: A UI toolkit for building natively compiled applications.
- **Dart**: The programming language used to write the app.
- **Provider**: A state management solution for Flutter.
- **Http**: For making network requests.
- **Shared Preferences**: To manage local storage of user sessions.

## Prerequisites

1. **Flutter SDK**: Ensure you have Flutter installed on your machine. You can download it from [Flutter's official website](https://flutter.dev/docs/get-started/install).
   - Version: `Flutter 3.19.6`
   
2. **Dart SDK**: Dart comes bundled with Flutter, but ensure you have the appropriate version as required by your project.
   - Version: `Dart 3.3.4`

3. **Java SDK**: Java is required for Android development when working with Flutter. Ensure you have the appropriate version installed. You can download it from [Oracle's official website](https://www.oracle.com/java/technologies/javase-downloads.html).
   - Version: `Java 17.0.11`


4. **Editor**: Use any code editor of your choice. Recommended editors are:
   - Visual Studio Code with Flutter and Dart plugins.
   - Android Studio with Flutter and Dart plugins.

5. **Emulator/Device**: Ensure you have an emulator running or a physical device connected to your computer.


## Setup and Installation

To set up and run this project, follow these steps:

1. **Clone the repository**:

   ```bash
   git clone https://github.com/yourusername/thetinytoes_app.git
   ```

2. **Navigate to the project directory**:

   ```bash
   cd thetinytoes/client/apps/thetinytoes_app/
   ```

3. **Install Flutter SDK**:

   Make sure you have Flutter installed on your machine. If not, follow the official installation guide here: Flutter Installation Guide

3. **Install dependencies**:

   ```bash
   flutter pub get
   ```

3. **Run the app**:

   ```bash
   flutter run
   ```

## Running the Project

- Ensure you have an emulator running or a physical device connected to your computer.
- You can also use the Flutter DevTools for debugging and performance analysis.

## Testing Login Credentials

For testing purposes, you can use the following credentials:

- **Username:** `user`
- **Password:** `user123`

These credentials will allow you to log into the app and access the features available to a typical user.
