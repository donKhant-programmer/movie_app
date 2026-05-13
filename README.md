# 🎬 Movie App (Flutter)

A Flutter-based mobile application that allows users to search movies, view movie details, and browse results using the OMDb API.  
The project demonstrates clean architecture, API integration, state management, and pagination.

---

## ✨ Features

- 🔍 Movie search using OMDb API  
- 📃 Movie list with grid layout  
- 🎬 Movie detail screen with full information  
- 📜 Pagination (infinite scroll)  
- ⏳ Loading & error handling states  
- 🖼 Cached image loading for performance  
- 📱 Responsive UI (mobile/tablet support)  

---

## 🏗 Architecture

The project follows a **feature-based clean structure**:

lib/
│
├── core/
│   ├── constants/
│   ├── theme/
│   └── network/
│
├── features/
│   └── movies/
│       ├── models/
│       ├── providers/
│       ├── screens/
│       ├── services/
│       └── widgets/
│
└── main.dart

---

## 🧠 State Management

Provider is used for state management.

### Handles:
- Movie list state  
- Loading & pagination state  
- Selected movie detail state  
- Error handling  

---

## 🌐 API Integration

This app uses the **OMDb API**

### Base URL: http://www.omdbapi.com/

## 🚀 Getting Started

1. Clone repository
git clone https://github.com/donKhant-programmer/movie_app.git
2. Install dependencies
flutter pub get
3. Add API key

Go to:

lib/core/constants/api_constants.dart

Replace:

static const String apiKey = 'YOUR_API_KEY';
4. Run the app
flutter run

Using Flutter version 3.32.0 • Dart 3.8.0


