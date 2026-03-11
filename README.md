# Kigali City Services & Places Directory

A Flutter mobile application that helps Kigali residents locate and navigate to essential public services and lifestyle locations such as hospitals, police stations, libraries, restaurants, cafés, parks, and tourist attractions.

This project integrates **Firebase Authentication** and **Cloud Firestore** with **Provider state management** to deliver a real-time, scalable, and user-friendly directory app.

---

##  Features

- **Authentication**
  - Sign up, login, logout with Firebase Authentication
  - Email verification enforced before access
  - User profiles stored in Firestore (`users` collection)

- **Location Listings (CRUD)**
  - Create, read, update, delete listings in Firestore
  - Each listing includes:
    - Name, category, address, contact number, description
    - Latitude & longitude coordinates
    - CreatedBy (User UID) and timestamp
  - Real-time updates reflected in UI via Provider

- **Search & Filtering**
  - Search listings by name
  - Filter listings dynamically by category

- **Detail Page & Map Integration**
  - Embedded Google Map with marker for selected location
  - Navigation button launches Google Maps directions

- **State Management**
  - Implemented using **Provider**
  - Firestore operations handled in service layer
  - UI updates automatically via `notifyListeners()`

- **Navigation**
  - BottomNavigationBar with:
    - Directory (Browse Listings)
    - My Listings
    - Map View
    - Settings

- **Settings**
  - Displays authenticated user profile
  - Toggle for enabling/disabling notifications (simulated locally)

---

## 🗂 Firestore Database Structure

### Collections

- **users**
  ```json
  {
    "uid": "string",
    "email": "string",
    "displayName": "string",
    "createdAt": "timestamp",
    "notificationsEnabled": true/false
  }


- **listings**
  ```json
  {
  "id": "string",
  "name": "string",
  "category": "Hospital | Police Station | Library | Restaurant | Café | Park | Tourist Attraction",
  "address": "string",
  "contactNumber": "string",
  "description": "string",
  "latitude": "double",
  "longitude": "double",
  "createdBy": "user UID",
  "timestamp": "timestamp"
  }

---

# Tech Stack

### Frontend: Flutter (Material Design)

### Backend: Firebase Authentication, Cloud Firestore

### State Management: Provider

### Maps: Google Maps Flutter plugin

---


# Project Structure

```
lib/
├── main.dart
├── home_screen.dart
├── firebase_options.dart
├── models/
│   ├── listing_model.dart
│   └── user_model.dart
├── services/
│   ├── auth_service.dart
│   └── listing_service.dart
├── providers/
│   ├── auth_provider.dart
│   └── listing_provider.dart
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   ├── signup_screen.dart
│   │   └── verify_email_screen.dart
│   ├── detail/
│   │   └── detail_screen.dart
│   ├── directory/
│   │   ├── add_listing_screen.dart
│   │   └── directory_screen.dart
│   ├── listing/
│   │   ├── listing_detail_screen.dart
│   │   └── create_edit_listing_screen.dart
│   ├── map/
│   │   └── map_view_screen.dart
│   ├── my_listings/
│   │   └── my_listings_screen.dart
│   └── settings/
│       └── settings_screen.dart
└── theme.dart
```

---

## Setup Instructions

### 1, Clone the repository

```
git clone https://github.com/AgertuDA/kigali_directory.git

cd kigali-directory
```

### 2, Install dependencies:

```
flutter pub get
```

### 3, Configure Firebase:
```
Add your google-services.json (Android) and GoogleService-Info.plist (iOS).

Enable Firebase Authentication (Email/Password)

Create Firestore collections: users, listings
```

### 4, Run the app

```
flutter run
```
