# Flutter Snake Game

This project demonstrates how to set up FlutterFire with Firebase for a simple Flutter application.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installing Firebase CLI](#installing-firebase-cli)
- [Creating a New Firebase Project](#creating-a-new-firebase-project)
- [Adding SHA Keys to Firebase](#adding-sha-keys-to-firebase)
- [Configuring FlutterFire](#configuring-flutterfire)
- [Updating main.dart](#updating-maindart)
- [Creating a Firestore Database](#creating-a-firestore-database)

## Prerequisites

- Flutter SDK installed on your machine
- Dart SDK installed
- An IDE (like Visual Studio Code or Android Studio)

## Installing Firebase CLI

### Windows

1. Install Node.js from [nodejs.org](https://nodejs.org/).
2. Open a command prompt and run:

   ```bash
   npm install -g firebase-tools
   ```

### Ubuntu

1. Install Node.js:

   ```bash
   sudo apt update
   sudo apt install nodejs npm
   ```

2. Install Firebase CLI:

   ```bash
   sudo npm install -g firebase-tools
   ```

### macOS

1. Install Homebrew if you haven't already. Open a terminal and run:

   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. Install Node.js:

   ```bash
   brew install node
   ```

3. Install Firebase CLI:

   ```bash
   npm install -g firebase-tools
   ```

## Creating a New Firebase Project

1. Open your terminal or command prompt.
2. Log in to Firebase:

   ```bash
   firebase login
   ```

3. Create a new Firebase project:

   ```bash
   firebase projects:create your-project-name
   ```

   Replace `your-project-name` with a unique name for your Firebase project.

## Adding SHA Keys to Firebase

1. Go to the Firebase Console and open your project.
2. In the left sidebar, click on **Project settings** (the gear icon).
3. Under the **Your apps** section, find your Android app.
4. Click on **Add fingerprint** under the SHA certificate fingerprints section.
5. Enter the following SHA keys:

   - SHA1: `C4:91:30:E2:67:C0:A9:7A:AB:F6:E8:64:36:AE:46:21:E2:CD:1D:15`
   - SHA256: `0F:77:85:BA:8D:87:3B:25:7F:76:1F:8D:E9:89:66:01:AA:61:27:F6:58:33:19:C1:C8:56:33:7F:AD:FE:35:F1`

6. Click on **Save** to apply the changes.

## Configuring FlutterFire

1. In your terminal, navigate to your Flutter project directory.
2. Run the following command to configure FlutterFire:

   ```bash
   flutterfire configure
   ```

3. Follow the on-screen instructions to select your Firebase project and set up the configuration for your app.

## Updating main.dart

1. Open the `lib/main.dart` file in your Flutter project.
2. Ensure your `main.dart` file includes the following code:

   ```dart
   import 'package:flutter/material.dart';
   import 'package:firebase_core/firebase_core.dart';
   import 'firebase_options.dart'; // Import the generated file for Firebase options

   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
     runApp(MyApp());
   }

   ```

## Creating a Firestore Database

1. Go to the Firebase Console and open your project.
2. In the left sidebar, click on **Firestore Database**.
3. Click on **Create database**.
4. Choose **Start in test mode** (recommended for development) or **Start in production mode** and click **Next**.
5. Select a location for your Firestore database and click **Done**.
6. In the Firestore database, click on **Start collection**.
7. Enter `high_scores` as the collection name and click **Next**.
8. Add the following fields for the documents:

   - **Field name:** `name`
     - **Type:** String
     - **Value:** (Enter a sample name, e.g., `"Player1"`)
   - Click **Add field**.
   - **Field name:** `score`
     - **Type:** Number
     - **Value:** (Enter a sample score, e.g., `100`)
   - Click **Add field**.
   - **Field name:** `timestamp`
     - **Type:** Timestamp
     - **Value:** (Use the current time or a sample timestamp)

9. Click **Save** to create the collection and the first document.

## Conclusion

You have now set up Firebase, FlutterFire, and a Firestore database for your Flutter project. You're ready to start building your application!
