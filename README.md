## Branch Notes (`swiftui-implementation`)

### Scope

This branch has the implementation of the main SwiftUI screen architecture and interaction model with focus on:

- carousel behavior and selection synchronization,
- sticky search bar behavior during scroll,
- per-page statistics presentation,
- empty-state and keyboard/scroll edge cases,

---

### Architecture

- **SwiftUI root integration**
  - App entry uses `SceneDelegate` + `UIHostingController` for SwiftUI root rendering.
- **Presentation flow**
  - `MainView` owns screen composition and forwards state via bindings.
  - `MainViewModel` is the single source of truth for:
    - `pages`
    - `selectedPageIndex`
    - `searchText`
    - derived `currentPage`, `filteredItems`, `currentPageStatistic`.
- **Statistics rendering**
  - Statistics are shown for the currently selected page only.

---

### Basic Behavior

#### 1) Carousel
- Carousel selection is synchronized through `selectedPageIndex`.
- Infinite-loop behavior is implemented in the current carousel flow.
- Page indicator reflects active index:
  - active dot: blue
  - inactive dots: gray

#### 2) Sticky Search
- Search bar is handled as sticky during vertical scrolling.
- Added handling for opaque top background to avoid content showing through when an element is pinned.

#### 3) List + Empty State
- Filtered list rendering made to avoid row loss in repeated-ID scenarios.
- Empty-state handling improved to reduce invalid scroll-position.

#### 4) Keyboard / Scroll Interaction
- Scroll and keyboard dismissal behavior adjusted to reduce accidental focus loss and jumpy layout transitions while typing/filtering.

