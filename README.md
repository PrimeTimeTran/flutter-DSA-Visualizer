## Goals

- Matrix

  - Game

    - Play/Stop
    - Generate Walls
    - Searches
      - [x] Add BFS Search
      - [ ] Add DFS Search
    - [x] Backtrace

  - Switch search types
  - [x] Build Graph Searching Demo

- Sorting

  - Algorithms

    - Bubble
    - Selection
    - Insertion
    - Merge

  - Animations
  - Toast
  - Panel Info
  - Panel Big O
  - Iteration Count

## Deploy

### Netlify

Add as build path

```sh
/
```

Add as build command

```sh
if cd flutter; then git pull && cd ..; else git clone https://github.com/flutter/flutter.git; fi && flutter/bin/flutter config --enable-web && flutter/bin/flutter build web --web-renderer html --no-tree-shake-icons --dart-define=FLUTTER_WEB_ENTRY=lib/main_production.dart
```
