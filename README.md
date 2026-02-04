# TikTok Style Video Feed App


https://github.com/user-attachments/assets/a4283f9d-9e4d-476b-b791-07655f848a00


A TikTok-style vertical video scrolling application built with iOS (Swift). This app demonstrates a hybrid architecture using both UIKit and SwiftUI, integrating with the Pexels API to fetch and display high-quality portrait videos.

## Features

- **Vertical Video Feed**: Smooth, paging-enabled vertical scrolling of videos (TikTok style).
- **Hybrid Architecture**: Leverages the robustness of UIKit for the complex video feed and the speed of SwiftUI for the Profile screen.
- **API Integration**: Fetches real-time video content from the Pexels API (curated portrait videos).
- **Async Data Loading**: Efficiently loads video metadata and content concurrently.
- **Custom UI Components**: Transparent tab bar and overlay controls (Heart/Like animation).

## Setup Steps

1. **Clone the repository**.
2. **Open the Project**:
   - Double-click `TikTokApp.xcodeproj` inside the `TikTokApp` directory to open in Xcode 16+.
3. **Dependencies**:
   - The project uses native frameworks (UIKit, SwiftUI, AVFoundation) and does not rely on heavy external pods. Ensure Swift Package Manager resolves any minor util dependencies if present.
4. **Run the App**:
   - Select a simulator (e.g., iPhone 16 Pro) or your physical device.
   - Press `Cmd + R` or click the "Play" button in Xcode.
   - *Note*: If you encounter any signing issues, update the "Team" in the "Signing & Capabilities" tab of the project settings.

## Architectural Overview

The application follows the **MVVM (Model-View-ViewModel)** design pattern to ensure separation of concerns, testability, and maintainability.

### 1. Layers
- **Models** (`VideoResponse.swift`, `Video.swift`): Define data structures matching the Pexels API JSON response.
- **ViewModels** (`VideoFeedViewModel`, `ProfileViewModel`): Handle business logic, data fetching via `NetworkService`, and expose state to views.
- **Views**:
  - **UIKit**: `MainViewController` and Feed implementation manage the core paging experience using `UICollectionView` (Standard TikTok interaction).
  - **SwiftUI**: `ProfileView` manages the user profile screen, seamlessly embedded into the UIKit navigation stack using `UIHostingController`.
- **Services**: `NetworkService` handles all API networking calls using `URLSession` and completion handlers/concurrency.

### 2. Navigation
- Uses a fully programmatic `UITabBarController` (`MainTabBarController`) as the root.
- Navigation interfaces are code-based (Programmatic UI), removing reliance on Storyboards (Main.storyboard was removed) for better version control and modularity. `LaunchScreen.storyboard` remains for the splash screen.

## Tradeoffs and Known Limitations

- **Caching**: Currently, the app relies on basic `URLCache` and in-memory storage. There is no persistent disk caching (e.g., storing mp4 files to disk), which means videos may re-download on app restart.
- **Video Preloading**: The preloading strategy is basic. A more robust "sliding window" preloader could further improve instant playback responsiveness when scrolling very quickly.
- **API Limits**: The app uses the Pexels public API which has rate limits. Heavy usage might hit these limits. The API key is stored in `Constants`, which should be secured in a production environment.
- **Error Handling**: While network errors are caught, the UI feedback for errors (like "No Internet") is basic.

## Future Improvements (With More Time)

If given more time, the following improvements would be prioritized:

1. **Advanced Caching**: Implement a robust offline cache (using `FileManager` or a library like Kingfisher for thumbnails / custom caching for video blobs) to allow offline viewing and save bandwidth.
2. **Pagination**: Implement true infinite scrolling (Lazy Loading) that fetches the next page of videos as the user approaches the end of the current list, rather than a fixed fetch of 200 items.
3. **Tests**: Add comprehensive **Unit Tests** for ViewModels/Services and **UI Tests** for the critical user journeys.
4. **Video Editor**: Add "Create" functionality allowing users to record, trim, and upload their own videos.
5. **Interactive Elements**: Add a backend (Firebase/Custom) to support real user authentication, comments, and saving likes across sessions.
