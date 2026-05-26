# Mahintana Flutter Project

This Flutter/Dart project recreates the provided HTML/CSS/JavaScript Mahintana authentication screens.

## Structure

```text
lib/
  main.dart
  screens/
    index_screen.dart
    login_screen.dart
    signup_screen.dart
  styles/
    app_styles.dart
    index_styles.dart
    login_styles.dart
    signup_styles.dart
  widgets/
    app_header.dart
    auth_background.dart
    auth_buttons.dart
    form_widgets.dart
assets/images/
  logo.png
  logo-google.png
  matutum.png
```

## Run

```bash
flutter pub get
flutter run -d chrome
```

If platform folders are missing, run this once:

```bash
flutter create .
flutter pub get
flutter run -d chrome
```
