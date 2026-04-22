# WhosOnFire: NFL Statistics Visualization & Comparison App

A mobile app for iOS (iPhone & iPad) built with SwiftUI that allows users to explore NFL player profiles, search and filter players, compare stats head-to-head, and visualize performance with interactive radar charts.

---

## Team

| Role | Focus |
|------|-------|
| Akhil Madipalli (akhimadi) | Frontend - SwiftUI views, navigation, adaptive layouts |
| Liam Murphy (liamm24)  | Backend - Python/Flask API, NFLverse data processing, radar chart |

---

## Architecture Overview

WhosOnFire uses a two-part architecture:

- **iOS App (SwiftUI)** - Handles all UI, navigation, and user interactions. Communicates with the backend over HTTP via `API.swift`.
- **Python Backend (Flask + NFLverse)** - Serves NFL player statistics from the `nflverse` Python library through a local REST API (`app.py`).

---

## Requirements

### Backend
- Python 3.8+
- pip packages: `flask`, `nflverse`, `pandas`

### iOS App
- Xcode 15+
- iOS 16+ deployment target
- iPhone or iPad simulator (or physical device on the same network as the backend)

---

## Setup Instructions

### Step 1 - Install Python Dependencies
In your root folder
```
cd backend
```
```bash
pip install flask nflverse pandas
```

### Step 2 - Start the Backend Server

In a terminal, remain on ./backend and run

```bash
python app.py
```

You should see output like:
```
* Running on http://0.0.0.0:5000
```

> Note: **Keep this terminal open.** The iOS app will not load any data if the Flask server is not running.

### Step 3 - Find Your Local IP Address

The iOS app needs to point to your machine's local IP address.

- **macOS:** Go to System Settings → Network, or run `ipconfig getifaddr en0` in Terminal.
- Your IP will look something like `192.168.1.42`

### Step 4 - Update the API Base URL

Open the Xcode project and navigate to:

```
WhosOnFire/Networking/API.swift
```

Find the line that defines the base URL and replace the placeholder IP with your machine's IP:

```swift
// API.swift
private let player_url_str = "http://YOUR_IP_HERE/players"
private let player_stat_url_str = "http://YOUR_IP_HERE/player_stats"
// Example:
private let player_url_str = "http://192.168.1.42/players"
private let player_stat_url_str = "http://192.168.1.42/player_stats"
```

### Step 5 - Run the App

1. Open `WhosOnFire.xcodeproj` in Xcode.
2. Select your target simulator or device.
3. Press **⌘R** to build and run.

> Note: If running on a **physical device**, both your iPhone/iPad and your Mac must be connected to the **same Wi-Fi network**.

---

## Features

- **Search & Filter Players** - Find NFL players by name, team, or position
- **Player Profiles** - View detailed stats for any player
- **Favorites** - Bookmark players for persistant, quick access.
- **Player to Player Comparison** - Compare two players side-by-side
- **Player to Position Average** - Compare a player to the average of its position and season
- **Radar Chart** - Visualize a player's stats relative to another player or the positional average\
- **Simularity Score** - Find players with similar playstyles. Ultilizes z-score cosine similarity to output a score between 0 and 100. 

---

## Known Issues

- **Manual IP configuration required** - `API.swift` must be updated with the host machine's local IP address before the app will function. There is no persistent hosting service. 
- **Backend must be running locally** - The Flask server (`app.py`) must be started in a separate terminal before launching the app.
  Planned Solution: Use Firebase to host both the frontend and the backend
  
- **Long Loading Time** - Currently, we fetch all player data and calculate statistics, when the app loads. This is generally inefficient, as NFL data is usually updated daily/weekly. 
- We calculate all stat averages for every season and position combination. This is an O(n^2) operation, which can vary in loading times.
  Planned Solution: Use a firebase cloud function to update data daily, this can run when the user is not running the app. 

---

## Project Structure

```
WhosOnFire/
├── backend/
│   ├── app.py                      # Flask server entry point
│   ├── player_season_info.pkl      # Cached NFLverse season stats
│   ├── players.pkl                 # Cached NFLverse player data
│   └── test.py                     # Backend tests
└── frontend/
    └── WhosOnFire/
        └── WhosOnFire/
            ├── App/                # App entry point & API.swift (update IP here)
            ├── Models/             # Data models
            ├── Resources/          # Assets and static resources
            ├── Views/              # SwiftUI views
            └── WhosOnFireApp.swift # @main entry point
```
