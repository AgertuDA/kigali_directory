# Kigali City Services & Places Directory

A Flutter mobile application that helps residents and visitors in Kigali locate and navigate to important public services and places — including hospitals, police stations, libraries, restaurants, cafés, parks, tourist attractions, pharmacies, schools, and banks.

The app integrates Firebase Authentication, Cloud Firestore, OpenStreetMap, and Provider state management to provide a real-time directory of services across the city.

---

## Repository

**GitHub:** https://github.com/Betelhemf567/kigali-city-services-directory

> The Flutter project is located inside the `kigali_app` folder.

---

## App Features

### Firebase Authentication
- Email/password registration and login
- Email verification required before accessing the app
- Secure logout
- User profiles stored in Firestore

### Cloud Firestore (CRUD)
- Create, read, update, and delete listings in real time
- Only listing creators can edit or delete their own listings

### Search & Filtering
- Search listings by name
- Filter by category
- Results update instantly

### Map View
- All listings displayed as markers on an OpenStreetMap
- No API key or billing required

### Listing Detail
- Full listing info with embedded map marker
- One-tap navigation via Google Maps app
- Uses stored latitude and longitude

### State Management (Provider)
- `ChangeNotifier`-based providers for auth and listings
- Clean separation: UI → Provider → Service → Firebase
- No direct Firebase calls from UI widgets

### Bottom Navigation
- **Directory** — browse all listings
- **Map View** — map showing all listings
- **My Listings** — listings created by the current user
- **Settings** — user profile and preferences

---

## Project Structure

```
lib/
├── main.dart
├── firebase_options.dart
├── models/
│   ├── listing_model.dart
│   └── user_model.dart
├── services/
│   ├── auth_service.dart
│   └── firestore_service.dart
├── providers/
│   ├── auth_provider.dart
│   └── listing_provider.dart
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   ├── signup_screen.dart
│   │   └── verify_email_screen.dart
│   ├── home/
│   │   └── home_screen.dart
│   ├── directory/
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
└── utils/
    └── app_theme.dart
```

---

## Firestore Database Structure

### Users Collection
```
/users/{uid}
  email: string
  displayName: string
  createdAt: timestamp
  notificationsEnabled: boolean
```

### Listings Collection
```
/listings/{listingId}
  name: string
  category: string
  address: string
  contactNumber: string
  description: string
  latitude: number
  longitude: number
  createdBy: string
  timestamp: timestamp
```

### Supported Categories
Hospital, Police Station, Library, Restaurant, Café, Park, Tourist Attraction, Pharmacy, School, Bank

---

## Setup Instructions

### Prerequisites
- Flutter SDK 3.0 or higher
- Android Studio
- Android Emulator or physical Android device
- Firebase project

### 1. Clone the Repository
```bash
git clone https://github.com/Betelhemf567/kigali-city-services-directory.git
cd kigali-city-services-directory/kigali_app
```

### 2. Configure Firebase
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```
This generates `lib/firebase_options.dart`.

### 3. Enable Firebase Services
In the Firebase Console:
- Authentication → Email/Password → Enable
- Firestore Database → Create in test mode (region: `europe-west1`)

### 4. Create Firestore Composite Index
In Firestore → Indexes, create:

| Collection | Field | Order |
|---|---|---|
| listings | createdBy | Ascending |
| listings | timestamp | Descending |

### 5. Register SHA-1 Fingerprint
```bash
cd android
./gradlew signingReport
```
Copy the SHA-1 and add it in Firebase Console → Project Settings → Your Apps → Android → Add Fingerprint.

### 6. Install Dependencies and Run
```bash
flutter pub get
flutter run
```

---

## Map Integration

This app uses **OpenStreetMap** via the `flutter_map` package — free to use with no API key or billing required.

The "Navigate" button on listing detail screens opens the device's Google Maps app for turn-by-turn directions.

---

## Security Notes

- `google-services.json` and `firebase_options.dart` are excluded via `.gitignore`
- Firestore rules ensure only authenticated users can create listings
- Only the creator of a listing can edit or delete it
- Email verification is required before accessing the directory

---

## Important Notes

- Runs on Android emulator or Android device only
- Web browsers are not supported
- Minimum SDK: Android 6.0 (API 23)
