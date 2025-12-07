# 🎯 Flutter_HackMates

<div align="center">

![Flutter_HackMatess Banner](https://img.shields.io/badge/Flutter_HackMates-Campus%20Skill%20Hub-blue?style=for-the-badge&logo=flutter&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=flat-square&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat-square&logo=firebase&logoColor=black)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=flat-square)

**Campus Skill & Hackathon Hub** 🚀

*Connect. Compete. Code.* — Your ultimate platform for hackathons and skill development

[📱 Download APK](#) • [🌐 Live Demo](#) • [📖 Documentation](#)

</div>

---

## ✨ Features

<div align="center">

### 🎯 Core Features
| Feature | Description |
|---------|-------------|
| 🔍 **Hackathon Discovery** | Browse upcoming hackathons, filter by skills, and register instantly |
| 👥 **Team Formation** | Create team requests, find collaborators, and build dream teams |
| 💻 **Skill Practice** | Interactive coding challenges with progress tracking |
| 👤 **Smart Profiles** | Showcase skills, achievements, and connect with developers |
| 🔔 **Real-time Updates** | Live notifications for hackathons, teams, and competitions |

### 🎨 Design & UX
- **Material 3 Design** - Modern, beautiful, and accessible UI
- **Dark/Light Themes** - Seamless theme switching with Teal & Deep Purple colors
- **Responsive Layout** - Optimized for mobile, tablet, and web
- **Smooth Animations** - Fluid transitions and micro-interactions

### 🔧 Technical Excellence
- **Offline Support** - Works without internet connection
- **Real-time Sync** - Firebase-powered live data synchronization
- **Secure Auth** - Firebase Authentication with multiple providers
- **Performance** - Optimized for speed and battery efficiency

</div>

---

## 🚀 Quick Start

### Prerequisites
- 📱 **Flutter SDK** (3.0.0 or higher)
- 🔥 **Firebase Project** (with Firestore & Auth enabled)
- 💻 **IDE** (VS Code, Android Studio, or IntelliJ)

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/Pusparaj99op/Flutter_HackMates.git
cd Flutter_HackMates

# 2. Install dependencies
flutter pub get

# 3. Configure Firebase (Optional for demo)
# Add google-services.json for Android
# Add GoogleService-Info.plist for iOS

# 4. Run the app
flutter run # I"m running on the Chrome so Use, flutter run -d web-server
```

### Platform Support

| Platform | Status | Command |
|----------|--------|---------|
| 📱 **Android** | ✅ Ready | `flutter run -d android` |
| 🍎 **iOS** | ✅ Ready | `flutter run -d ios` |
| 🌐 **Web** | ✅ Ready | `flutter run -d chrome` |
| 🖥️ **Desktop** | ✅ Ready | `flutter run -d linux` |

---

## 🏗️ Architecture

```
lib/
├── 📱 app.dart                 # Main app widget & routing
├── 🚀 main.dart               # App entry point
├── 🎨 core/                   # Core utilities
│   ├── theme.dart            # Material 3 theme
│   ├── constants.dart        # App constants
│   └── utils.dart            # Helper functions
├── ⚡ features/               # Feature modules
│   ├── 🔐 auth/             # Authentication
│   ├── 🏠 home/             # Dashboard
│   ├── 🏆 hackathons/       # Hackathon discovery
│   ├── 💻 practice/         # Coding challenges
│   ├── 👤 profile/          # User profiles
│   ├── 👥 team/             # Team formation
│   └── 🔧 shared/           # Shared components
└── 🔥 services/              # Firebase services
    └── firebase_service.dart
```

### Tech Stack

<div align="center">

| Category | Technology |
|----------|------------|
| **Frontend** | ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white) |
| **Backend** | ![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat&logo=firebase&logoColor=black) |
| **State Management** | ![Provider](https://img.shields.io/badge/Provider-000000?style=flat&logo=data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTEyIDJDMTMuMSAyIDE0IDIuOSAxNCA0VjE2QzE0IDE3LjEgMTMuMSAxOCA5LjUgMTJDOS41IDE4IDguOSAxNy4xIDggMTZWNFoiIGZpbGw9IiMwMDAiLz4KPC9zdmc+) |
| **Navigation** | ![Go Router](https://img.shields.io/badge/Go_Router-00ADD8?style=flat&logo=data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTEyIDJDMTMuMSAyIDE0IDIuOSAxNCA0VjE2QzE0IDE3LjEgMTMuMSAxOCA5LjUgMTJDOS41IDE4IDguOSAxNy4xIDggMTZWNFoiIGZpbGw9IiMwMEFERDgiLz4KPC9zdmc+) |
| **Database** | ![Firestore](https://img.shields.io/badge/Firestore-FFCA28?style=flat&logo=firebase&logoColor=black) |

</div>

---

## 📱 Screenshots

<div align="center">

| Home Screen | Hackathons | Team Formation |
|-------------|------------|----------------|
| ![Home](assets/screenshots/home.png) | ![Hackathons](assets/screenshots/hackathons.png) | ![Teams](assets/screenshots/teams.png) |

*More screenshots coming soon! 📸*

</div>

---

## 🤝 Contributing

We love contributions! Here's how you can help:

### Development Setup
```bash
# Fork and clone
git clone https://github.com/Pusparaj99op/Flutter_HackMates.git
cd Flutter_HackMates

# Create feature branch
git checkout -b feature/amazing-feature

# Make changes and test
flutter test
flutter run -d chrome

# Commit and push
git add .
git commit -m "Add amazing feature"
git push origin feature/amazing-feature
```

### Guidelines
- 📝 Follow [Flutter Style Guide](https://flutter.dev/docs/development/tools/formatting)
- 🧪 Write tests for new features
- 📖 Update documentation
- 🔄 Keep PRs focused and atomic

### Contributors
<a href="https://github.com/Pusparaj99op/Flutter_HackMates/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=Pusparaj99op/Flutter_HackMates" />
</a>

---

## 📄 License

<div align="center">

**Flutter_HackMates** is licensed under the MIT License.

[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)

*Made with ❤️ for the developer community*

</div>

---

## 📞 Support & Community

<div align="center">

### Get Help
- 📧 **Email**: Closed!!
- 💬 **Discord**: closed!!
- 🐛 **Issues**: [Report bugs](https://github.com/Pusparaj99op/Flutter_HackMates/issues)
- 💡 **Discussions**: [Share ideas](https://github.com/Pusparaj99op/Flutter_HackMates/discussions)

### Social Media
[![Twitter](https://img.shields.io/badge/Twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white)](https://twitter.com/Flutter_HackMatesapp)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/pranaygajbhiye/)

</div>

---

<div align="center">

**⭐ Star this repo if you found it helpful!**

[⬆️ Back to top](#-Flutter_HackMates)

</div>
