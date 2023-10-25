# Moviecatalog

## Overview

Moviecatalog is a Swift-based UIKit project focused on providing a seamless movie discovery and tracking experience. The project adheres to modern best practices in Swift and UIKit, and makes use of asynchronous `async/await` operations for better performance and responsiveness.

## Features

The application is organized around three main tabs:

1. **Top 20 List**: Displays a list of the top 20 trending movies.
2. **Search Movie**: Allows the user to search for movies by title.
3. **Watchlist**: A personalized list of movies that the user intends to watch.

## Dependencies

- **SDWebImage**: For asynchronous image downloading and caching.
- **TMDB Free API**: For fetching the movie database.

## Data Persistence

The app utilizes CoreData for persisting the user's watchlist.

## Project Status

The project is currently on hold due to other job obligations. Outstanding tasks include:

- Refactoring all views for code quality and performance optimization.
- Enhancing the watchlist tab to display movie posters using a collection view.

## Installation

1. Clone the repository.
2. Open the project in Xcode.
3. Install the required dependencies.
4. Build and run the project on a simulator or physical device.

## Usage

1. **Top 20 List**: Navigate to this tab to see a list of the top 20 trending movies.
2. **Search Movie**: Use the search bar to find movies by title.
3. **Watchlist**: Add or remove movies to your watchlist for future reference.

## Contributing

If you'd like to contribute, please fork the repository and use a feature branch. Pull requests are warmly welcome.

## Future Work

1. Refactor all views.
2. Implement collection view for the watchlist tab.

## License

Please see the [LICENSE.md](LICENSE.md) file for more information.

