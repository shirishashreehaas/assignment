# assignment
# Cocktail App 

The Cocktail App is a SwiftUI-based iOS application that allows users to see the list of cocktails by filter (Alcoholic, Non-Alcoholic), view their details, and mark their favorites. It uses Combine for API calls.

---

## Features

- **Cocktails List:** View list of cocktails by filter (Alcoholic, Non-Alcoholic).
- **Cocktail Details:** View detailed instructions and ingredients.
- **Favorites Management:** Add or remove cocktails from favorites.
- **Error Handling:** Displays detailed error messages with retry options.
- **Unit Tests:** Ensures app reliability through Unit tests.
- **API Calls:** Combine for API handling.
- **ImageCaching:** Uses the `ImageLoader` class to handle image fetching, caching, and decoding.
---

## Tech Stack

- **Language:** Swift
- **Frameworks:** SwiftUI, Combine
- **API Integration:** [TheCocktailDB API](https://www.thecocktaildb.com/)
- **Testing:** XCTest for Unit Tests

---

## Installation

1. Clone the repository:

   git clone https://github.com/shirishashreehaas/assignment

Usage
See list of Cocktails:
See the list of cocktails by filter(Alcoholic, Non-Alcoholic).

View Details:
Tap on any cocktail to view its details.

Mark Favorites:
Tap the favorite icon to add/remove from favorites.

API Endpoints
List Cocktails: /filter.php?c={filter}
Cocktail Details: /lookup.php?i={id}

Screenshots:
![App Screenshot](screenshot1.png)


