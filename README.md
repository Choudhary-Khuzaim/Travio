<div align="center">
  <img src="assets/images/readme/banner.png" alt="Travio Banner" width="100%">
  
  <br />
  <br />

  <p>
    <b>A Premium, Mobile-First Travel & Booking Ecosystem</b>
  </p>

  <p>
    <a href="https://flutter.dev">
      <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?logo=flutter&logoColor=white" alt="Flutter" />
    </a>
    <a href="https://dart.dev">
      <img src="https://img.shields.io/badge/Dart-%230175C2.svg?logo=dart&logoColor=white" alt="Dart" />
    </a>
    <a href="https://github.com/Choudhary-Khuzaim/travio">
      <img src="https://img.shields.io/badge/Version-v2.3.0-FF6B6B.svg" alt="Version" />
    </a>
    <a href="https://github.com/Choudhary-Khuzaim/travio">
      <img src="https://img.shields.io/badge/Status-Active-brightgreen.svg" alt="Status" />
    </a>
    <a href="https://opensource.org/licenses/MIT">
      <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License" />
    </a>
  </p>
  
  <p>
    <img src="https://github-readme-stats.vercel.app/api/pin/?username=Choudhary-Khuzaim&repo=travio&theme=radical" alt="Repo Stats">
  </p>
</div>

---

## � Overview

**Travio** is a high-fidelity, comprehensive mobile application designed to redefine how travelers explore, plan, and book their journeys. Built with the powerful Flutter framework, Travio embraces a **Mobile-First** and **Luxury** philosophy. It provides a seamless, visually stunning experience that integrates destination discovery, high-end hotel reservations, flight and transport management, and interactive maps—all within one cohesive ecosystem.

Whether you're dreaming of the serene, snow-capped mountains of **Hunza**, the vibrant historical streets of **Lahore**, or the ancient, majestic juniper forests of **Ziarat**, Travio brings the world's most breathtaking destinations right to your fingertips.

---

## ✨ Key Features

### 🔐 Seamless Onboarding & Security
- **Dynamic Onboarding:** Beautiful, immersive entry flows utilizing advanced 3D & parallax animations.
- **Robust Authentication:** Secure Login, Signup, OTP Verification, and Forgot Password mechanisms.
- **Personalized Profiles:** Fully customizable user profiles, avatars, and settings for a tailored experience.

### 🗺️ Intelligent Exploration
- **Interactive Destinations:** Browse cities, top attractions, and hidden gems with a 3D perspective carousel.
- **Real-time Mapping:** Integrated mapping using `flutter_map`, allowing detailed interaction and location viewing.
- **Comprehensive Guides:** Detailed descriptions, weather insights, and curated facilities lists for dozens of destinations including Islamabad, Swat, Skardu, Gwadar, and more.

### 🏨 Premium Booking Engine
- **Luxury Stays:** A fully-featured hotel booking module with rich imagery, localized descriptions, rating systems, and interactive facility icons.
- **Transport Hub:** Manage local cabs, integrated flight details, and local events to complement your hotel stay.
- **Digital Ticketing:** Painless digital boarding passes and ticketing powered by fast QR-code generation.

### 👤 Personal Concierge
- **My Trips:** An intuitive, organized timeline for managing your previous adventures and upcoming journeys.
- **Saved Treasures:** Bookmark and wishlist your top-tier destinations to craft your ultimate bucket list.
- **Privacy & Customization:** Granular control over notifications, data policies, and UI themes (including a sleek dark mode).

---

## 📸 Visual Showcase

<div align="center">
  <img src="assets/images/readme/explore_mockup.png" alt="Explore Screen" width="48%">
  &nbsp;
  <img src="assets/images/readme/booking_mockup.png" alt="Booking Screen" width="48%">
</div>

> _Note: Ensure `/assets/images/readme/` contains the actual mockups or these will appear as broken images. Standardized names have been assumed in this visual showcase._

---

## 🛠️ Technical Stack

- **Core Framework:** [Flutter](https://flutter.dev) (v3.35.7+)
- **Programming Language:** [Dart](https://dart.dev) (v3.9.2+)
- **UI & Micro-Interactions:** `flutter_animate` for smooth, performant, eye-catching transitions.
- **Typography:** `google_fonts` (featuring primary *Outfit* aesthetics).
- **Mapping Engine:** `flutter_map`, `latlong2`, and `geolocator` for deep geospatial integration.
- **Utilities:** `qr_flutter` (Digital Passes), `share_plus` (Social Sharing), `url_launcher` (External Links), `intl` (Formatting).

---

## 📂 Project Architecture

A clean, scalable, and highly maintainable folder structure ensures fast iteration:

```text
lib/
├── core/               # App-wide configurations (Colors, Theme, Constants)
├── models/             # Business Logic & Data Models (Destinations, Hotels, Utilities)
├── main.dart           # App Entry Point & Root Configuration
├── screens/            # 40+ Feature-rich Modules
│   ├── auth/           # Login, Register, Forgot Password
│   ├── booking/        # Flights, Cabs, Hotel Reservations
│   ├── explorer/       # Discovery, Search, Maps, Interactive Carousels
│   └── profile/        # Preferences, Security, Privacy, Support
└── widgets/            # Reusable UI Components (Cards, Buttons, Inputs, Parallax)
```

---

## 🚀 Release Notes (v2.3.0)

### **v2.3.0 - The Destination Update**
- 🌟 **New Locales:** Added high-fidelity datasets & visual assets for **Ziarat**, **Swat**, and **Skardu**.
- 🎨 **UI Overhaul:** Introduced bespoke destination cards with optimized layout metrics.
- ⚡ **Performance:** Boosted remote imagery caching, fixed list scrolling physics, and squashed rendering overflow edges.

### **v2.1.0 - The Global Update**
- Added expansive multi-point local attractions inside major urban centers.
- Upgraded theme engines to enhance accessibility, contrast, and typography scaling.

---

## ⚙️ Setup & Installation

Follow these steps to run **Travio** locally on your machine:

### 1. Prerequisites
- Install [Flutter SDK](https://docs.flutter.dev/get-started/install).
- Ensure you have a running Android Emulator, iOS Simulator, or a connected physical device.

### 2. Installation Steps
Clone the repository to your local machine:
```bash
git clone https://github.com/Choudhary-Khuzaim/travio.git
cd travio
```

Fetch the required dependencies:
```bash
flutter pub get
```

Run the application:
```bash
flutter run
```

---

## 🤝 Contributing

We welcome contributions and continuous improvements! 

1. **Fork** the project on GitHub.
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`).
3. Commit your changes (`git commit -m 'Added an AmazingFeature'`).
4. Push to the Branch (`git push origin feature/AmazingFeature`).
5. Open a **Pull Request** explaining your modifications.

---

## 📄 License

This repository is licensed under the **MIT License**. Check out the `LICENSE` file for more information.

---

<div align="center">
  <br/>
  <b>Crafted with ❤️ by <a href="https://github.com/Choudhary-Khuzaim">Khuzaim Sajjad</a></b>
  <br/><br/>
  <a href="https://linkedin.com">
    <img src="https://img.shields.io/badge/Connect_on_LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn">
  </a>
</div>
