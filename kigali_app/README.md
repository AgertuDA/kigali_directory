# 🏙️ Kigali City Services & Places Directory

A production-ready Flutter mobile application that allows Kigali residents to find essential services and lifestyle locations including hospitals, police stations, libraries, restaurants, cafes, parks, and tourist attractions.

---

## 📱 Features

- **Authentication** — Firebase Auth with email/password, email verification enforcement
- **Directory** — Real-time listings with search and category filtering  
- **Map View** — All listings as markers on Google Maps
- **My Listings** — CRUD operations restricted to listing owner
- **Detail View** — Embedded Google Maps + Navigate with Google Maps
- **Settings** — User profile, preferences toggles

---

## 🏗️ Architecture

This app follows **Clean Architecture** with strict separation of concerns:

```
lib/
├── models/           # Data models (UserModel, ListingModel)
├── services/         # Firebase access layer (AuthService, FirestoreService)
├── providers/        # State management (AuthProvider, ListingProvider)
├── screens/          # UI screens (never call Firebase directly)
│   ├── auth/         # Login, Signup, VerifyEmail
│   ├── home/         # HomeScreen with bottom nav
│   ├── directory/    # All listings with search/filter
│   ├── listing/      # Detail, Create/Edit forms
│   ├── my_listings/  # User's own listings
│   ├── map/          # Map view
│   └── settings/     # Settings & profile
├── widgets/          # Reusable UI components
└── utils/            # Theme constants
```

**Data flow:** `UI → Provider → Service → Firebase`

UI widgets **never** call Firebase directly. All state changes flow through Providers.

---

## 🔥 Firebase Setup

### 1. Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **Add project** → Name it (e.g., `kigali-services`)
3. Disable Google Analytics (optional) → **Create project**

### 2. Enable Firebase Authentication

1. In your project: **Build → Authentication → Get started**
2. Click **Email/Password** → Enable → **Save**

### 3. Enable Cloud Firestore

1. **Build → Firestore Database → Create database**
2. Choose **Start in test mode** (or use security rules below)
3. Select region: `europe-west1` (closest to Kigali)

### 4. Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Users can only read/write their own profile
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Anyone authenticated can read listings
    // Only the creator can update/delete their listing
    match /listings/{listingId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null 
        && request.auth.uid == resource.data.createdBy;
    }
  }
}
```

### 5. Register Android App

1. **Project Settings → Add app → Android**
2. Package name: `com.example.kigali_services`
3. Download `google-services.json`
4. Place it in: `android/app/google-services.json`

### 6. FlutterFire CLI Setup

```bash
# Install Firebase CLI
npm install -g firebase-tools
firebase login

# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure (in your project root)
flutterfire configure --project=YOUR_FIREBASE_PROJECT_ID
```

This auto-generates `lib/firebase_options.dart` with your real values.

---

## 🗺️ Google Maps Setup

### 1. Enable Maps SDK

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select or create a project (same as Firebase)
3. **APIs & Services → Library**
4. Search and enable: **Maps SDK for Android**

### 2. Create API Key

1. **APIs & Services → Credentials → Create Credentials → API key**
2. Copy the key

### 3. Add API Key to App

In `android/app/src/main/AndroidManifest.xml`, replace:
```xml
android:value="YOUR_GOOGLE_MAPS_API_KEY"
```
with your actual key.

### 4. Restrict the API Key (Recommended)

1. Edit the API key → **Application restrictions → Android apps**
2. Add package: `com.example.kigali_services`
3. Add the SHA-1 fingerprint from your keystore

---

## 📊 Firestore Database Structure

### Collection: `users`
```json
{
  "uid": "firebase-generated-uid",
  "email": "user@example.com",
  "createdAt": "Timestamp"
}
```

### Collection: `listings`
```json
{
  "name": "King Faisal Hospital",
  "category": "Hospital",
  "address": "KG 544 St, Kacyiru, Kigali",
  "contactNumber": "+250 788 306 000",
  "description": "The leading referral hospital in Rwanda with advanced medical facilities.",
  "latitude": -1.9443,
  "longitude": 30.0883,
  "createdBy": "firebase-user-uid",
  "timestamp": "Timestamp"
}
```

### Example Data to Seed

| Name | Category | Latitude | Longitude |
|------|----------|----------|-----------|
| King Faisal Hospital | Hospital | -1.9443 | 30.0883 |
| Kigali Central Police | Police Station | -1.9500 | 30.0588 |
| Kigali Public Library | Library | -1.9536 | 30.0606 |
| Repub Lounge | Restaurant | -1.9486 | 30.0616 |
| Question Coffee | Cafe | -1.9546 | 30.0622 |
| Nyamirambo Regional Park | Park | -1.9732 | 30.0317 |
| Kigali Genocide Memorial | Tourist Attraction | -1.9614 | 30.0560 |

---

## 🔄 State Management (Provider)

### AuthProvider
Manages the authentication lifecycle:

```
Firebase Auth Stream → AuthProvider._onAuthStateChanged()
                     → Updates: _firebaseUser, _userProfile, _status
                     → notifyListeners() → UI rebuilds
