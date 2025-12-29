# GitHub Pull Request Viewer

A Flutter application that displays open pull requests from GitHub repositories using the GitHub REST API, featuring simulated authentication with secure token storage.

> **Repository**: [Arjun6112/mset_assignment](https://github.com/Arjun6112/mset_assignment)
> 
> **Test Branch**: This PR demonstrates the app's ability to fetch and display pull requests from this repository!

## 📱 Features

### Core Features

- ✅ Fetch and display open pull requests from GitHub
- ✅ Display PR details: title, description, author, created date
- ✅ Simulated login with secure token storage using SharedPreferences
- ✅ Clean architecture with Provider state management
- ✅ Proper error handling and loading states

### Bonus Features Implemented

- ✅ **Pull to Refresh** - Swipe down to reload pull requests
- ✅ **Retry on Failure** - Dedicated retry button on error states
- ✅ **Responsive Layout** - Works on all screen sizes
- ✅ **Dark Mode** - Full theme support with toggle button
- ✅ **Shimmer Loading** - Smooth loading animations
- ✅ **Unit & Widget Tests** - Test coverage for models and services
- ✅ **Animations** - Smooth transitions and fade-in effects
- ✅ **Empty State Handling** - User-friendly messages when no PRs exist

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point with Provider setup
├── models/
│   └── pull_request.dart        # PR model with JSON serialization
├── services/
│   ├── auth_service.dart        # Authentication & token management
│   └── github_api_service.dart  # GitHub API integration
├── providers/
│   ├── auth_provider.dart       # Authentication state management
│   ├── pull_request_provider.dart # PR data state management
│   └── theme_provider.dart      # Theme state management
├── screens/
│   ├── login_screen.dart        # Login UI with animations
│   └── pull_request_list_screen.dart # PR list with refresh
└── widgets/
    ├── pull_request_card.dart   # PR card component
    └── pull_request_shimmer.dart # Shimmer loading effect

test/
├── models/
│   └── pull_request_test.dart   # Model unit tests
├── services/
│   └── auth_service_test.dart   # Service unit tests
└── widget_test.dart             # Widget tests
```

## 🚀 Setup Instructions

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Dart SDK (3.8.1 or higher)
- iOS Simulator / Android Emulator / Physical Device

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd mset_assignment
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**

   ```bash
   flutter run
   ```

4. **Run tests**
   ```bash
   flutter test
   ```

## 🔐 Token Handling

### How It Works

This app demonstrates secure token storage for authentication:

1. **Login Flow**:

   - User enters any username and password (demo credentials)
   - On successful "login", a simulated token (`abc123`) is generated
   - Token is stored using `shared_preferences` package

2. **Token Storage**:

   - Uses `SharedPreferences` for persistent storage
   - Token persists across app restarts
   - Simulates real-world secure token management

3. **Token Usage**:

   - Token is retrieved on app start to check authentication status
   - Display token button in app bar shows the stored token
   - Logout clears the stored token

4. **Implementation Details**:

   ```dart
   // Store token
   final prefs = await SharedPreferences.getInstance();
   await prefs.setString('github_token', 'abc123');

   // Retrieve token
   final token = prefs.getString('github_token');

   // Clear token
   await prefs.remove('github_token');
   ```

### Security Notes

- In production, use `flutter_secure_storage` for sensitive tokens
- Never commit tokens or API keys to version control
- For real GitHub auth, implement OAuth 2.0 flow
- Current implementation is for demonstration purposes only

## 📦 Dependencies

```yaml
dependencies:
  flutter: sdk
  http: ^1.2.0 # HTTP client for API calls
  provider: ^6.1.1 # State management
  shared_preferences: ^2.2.2 # Token storage
  intl: ^0.19.0 # Date formatting
  shimmer: ^3.0.0 # Loading animations
  cupertino_icons: ^1.0.8 # iOS icons
```

## 🎯 API Configuration

Currently configured to fetch PRs from `flutter/flutter` repository. To change:

1. Open `lib/services/github_api_service.dart`
2. Modify the constants:
   ```dart
   static const String owner = 'your-username';
   static const String repo = 'your-repo';
   ```

## 🌟 Bonus Features Details

### 1. Pull to Refresh

- Swipe down on PR list to reload data
- Shows loading indicator during refresh
- Updates list with latest PRs

### 2. Retry on Failure

- Network errors show friendly error message
- Dedicated retry button to attempt reload
- Preserves user experience on failure

### 3. Dark Mode

- System theme detection
- Manual toggle via sun/moon icon
- Smooth transition animations
- Preference persists across sessions

### 4. Shimmer Loading

- Skeleton screens during initial load
- Mimics actual content layout
- Adapts to light/dark theme

### 5. Animations

- Fade-in transitions on login screen
- Staggered list item animations
- Theme toggle rotation animation
- Smooth card press feedback

## 📹 Demo Video

[Add your demo video link here]

Options:

- Upload MP4 directly to repository
- Link to Loom recording
- Link to YouTube video

## 🐞 Known Issues & Limitations

1. **GitHub API Rate Limiting**

   - Unauthenticated requests limited to 60/hour
   - App shows appropriate error message when limit reached
   - Future: Implement real GitHub OAuth for higher limits

2. **Repository Configuration**

   - Currently hardcoded to flutter/flutter repo
   - Future: Add settings screen to change repository

3. **Network Error Handling**

   - Basic error messages shown
   - Future: More granular error categorization

4. **Testing Coverage**
   - Core models and services tested
   - Future: Increase widget test coverage
   - Future: Add integration tests

## 🧪 Testing

### Run All Tests

```bash
flutter test
```

### Run Specific Test File

```bash
flutter test test/models/pull_request_test.dart
```

### Test Coverage

- ✅ Model serialization/deserialization
- ✅ Authentication service logic
- ✅ Login screen validation
- ✅ Widget rendering

## 🎨 Design Decisions

1. **State Management**: Provider chosen for simplicity and official support
2. **Architecture**: Clean separation of concerns (models, services, providers, screens)
3. **UI/UX**: Material Design 3 with emphasis on smooth animations
4. **Error Handling**: User-friendly messages with actionable retry buttons
5. **Performance**: Efficient list rendering with ListView.builder

## 🔮 Future Enhancements

- [ ] Real GitHub OAuth integration
- [ ] PR detail screen with comments
- [ ] Search and filter functionality
- [ ] Multiple repository support
- [ ] Offline caching
- [ ] Accessibility improvements (TalkBack/VoiceOver)
- [ ] CI/CD pipeline setup

## 👨‍💻 Development

Built with ❤️ using Flutter

### Development Timeline

- Setup & Architecture: 1 hour
- Core Features: 2 hours
- Bonus Features: 2 hours
- Testing & Documentation: 1 hour

Total: ~6 hours

---

**Note**: This is a demonstration project for Flutter development assessment.
