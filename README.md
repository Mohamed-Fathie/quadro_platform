
[![GitHub stars](https://img.shields.io/github/stars/Mohamed-Fathie/quadro_platform?style=flat)](https://github.com/Mohamed-Fathie/quadro_platform/stargazers) [![GitHub forks](https://img.shields.io/github/forks/Mohamed-Fathie/quadro_platform?style=flat)](https://github.com/Mohamed-Fathie/quadro_platform/network) [![License: MIT](https://img.shields.io/badge/License-MIT-green?style=flat)](https://github.com/Mohamed-Fathie/quadro_platform/blob/main/LICENSE) [![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue?logo=flutter&logoColor=white)](https://flutter.dev) [![Firebase](https://img.shields.io/badge/Firebase-★-yellow?logo=firebase&logoColor=black)](https://firebase.google.com)
[![Watch Demo](https://img.shields.io/badge/Watch%20Demo-LinkedIn-blue?logo=linkedin)](https://www.linkedin.com/posts/mohamedfathie-tech_graduation-softwareengineering-classof2024-activity-7301957355179577344-d5Uy)

# Quadro Platform
**Unified vehicle maintenance & roadside assistance for owners, workshops, and tow providers.**

---

## 📖 Table of Contents
1. [About](#about)
2. [Key Features](#key-features)
3. [Tech Stack & Architecture](#tech-stack--architecture)
4. [Project Structure](#project-structure)
5. [Screenshots & Demo](#screenshots--demo)
6. [Getting Started](#getting-started)
   - [Prerequisites](#prerequisites)
   - [Environment Setup](#environment-setup)
   - [Installation & Run](#installation--run)
7. [Usage](#usage)
8. [Testing](#testing)
9. [Contributing](#contributing)
10. [License](#license)

---

## About
**Quadro** is a cross-platform solution (Flutter mobile + web) that seamlessly connects vehicle owners with mechanic workshops and towing providers. Whether you need a tow or routine maintenance, Quadro delivers real-time booking, live updates, and a user-friendly interface for all stakeholders.

## Key Features

### For Vehicle Owners 
- 🚗 **Request Towing**: Instant access to nearby tow services
- 🔍 **Find Workshops**: Browse and filter by location, services, and ratings
- 📅 **Booking & Notifications**: Real-time status updates and push alerts
- ⭐ **Workshop Profiles**: Detailed info, customer reviews, and photos

### For Towing Providers
- 📋 **Dashboard**: Accept/reject service requests
- 📈 **Availability Management**: Set service hours and toggle status
- 🔔 **Instant Alerts**: New request notifications

### For Workshop Managers 
- 🛠️ **Service Catalog**: Manage repair and maintenance offerings
- 🗓️ **Appointment Scheduling**: View, confirm, or reschedule bookings
- 💬 **Feedback Center**: Respond to customer reviews

### Core Capabilities
- ⚡ **Real-Time**: Firebase Cloud Firestore & Cloud Messaging
- 🔧 **Modular & Scalable**: Clean feature-based architecture
- 🌐 **Cross-Platform**: iOS, Android & responsive Web

## Tech Stack & Architecture

```
Flutter (Dart)  •  Firebase (Auth, Firestore, Messaging, Storage)  
```

```
┌── Quadro-Mobile (Flutter)
└── Quadro-Web    (Flutter Web)
    └── Firebase Backend Services
        ├── Authentication
        ├── Cloud Firestore / Realtime DB
        ├── Cloud Messaging (FCM)
        └── Storage
```

## Project Structure
```text
quadro_platform/
├── mobile/               # Flutter mobile app
│   └── lib/
│       ├── features/
│       │   ├── authentication/
│       │   │   ├── bloc/
│       │   │   │   ├── authentication_bloc.dart
│       │   │   │   ├── authentication_event.dart
│       │   │   │   └── authentication_state.dart
│       │   │   ├── models/user.dart
│       │   │   ├── views/{login,signup}_screen.dart
│       │   │   └── repositories/authentication_repository.dart
│       │   ├── profile/
│       │   └── …
│       └── shared/{widgets,utils,themes}

```

## Screenshots & Demo
![App Screenshot](docs/images/app_screenshot.png)
> 🎥 **Demo Video**: Click the badge above or visit the [LinkedIn post](https://www.linkedin.com/posts/mohamedfathie-tech_graduation-softwareengineering-classof2024-activity-7301957355179577344-d5Uy).

## Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) ≥ 3.0.0
- [Dart SDK](https://dart.dev/get-dart)
- Firebase project with Auth, Firestore, FCM, Storage enabled

### Environment Setup
1. Copy the example environment files:
   ```bash
   cp .env.example .env
   ```
2. Update `.env` with your Firebase credentials and API keys.

### Installation & Run

1. **Clone the repository**
   ```bash
   git clone https://github.com/Mohamed-Fathie/quadro_platform.git
   cd quadro_platform
   ```

2. **Mobile App**
   ```bash
   cd mobile
   flutter pub get
   flutter run
   ```

3. **Web App**
   ```bash
   cd ../web
   npm install
   npm start
   ```

## Usage
1. **Vehicle Owner**: Open the mobile app → Sign up / Log in → Request service.
2. **Tow Provider**: Log in to the web dashboard → Set availability → Manage incoming requests.
3. **Workshop Manager**: Access the web portal → Configure services → Monitor bookings & feedback.

## Testing
- **Unit & Widget Tests** (Mobile):  `flutter test`
- **Web Tests**:  `npm test`

## Contributing
Contributions are welcome! Please read our [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on code style, testing, and pull requests.

## License
Distributed under the MIT License. See [LICENSE](LICENSE) for details.
```

