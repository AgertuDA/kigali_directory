# Design Summary Document

## Kigali City Services Directory App

---

## 1. Firestore Database Structure

### Overview

The app uses Firebase Firestore (NoSQL cloud database) with two main collections:

```
/users/{uid}
  - email: string
  - displayName: string
  - createdAt: timestamp
  - notificationsEnabled: boolean

/listings/{documentId}
  - name: string
  - description: string
  - category: string
  - latitude: double
  - longitude: double
  - address: string
  - phone: string
  - ownerId: string
  - createdAt: timestamp
```

### Design Decisions

1. **Users Collection**: Stores user profile data separate from Firebase Auth for flexibility
2. **Listings Collection**: Contains all service listings with geolocation data for map features
3. **Denormalization**: Some data is duplicated for read efficiency (e.g., ownerId in listings)

---

## 2. Listing Data Model

### Listing Class Structure

```dart
class Listing {
  final String id;
  final String name;
  final String description;
  final String category;
  final double latitude;
  final double longitude;
  final String address;
  final String phone;
  final String ownerId;
  final DateTime createdAt;
}
```

### Categories Used

- Food & Dining
- Health & Medical
- Shopping
- Entertainment
- Hotels & Accommodation
- Transportation
- Banking
- Government Services
- Other

### Design Trade-off

- Chose string category over separate collection for simplicity
- Could be improved with a separate categories collection for scalability

---

## 3. State Management Implementation

### Architecture: Provider Pattern

The app uses Flutter's **Provider** package for state management:

#### AuthProvider

- Manages authentication state
- Handles user sessions
- Stores user profile
- Methods: signIn(), signUp(), signOut(), checkEmailVerification()

#### ListingProvider

- Manages service listings
- Handles CRUD operations
- Provides search/filter functionality
- Methods: loadListings(), addListing(), updateListing(), deleteListing()

### Why Provider?

- Simple to learn and implement
- Built into Flutter SDK
- Good performance for medium-sized apps
- Easy to test

### Alternative Considered

- **Bloc**: More powerful but steeper learning curve
- **Riverpod**: Modern alternative but requires more setup

---

## 4. UI/UX Design

### Color Scheme

- Primary: #2C5364 (Dark teal)
- Secondary: #203A43 (Dark blue-grey)
- Surface: #0F2027 (Dark gradient start)
- Accent: Teal gradients for headers

### Screen Flow

```
Splash → Login → Signup → Verify Email → Home (Directory)
                                        ↓
                              Bottom Navigation:
                              - Directory (default)
                              - Map View
                              - My Listings
                              - Settings
```

### Key UI Components

1. **Gradient backgrounds** - Consistent dark-to-light gradient
2. **Card-based layouts** - White cards with shadows for content
3. **Bottom navigation** - 4 tabs for main navigation
4. **Search bar** - Filter listings by name
5. **Category chips** - Quick category filtering

---

## 5. Technical Challenges & Solutions

### Challenge 1: Email Verification Flow

- **Problem**: Users sign up but need to verify email before using the app
- **Solution**: Created verification screen with 3-second polling
- **Code**:

```dart
_timer = Timer.periodic(const Duration(seconds: 3), (_) async {
  await context.read<AuthProvider>().checkEmailVerification();
});
```

### Challenge 2: User Profile Not Loading

- **Problem**: Display name showed "User" instead of actual name
- **Root Cause**: Profile only loaded for authenticated users, not emailNotVerified
- **Solution**: Load profile for both auth states

### Challenge 3: Memory Leaks

- **Problem**: Auth listeners not removed on dispose
- **Solution**: Properly clean up listeners in dispose() method

### Challenge 4: Map Integration

- **Problem**: Need Google Maps API key
- **Solution**: Configured in Firebase Console and AndroidManifest

---

## 6. Security Considerations

### Firestore Security Rules

- Users can read all listings
- Only authenticated users can create listings
- Users can only edit/delete their own listings
- User profile only accessible by owner

### Client-side Validation

- Email format validation
- Password minimum length (6 characters)
- Required field validation
- Input sanitization

---

## 7. Performance Optimizations

1. **Lazy Loading**: Listings loaded on demand
2. **Caching**: User profile cached in memory
3. **Efficient Queries**: Firestore indexes for search
4. **Image Handling**: Placeholder images to reduce load time

---

## 8. Future Improvements

1. **Real-time Updates**: Use Firestore snapshots for live data
2. **Image Upload**: Add image upload for listings
3. **Push Notifications**: Firebase Cloud Messaging
4. **Analytics**: Firebase Analytics integration
5. **Social Login**: Google Sign-In option

---

## 9. Conclusion

The app follows clean architecture principles with:

- Clear separation of concerns (UI / Business Logic / Data)
- Scalable Firestore structure
- Simple but effective state management
- Consistent UI design

The design prioritizes user experience while maintaining code maintainability and scalability.
