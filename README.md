# Learning journey

An iOS app to help users track daily progress, manage learning streaks, and stay accountable for their goals.

## Description

Learning journey is designed for anyone who wants to build a consistent learning habit. It tackles the challenge of staying motivated by providing a clear visual tracker for your goals. 
The app helps you stay accountable by managing 'freeze' days for breaks and tracking your learning streak, which resets after 32 hours of no activity.

## ✨ Features

-   **Goal Setting:** Set custom learning goals with weekly, monthly, or yearly durations.
-   **Daily Logging:** Log daily progress as "Learned" or "Freeze" to maintain your streak.
-   **Streak Management:** Your streak automatically tracks your consistency. It resets after 32 hours of inactivity to keep you on track.
-   **Freeze Day System:** The app provides a limited number of "freeze" days based on your goal duration (2 per week, 8 per month, 98 per year) to allow for flexible breaks without losing your progress.
-   **Calendar View:** Visualize your entire journey with a comprehensive calendar that shows all your 'Learned' and 'Freeze' days.
-   **Goal Editing:** Easily edit your goal at any time using the edit icon.

## 🛠️ Technologies Used

-   [Swift](https://www.swift.org/)
-   [SwiftUI](https://developer.apple.com/xcode/swiftui/)
-   [Xcode](https://developer.apple.com/xcode/)

## 📂 Project Structure

The project is structured using the MVVM (Model-View-ViewModel) design pattern.

Learning/ ├── LearningApp.swift # Main app entry point ├── AppState.swift # Manages global app state ├── StyleGuide.swift # Contains custom styles and colors │ 
├── Models.swift # Data models (e.g., Goal, Log) │ ├── Views/ │ ├── ContentView.swift # Main view, possibly routing │ ├── GoalCreationFormView.swift # View for setting a new goal │
├── Logday.swift # View for logging daily progress │ └── reselectgoal.swift # View for editing/reselecting a goal │ ├── ViewModels/ │ ├── ContentViewModel.swift # ViewModel for ContentView │
├── LogdayViewModel.swift # ViewModel for Logday view │ └── ReselectGoalViewModel.swift # ViewModel for reselectgoal view │ 
├── Assets.xcassets # App icons, custom colors, etc. └── LearningTests/ # Unit and UI tests


## Prerequisites

-   iOS 26.0+
-   Xcode 26.0.1 (17A400)

## 🚀 Getting Started

### Installation

1.  Clone the repository:
    ```sh
    git clone [https://github.com/REEMALGHAMDI4/learning.git](https://github.com/REEMALGHAMDI4/learning.git)
    ```
2.  Open the project in Xcode:
    ```sh
    cd learning
    open Learning.xcodeproj
    ```

3.  Build and run the project using the "Run" button (▶) in Xcode, selecting your target simulator or device.

## Usage

1.  On first launch, set your learning goal and select a duration (week, month, or year).
2.  Each day, log your progress by tapping the large "Log as Learned" circle.
3.  If you take a day off, tap the "Log as Freeze" button to use one of your allotted freeze days.
4.  Track your current streak, which will increase with each log.
5.  Review your consistency on the full calendar to see all your 'Learned' and 'Freeze' days.
6.  Tap the edit icon to modify your goal at any time.

## 📧 Contact

REEMALGHAMDI4

Project Link: [https://github.com/REEMALGHAMDI4/learning](https://github.com/REEMALGHAMDI4/learning)
