# Roadmap App

A Flutter application for creating, following, and tracking roadmaps with milestones.

## Getting Started

This project is a Flutter application that uses Firebase for its backend services. To run this application, you need to configure Firebase.

### Firebase Setup

1.  **Create a Firebase Project:**
    *   Go to the [Firebase console](https://console.firebase.google.com/).
    *   Click "Add project" and follow the steps to create a new project.

2.  **Configure for Android:**
    *   In your Firebase project, go to Project Settings and add an Android app.
    *   Use `com.example.roadmap` as the Android package name.
    *   Download the `google-services.json` file.
    *   Place the `google-services.json` file in the `android/app/` directory.
    *   In `android/build.gradle.kts`, add the Google services plugin classpath:
        ```groovy
        dependencies {
            classpath("com.google.gms:google-services:4.4.2")
        }
        ```
    *   In `android/app/build.gradle.kts`, apply the Google services plugin:
        ```groovy
        plugins {
            id("com.google.gms.google-services")
        }
        ```

3.  **Configure for iOS:**
    *   In your Firebase project, add an iOS app.
    *   Use `com.example.roadmap` as the iOS bundle ID.
    *   Download the `GoogleService-Info.plist` file.
    *   Open `ios/Runner.xcworkspace` in Xcode.
    *   Drag the `GoogleService-Info.plist` file into the `Runner` directory in Xcode.
    *   To enable Google Sign-In, you need to add a URL scheme. In Xcode, go to the "Info" tab of your `Runner` target. Under "URL Types", add a new URL type and paste the `REVERSED_CLIENT_ID` from your `GoogleService-Info.plist` file into the "URL Schemes" field.

4.  **Enable Authentication Methods:**
    *   In the Firebase console, go to the "Authentication" section.
    *   Enable the "Email/Password" and "Google" sign-in methods.

5.  **Set up Firestore:**
    *   In the Firebase console, go to the "Firestore Database" section.
    *   Create a new database in test mode for now. You can secure it later with security rules.

### Run the App

Once you have configured Firebase, you can run the app:

```bash
flutter pub get
flutter run
```

### Cloud Functions for Notifications

This project includes Cloud Functions to send push notifications for roadmap progress and milestone deadlines. To use these, you need to deploy them to your Firebase project.

1.  **Set up Firebase CLI:**
    *   If you don't have it, install the Firebase CLI: `npm install -g firebase-tools`
    *   Log in to Firebase: `firebase login`

2.  **Deploy Functions:**
    *   Navigate to the `functions` directory: `cd functions`
    *   Install dependencies: `npm install`
    *   Deploy the functions: `firebase deploy --only functions`

3.  **FCM Token:**
    *   The app will automatically save the FCM token for each user in their corresponding document in the `users` collection in Firestore. The Cloud Functions use this token to send notifications.