```

States: `idle | loading | success | emailUnverified | error`

**Email verification flow:**
1. User signs up → Firebase sends verification email
2. User is redirected to `VerifyEmailScreen`
3. User taps "I've Verified" → `checkEmailVerification()` reloads Firebase user
4. If verified: `AuthWrapper` detects `isAuthenticated == true` → navigates to `HomeScreen`

### ListingProvider
Manages real-time listing data:

```
Firestore Stream → ListingProvider._allListings (raw data)
                → filteredListings getter (search + filter applied)
                → notifyListeners() → Directory/Map screens rebuild
```

**Real-time update cycle:**
1. `HomeScreen.initState()` calls `startListeningToAllListings()`
2. Firestore snapshot stream fires on any data change
3. `_allListings` updates → `filteredListings` recomputes
4. `Consumer<ListingProvider>` widgets rebuild automatically

**CRUD ownership:**
- `updateListing` and `deleteListing` check `listing.createdBy == currentUserUid`
- Enforced at Provider level (not just UI)

---

## 🧭 Navigation Overview

```
AuthWrapper
├── LoginScreen → SignupScreen → VerifyEmailScreen
└── HomeScreen (BottomNavigation)
    ├── [0] DirectoryScreen → ListingDetailScreen
    │                       ↗ CreateEditListingScreen (create)
    ├── [1] MyListingsScreen → ListingDetailScreen
    │                        → CreateEditListingScreen (edit)
    ├── [2] MapViewScreen → ListingDetailScreen (via marker tap)
    └── [3] SettingsScreen
```

---

## 🚀 Running the App

```bash
# Install dependencies
flutter pub get

# Run on Android emulator/device
flutter run

# Build release APK
flutter build apk --release
```

### Prerequisites
- Flutter SDK ≥ 3.0.0
- Android SDK / Android Studio
- Firebase project configured (see setup above)
- Google Maps API key (see setup above)

---

## 📦 Key Dependencies

| Package | Purpose |
|---------|---------|
| `firebase_core` | Firebase initialization |
| `firebase_auth` | User authentication |
| `cloud_firestore` | Real-time database |
| `google_maps_flutter` | Map display and markers |
| `provider` | State management |
| `url_launcher` | Open Google Maps navigation & phone calls |
| `intl` | Date formatting |
| `geolocator` | Device location access |

---

## 🎨 Design

The app uses a Rwanda-inspired color palette:
- **Primary**: Rwanda Green (`#1A6B3C`)
- **Accent**: Warm Gold (`#F5A623`)
- Category-specific colors for icons and markers

---

## 📝 License

This project was created for a university assignment demonstrating Flutter + Firebase mobile development best practices.
