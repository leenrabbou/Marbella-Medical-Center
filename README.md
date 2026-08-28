# 🩺 Marbella — Medical App

<div align="center">

<img src="https://img.shields.io/badge/Platform-Flutter-02569B?style=for-the-badge&logo=flutter" />
<img src="https://img.shields.io/badge/Language-Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
<img src="https://img.shields.io/badge/Architecture-Feature--Based%20%2B%20MVVM-orange?style=for-the-badge" />

**Clinical Practice Management System for Doctors & Nurses**

</div>

---

## 📖 Overview

**Marbella** is a Flutter-based clinical practice management application developed to support healthcare workflows for **doctors and nurses**.

The application provides role-specific interfaces through two dedicated entry points while sharing common clinical and application features:

| Entry Point        | Role   |
| ------------------ | ------ |
| `main_doctor.dart` | Doctor |
| `main_nurse.dart`  | Nurse  |

The implemented system covers a broad clinical and administrative scope:

- Patient management
- Clinical encounters, Medical conditions, Observations, Medications & medication interactions, Laboratory and medical tests
- Doctor certificates, Schedules, Profiles, Appointments
- Communication (chat), Notifications, Auditing

The project follows a **feature-based architecture with MVVM-style separation**, organizing functionality into models, services, ViewModels, views, and reusable widgets.

---

## 📸 Visual Experience

<div align="center">

<table>
  <tr>
    <td align="center"><img src="screenshots/Screenshot 2026-08-18 174636.png" width="360" alt="Marbella Application Screenshot" style="border-radius:12px; box-shadow:0 4px 12px rgba(0,0,0,0.15);" /></td>
    <td align="center"><img src="screenshots/Screenshot 2026-08-18 185557.png" width="360" alt="Marbella Application Screenshot" style="border-radius:12px; box-shadow:0 4px 12px rgba(0,0,0,0.15);" /></td>
    <td align="center"><img src="screenshots/Screenshot 2026-08-18 200832.png" width="360" alt="Marbella Application Screenshot" style="border-radius:12px; box-shadow:0 4px 12px rgba(0,0,0,0.15);" /></td>
  </tr>
  <tr>
    <td align="center"><img src="screenshots/Screenshot 2026-08-18 202726.png" width="360" alt="Marbella Application Screenshot" style="border-radius:12px; box-shadow:0 4px 12px rgba(0,0,0,0.15);" /></td>
    <td align="center"><img src="screenshots/Screenshot 2026-08-18 203610.png" width="360" alt="Marbella Application Screenshot" style="border-radius:12px; box-shadow:0 4px 12px rgba(0,0,0,0.15);" /></td>
    <td align="center"><img src="screenshots/Screenshot 2026-08-18 203649.png" width="360" alt="Marbella Application Screenshot" style="border-radius:12px; box-shadow:0 4px 12px rgba(0,0,0,0.15);" /></td>
  </tr>
  <tr>
    <td align="center"><img src="screenshots/Screenshot 2026-08-18 204024.png" width="360" alt="Marbella Application Screenshot" style="border-radius:12px; box-shadow:0 4px 12px rgba(0,0,0,0.15);" /></td>
    <td align="center"><img src="screenshots/Screenshot 2026-08-18 231247.png" width="360" alt="Marbella Application Screenshot" style="border-radius:12px; box-shadow:0 4px 12px rgba(0,0,0,0.15);" /></td>
    <td align="center"><img src="screenshots/Screenshot 2026-08-18 203247.png" width="360" alt="Marbella Application Screenshot" style="border-radius:12px; box-shadow:0 4px 12px rgba(0,0,0,0.15);" /></td>
  </tr>
</table>

_Additional application screens are available in the [`screenshots/`](./screenshots) directory._

</div>

---

## ✨ Implemented Features

### 🔐 Authentication & Account Management

The application provides dedicated authentication and account-management flows for supported users.

