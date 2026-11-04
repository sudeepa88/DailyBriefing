# Daily Briefing

A UIKit iOS app that shows a simple dashboard with three live sections, each loaded from a public API:

1. **Temperature**: current temperature from Open-Meteo
2. **Did you know?**: a random fact from Useless Facts
3. **Picture**: a random dog photo from Dog CEO

All three requests run in parallel with a Swift `TaskGroup`. A full-screen loader stays visible until every request has finished.

## Requirements

- Xcode 15 or later
- iOS 15+ (uses `async/await` and `URLSession.data(from:)`)
- Swift 5.9+

## Project structure

```
DashboardScreen/
├── Controllers/
│   └── DashboardViewController.swift   # Screen layout, loader, TaskGroup, cancellation
├── Views/
│   ├── TemperatureView.swift           # Temperature label + sun icon
│   ├── FactView.swift                  # "Did you know?" title + fact text
│   ├── PictureView.swift               # Display-only image view (no networking)
│   └── DashboardStyle.swift            # Shared colours, fonts, section labels
├── ViewModels/
│   ├── WeatherPostionViewModel.swift
│   ├── RandomFactViewModel.swift
│   └── DogImgViewModel.swift           # getDogImgData() + getDogImage()
├── Models/
│   ├── WeatherPositionModel.swift
│   ├── RandomFactModel.swift
│   └── DogImgModel.swift
└── Network/
    ├── APICaller.swift                 # All network calls + image download/cache
    ├── NetworkConstants.swift          # API URLs
    └── NetworkError.swift              # urlError, canNotParseData, invalidImageData
```

## Architecture

The app uses **MVVM**:

```
DashboardViewController  →  ViewModel  →  APICaller  →  URLSession
        ↑                                                   │
        └──────────── Model / UIImage ◄─────────────────────┘
```

- **Views** only display data. They expose a `configure(...)` method and never do networking.
- **ViewModels** call `APICaller` and keep the last result.
- **APICaller** owns every network request, including downloading images (with an in-memory `NSCache`).

## APIs used

| Section | Endpoint |
|---|---|
| Weather | `https://api.open-meteo.com/v1/forecast?latitude=…&longitude=…&current_weather=true` |
| Fact | `https://uselessfacts.jsph.pl/api/v2/facts/random` |
| Dog image | `https://dog.ceo/api/breeds/image/random` |

The dog API returns JSON with an image URL in `message`. `DogImgViewModel.getDogImage()` fetches that URL and then downloads the image with `APICaller.downloadImage(from:)`.

## Why Swift Concurrency instead of GCD

This project uses `async/await` and `TaskGroup` instead of traditional GCD (`DispatchQueue` and `DispatchGroup`).

### Problems with GCD

1. Results come back through **completion handlers**, which have to be passed into every function.
2. Nested completion handlers quickly turn into **callback hell** (the "pyramid of doom").
3. Every UI update needs a manual `DispatchQueue.main.async { }`, and forgetting one causes bugs or crashes.
4. Completion handlers must be marked `@escaping` and need `[weak self]` to avoid retain cycles.
5. `DispatchGroup` needs a balanced `enter()` / `leave()` for every task. A missing `leave()` means `notify` never fires.
6. Cancellation has to be built by hand.
7. The code is longer and harder to follow.

### What Swift Concurrency gives

1. **`async/await`**: asynchronous code reads top to bottom like normal code, with no callback hell.
2. **Errors with `throws` / `try` / `catch`**: no `Result` types or error parameters in callbacks.
3. **No escaping closures** for passing results back. Functions simply `return` their value.
4. **`TaskGroup`** runs several tasks in parallel and waits for all of them, with no `enter()`/`leave()` bookkeeping.
5. **Built-in cancellation**: cancelling the parent task automatically cancels every child task, and `URLSession` stops its requests.
6. **`@MainActor`**: the compiler knows which code must run on the main thread and reports a compile-time error when UI is touched from the background.
7. **Less code** overall.

> Note: UI updates still need to be on the main thread. Swift Concurrency doesn't remove that rule; it enforces it at compile time, and `await MainActor.run { }` (or an `@MainActor` context) handles the switch.

### Side by side

**GCD**

```swift
let group = DispatchGroup()

group.enter()
APICaller.getWeatherData { result in
    DispatchQueue.main.async {
        // update UI
        group.leave()
    }
}

group.enter()
APICaller.getRandomFacts { result in
    DispatchQueue.main.async {
        // update UI
        group.leave()
    }
}

group.notify(queue: .main) {
    self.hideLoader()
}
```

**Swift Concurrency**

```swift
await withTaskGroup(of: String.self) { group in
    group.addTask { /* weather */ }
    group.addTask { /* fact */ }
    for await result in group { print(result) }
}
hideLoader()
```

## How loading works

```
Parent Task (stored in loadTask)
 └── TaskGroup
      ├── Child 1: weather   → temperatureView.configure(...)
      ├── Child 2: fact      → factView.configure(...)
      └── Child 3: dog image → pictureView.configure(image:)
```

- Child tasks run in the background; UI updates go through `await MainActor.run { }`.
- Each child catches its own error, so one failed API doesn't block the others.
- After the group finishes, `hideLoader()` dismisses the overlay.

### Lifecycle and cancellation

| Method | Action |
|---|---|
| `viewDidLoad` | Builds the layout and loader |
| `viewWillAppear` | Calls `loadDashboardData()` (refreshes on every visit) |
| `viewDidDisappear` | `loadTask?.cancel()` cancels the parent, which cancels all child tasks |

`guard !Task.isCancelled` stops a cancelled load from hiding the loader of a newer one.

## Running the app

1. Open `DashboardScreen.xcodeproj` in Xcode.
2. Select a simulator or device.
3. Press **⌘R**.

## Notes

- The weather coordinates in `NetworkConstants.weatherAddress` decide which city is shown. For Kolkata use `latitude=22.5726&longitude=88.3639`.
- Make sure `dogImgAddress` has no trailing space, or `URL(string:)` will fail.
