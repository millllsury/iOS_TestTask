## Branch Notes (`uikit-implementation`)

### Scope

This branch contains the UIKit implementation of the main screen architecture and interaction model with focus on:

- infinite carousel behavior and selection synchronization,
- sticky search via table section header,
- per-page statistics presentation in a bottom sheet,
- list filtering and empty-search handling,
- keyboard and scroll interaction in a UIKit table-based layout.

---

### Architecture

- **UIKit root integration**
  - App entry uses SceneDelegate and sets MainViewController as root inside a hidden UINavigationController.
- **Presentation flow**
  - MainViewController owns UI composition and event handling.
  - `MainViewModel` is the state source for:
    - `pages`
    - `selectedPageIndex`
    - `searchText`
    - derived `currentPage`, `filteredItems`, `currentPageStatistic`.
- **Screen composition**
  - UITableView (main vertical content),
  - tableHeaderView (carousel + page control),
  - section header (SearchBarHeaderView) for sticky search,
  - floating statistics button anchored to keyboardLayoutGuide.
- **Statistics rendering**
  - Bottom sheet (StatisticsBottomSheetViewController) shows statistics for the currently selected page. 

---

### Basic Behavior

#### 1) Carousel
- Implemented with UICollectionView + compositional layout,
- Infinite behavior is handled through virtual indexing (CarouselLoop),
- UIPageControl reflects the real (mapped) page index,
- Page changes update selectedPageIndex in MainViewModel and trigger list refresh.

#### 2) Sticky Search
- Search is implemented as a table section header (SearchBarHeaderView), so it stays pinned while scrolling,
- Search text is synchronized back to MainViewModel.searchText.

#### 3) List + Empty State
- Rows are rendered from viewModel.filteredItems,
- Empty search results are shown via tableView.backgroundView (emptySearchStateView),
- Reload behavior includes debounced refresh on carousel-driven page changes.

#### 4) Keyboard / Scroll Interaction
- Floating action button is constrained to view.keyboardLayoutGuide to avoid overlap with keyboard,
- Additional tap gesture dismisses keyboard without blocking normal interactions.