| Feature              | Description                                       |
| -------------------- | ------------------------------------------------- |
| Doctor & nurse login | Dedicated role-based login interfaces             |
| Authentication       | Phone number and password verification            |
| Verification flow    | Verification-code, required, and success states   |
| Token management     | Authentication token handling                     |
| Password recovery    | Forgot-password, reset, and change-password flows |
| Local storage        | Authentication-related persisted data             |
| State management     | Authentication state handling                     |

### 👥 Patient Management

A dedicated patient registry for browsing and accessing patient information.

- Patient listing, search, and paginated data
- Patient cards and detailed patient information
- Patient overview with active medical conditions and active medications
- Patient encounters and related clinical information

### 📅 Appointment Management

An organized interface for reviewing appointments and their associated information.

- Appointment listing, details, and cards
- Status-based organization
- Date-based navigation
- Patient, clinic, and service information
- Appointment time and notes

### 🩺 Clinical Encounters

Encounters provide a central context for clinical visits and their associated medical information.

- Encounter listing, details, and overview
- Encounter notes and services
- Patient medications related to the encounter
- Encounter-specific cards and dialogs

### 📝 Encounter Notes

Functionality for managing notes associated with clinical encounters.

- Displaying and adding encounter notes
- Note cards and dialogs
- Encounter note service and ViewModel

### 🩻 Medical Conditions

Access to medical conditions associated with patients and clinical records.

- Conditions listing and information
- Condition cards and dialogs
- Condition service and ViewModel

### 💊 Medications

Medication functionality is divided into catalog management and patient-specific management.

**Medication Catalog**

- Listing, details, and information
- Cards and dialogs

**Patient Medications**

- Listing, details, and cards
- Dialogs, service, and ViewModel

### ⚠️ Medication Interactions

Functionality for displaying medication-related interactions and conflicts.

- Drug–drug and drug–condition interactions
- Interaction lists, details, and dialogs
- Severity and conflict information
- Dedicated interaction service and ViewModel

### 🧪 Laboratory & Medical Tests

Dedicated modules for laboratory and medical test information.

- Laboratory test listing, details, and results
- Medical test listing and information
- Test cards and dialogs
- Laboratory and medical test ViewModels

### 📊 Clinical Observations

Access to clinical observation records.

- Observation listing and information
- Observation cards and dialogs
- Observation service and ViewModel

### 👩‍⚕️ Nurse Management

Functionality for viewing nurses associated with clinical encounters.

- Nurses listing, details, and cards
- Nurse dialogs and encounter-related information
- Paginated nurse data
- Nurse service and ViewModel

### 📜 Doctor Certificates

Doctors can access their certificates through a dedicated module.

- Certificate listing, details, and cards
- Certificate dialogs and file information
- Certificate image viewing
- PDF certificate viewing (dedicated PDF viewer screen)

### 💬 Chat & File Attachments

A dedicated communication module with support for conversations, messages, and attachments.

- Conversations list and pagination
- Chat rooms and message listing with pagination
- Message bubbles and input
- Message state handling
- Image and file attachments with local handling
- File service and ViewModel

### 🔔 Notifications & Real-Time Communication

The notification system combines application notifications with real-time communication infrastructure.

- Notifications list and cards
- Notification service and ViewModel
- Local notification support (`flutter_local_notifications`)
- Pusher integration with dedicated service
- User-specific real-time channels
- Notification state handling

### 📋 Audit Logging

An audit module for displaying recorded changes.

- Audit records and listing
- User-related audit information
- Audit timeline with changed-field information
- Previous and updated values with field-change comparison
- Localized audit field labels
- Audit service and ViewModel

### 🗓️ Schedule Management

A dedicated schedule module.

- Schedule information
- Schedule/response models
- Schedule service, ViewModel, view, and cards

### 👤 Profile Management

Access to user profile information.

- Profile information and view
- Profile model, service, and ViewModel
- Profile information components

### ⚙️ Application Settings

Settings related to localization, themes, and application presentation.

- Language and theme selection (light / dark)
- Splash and onboarding screens
- Main application shell
- Mobile navigation and tablet layout

