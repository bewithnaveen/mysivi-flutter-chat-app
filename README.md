# MySivi Chat App

A professional Flutter chat application with Clean Architecture, GetX state management, and modern UI. Built for MySivi AI Flutter Developer Assignment.

## 📱 Features

- Real-time messaging with API-generated responses
- User management with add/edit functionality
- Chat history with timestamps
- Word dictionary - Long press any word to get meaning
- Local data persistence with SharedPreferences
- Scroll position preservation between tabs
- Blue gradient UI design
- Smooth animations and transitions

## 🏗️ Tech Stack

**Framework & Language**
- Flutter 3.3.4+
- Dart 3.0+

**State Management & Architecture**
- GetX 4.6.6 (State Management & Navigation)
- Clean Architecture (MVVM Pattern)
- GetIt 7.6.7 (Dependency Injection)

**Core Libraries**
- HTTP 1.2.0 (API calls)
- SharedPreferences 2.2.2 (Local storage)
- Dartz 0.10.1 (Functional programming)
- Google Fonts 6.1.0 (Rubik font)
- Lucide Icons 0.257.0
- Intl 0.19.0 (Date formatting)
- UUID 4.3.3 (ID generation)
- Equatable 2.0.5 (Value equality)

## 📂 Architecture
```
lib/
├── core/
│   ├── di/              # Dependency Injection
│   ├── theme/           # App Theme & Colors
│   └── error/           # Error Handling
├── data/
│   ├── datasources/     # Local & Remote Data Sources
│   ├── models/          # Data Models
│   └── repositories/    # Repository Implementations
├── domain/
│   ├── entities/        # Business Entities
│   ├── repositories/    # Repository Interfaces
│   └── usecases/        # Business Logic
└── presentation/
    ├── controllers/     # GetX Controllers
    ├── screens/         # UI Screens
    └── widgets/         # Reusable Widgets
```

## 🚀 Getting Started

### Prerequisites
```
Flutter SDK: >=3.3.4
Dart SDK: 3.0+
```

### Installation

1. Clone the repository
```bash
git clone https://github.com/YOUR_USERNAME/mysivi.git
cd mysivi
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

4. Build APK
```bash
flutter build apk --release
```

## 🌐 APIs Used

- **DummyJSON API** - Random comments for receiver messages
- **JSONPlaceholder API** - Random comments for receiver messages
- **Quotable API** - Random quotes for receiver messages
- **Dictionary API** - Word definitions for dictionary feature

## ✅ Assignment Requirements

**All requirements completed: 100%**

✅ Three tabs (Home, Offers, Settings)  
✅ Custom tab switcher (Users List / Chat History)  
✅ Tab switcher scrolls away and reappears  
✅ Scroll position preserved  
✅ Floating Action Button to add users  
✅ Add user with snackbar confirmation  
✅ Chat screen with sender/receiver messages  
✅ Sender messages (right side, user-written)  
✅ Receiver messages (left side, API-fetched)  
✅ Avatar initials + bubble design  
✅ API integration for receiver messages  
✅ **BONUS**: Word meaning bottomsheet  

## 🎨 Design Highlights

- Blue gradient theme (#4E7FFF → #3D6FEE)
- Circular gradient avatars
- Rounded tab switcher with smooth animation
- Material Design 3 components
- Rubik font family
- Professional color scheme
- Smooth page transitions

## 🔧 Key Implementation Details

### State Management
- GetX Controllers for reactive state
- Obx widgets for automatic UI updates
- GetX navigation and snackbars

### Data Flow
```
User Action → Controller → UseCase → Repository → DataSource → API/Storage
```

### Error Handling
- Dartz Either<Failure, Success> pattern
- Custom failure types
- User-friendly error messages
- Retry functionality

### Storage Strategy
- Users stored in SharedPreferences
- Messages stored per chat ID
- Chat history auto-updated
- Data persists across app restarts

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS

## 👨‍💻 Developer

**Naveen**  
Frontend & Mobile Developer  
Hyderabad, India  
4+ years experience in Flutter & Angular

## 📄 License

Developed for MySivi AI Flutter Developer Assignment.

---

**Built with ❤️ using Flutter**
