# capcoin

A beautiful and modern Flutter mobile application for tracking cryptocurrency prices 
in real-time with detailed charts and favorites management.




##  Features

### Core Features
-  **Real-time Crypto Prices** - Live cryptocurrency prices using CoinGecko API
-  **Search Functionality** - Search through 100+ cryptocurrencies
-  **Favorites System** - Save and manage your favorite coins
-  **Interactive Charts** - Price trends with multiple timeframes
-  **Detailed Coin View** - Comprehensive coin information
-  **Modern UI** - Clean and intuitive material design

### Chart Timeframes
- 1 Minute
- 20 Minutes
- 1 Hour
- 3 Hours
- 24 Hours

### Price Information
- Current Price (USD)

- Market Cap
- 24h Volume
- Price Charts
- All-time High/Low

## 📱 Screenshots




&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Home Screen&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Detail Screen

<img alt="Home Screen" src="https://github.com/user-attachments/assets/5a85484a-90fc-4bdd-9430-d121479b4c02?raw=true" />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<img alt="Detail Screen" src="https://github.com/user-attachments/assets/e912a01d-8890-4ccb-ad25-7b46cd8c9bf8?raw=true" />



## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code
- Android device or emulator

## Installation

1. **Clone or create the project:**
```bash
flutter create coin_cap
cd coin_cap
```

2. **Copy all the provided source files to their respective locations**

3. **Install dependencies:**
```bash
flutter pub get
```

4. **Run the app:**
```bash
flutter run
```

##  Project Structure
```

lib/
├── main.dart                      # App entry point
├── capcoin_card.dart            # Coin list item widget
├── price_chart.dart          # Interactive chart widget
├── search_bar.dart    # Custom search bar
├──  skeleton_loader.dart
└── chart_skeleton_loader.dart

├── models/
│   ├── capcoin.dart          # Coin data model
│   └── chart_data.dart           # Chart data model
├── services/
│   ├── capoin_api_service.dart   # API service for CoinGecko
│   |── favorites_service.dart    # Favorites management
    └── cache_service.dart
├── screens/
│   ├── home_screen.dart          # Main coin list screen
│   ├── detailed_screen.dart   # Detailed coin view
│   └── favorites_screen.dart     # Favorites list
|   └── splash_screen.dart         # Splash screen.dart
└── widgets/
   ```

## 🔌 API

This app uses the **CoinGecko API** (Free, no API key required):
- Base URL: `https://api.coingecko.com/api/v3`
- Endpoints used:
    - `/coins/markets` - Get coin list with prices
    - `/coins/{id}` - Get detailed coin data
    - `/coins/{id}/market_chart` - Get price chart data

**API Features:**
-  Free to use
-  No authentication required
-  Rate limit: 10-50 calls/minute
-  Real-time data

##  Dependencies

```yaml

dependencies:
  flutter:
    sdk: flutter
  
  # HTTP & API
  http: ^1.1.0
  
  # Charts
  fl_chart: ^0.65.0
  
  # State Management & Storage
  provider: ^6.1.1
  shared_preferences: ^2.2.2
  
  # UI Components
  intl: ^0.18.1
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0


```

## 🎯 Key Features Explanation

### 1. Home Screen
- Displays list of top 100 cryptocurrencies
- Shows coin logo, name, symbol, price, and 24h change
- Pull-to-refresh functionality
- Search bar at the top
- Navigate to coin details on tap
- Add/remove favorites with star icon

### 2. Capcoin Detail Screen
- Full coin information
- Interactive price chart
- Toggle between 5 timeframes (1m, 20m, 1h, 3h, 24h)
- Current price with percentage change
- Market cap and volume
- Add to favorites
- Back button to return to home

### 3. Favorites Screen
- List of saved favorite coins
- Same card design as home screen
- Remove favorites functionality
- Empty state when no favorites
- Persists across app sessions

### 4. Search Functionality
- Real-time search through coin list
- Search by coin name or symbol
- Case-insensitive matching
- Clear search button

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