---

## 🌍 Localization

The application supports:

| Locale | Language |
| ------ | -------- |
| 🇬🇧     | English  |
| 🇸🇦     | Arabic   |

Localization is implemented using Flutter's localization system and ARB source files:

```text
lib/l10n/
├── intl_en.arb
└── intl_ar.arb
```

Generated localization files are maintained under:

```text
lib/generated/
```

The application supports both **LTR** and **RTL** layouts according to the selected language.

---

## 🎨 UI & Theme

The application uses centralized light and dark Material themes.

- Light & dark themes
- Reusable application widgets
- Consistent buttons, text fields, and search fields
- Avatars and loading states
- Shimmer components
- Snackbars
- Timeline components
- State handling widgets

---

## 📱 Responsive Design

The application provides layouts adapted to different screen sizes.

- Mobile navigation
- Tablet layout
- Adaptive application shell
- Responsive sizing using `flutter_screenutil`

---

## 🛡️ Screen Protection

The project includes screen-protection functionality for screens containing sensitive content, implemented through a dedicated secure screen controller and the `screen_protector` package.

---

## 💾 Local Storage

The application uses two storage mechanisms according to the type of data being persisted.

| Mechanism              | Purpose                                                         |
| ---------------------- | --------------------------------------------------------------- |
| **Shared Preferences** | Cache service for non-sensitive persisted application data      |
| **Secure Storage**     | Sensitive authentication information (`flutter_secure_storage`) |

Storage infrastructure is organized under:

```text
lib/core/databases/cache/
```

---

## 🔄 MVVM Structure

Features are organized around separate responsibilities:

| Layer         | Responsibility                                          |
| ------------- | ------------------------------------------------------- |
| **Model**     | Data exchanged between the application and backend      |
| **Service**   | Feature-specific API communication and operations       |
| **ViewModel** | Feature state and coordination between view and service |
| **View**      | User interface for the feature                          |
| **Widgets**   | Reusable UI components specific to a feature            |

This separation keeps presentation, state management, data representation, and API communication organized independently.

---

## 🧪 Testing

A testing setup based on Flutter's testing framework and Mocktail for mocking dependencies.

```text
flutter_test
mocktail
```

Tests are organized around application functionality and use shared mock objects where required.

---

## 🚀 Installation & Setup

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio (or another supported Flutter development environment)
- Android SDK
- A configured Laravel backend

### Install Dependencies

```bash
flutter pub get
```

### Generate Localization

```bash
flutter gen-l10n
```

### Run the Doctor Application

```bash
flutter run -t lib/main_doctor.dart
```

### Run the Nurse Application

```bash
flutter run -t lib/main_nurse.dart
```

> The backend API must be running and accessible from the device or emulator for API-dependent functionality.

---

## 📂 Project Structure

The project separates shared infrastructure from role-specific functionality.

```text
lib/
│
├── app/                    # Application-level configuration
│
├── core/                   # Shared infrastructure
│   ├── connection/         # Network connectivity
│   ├── databases/
│   │   ├── api/            # API client and endpoints
│   │   └── cache/          # Local and secure storage
│   ├── errors/             # Error handling
│   ├── helper/             # Shared helpers
│   ├── params/             # Request parameter classes
│   ├── providers/          # Provider configuration
│   ├── themes/             # Application themes
│   └── widgets/            # Reusable widgets
│
├── features/
│   ├── only_doctor/        # Doctor-specific features
│   └── shared/             # Shared features
│
├── generated/              # Generated localization files
├── l10n/                   # Localization sources
│
├── main_doctor.dart        # Doctor application entry point
└── main_nurse.dart         # Nurse application entry point
```

---

## 📄 Project Report

The full technical documentation, system analysis, and design report for the project is available here:

- [📘 **Download the Project Report (PDF)**](docs/final_report.pdf)

---

## 👩‍💻 Development Team

**Leen Rabbou** _Flutter Developer_

---

<div align="center">

**Built with Flutter • Marbella ❤️**

</div>
