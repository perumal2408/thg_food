# THG Food App

## Description
The THG Food App displays daily meals available in the office cafeteria and allows users to rate each meal.

## Features
- Displays daily meals (breakfast, lunch, dinner)
- Users can rate each meal
- Displays the number of people who have rated and the average rating

## Installation

### Prerequisites
- Flutter SDK
- Firebase account

### Steps

1. Clone the repository:

    ```bash
    git clone https://github.com/yourusername/thg_food.git
    ```

2. Navigate into the project directory:

    ```bash
    cd thg_food
    ```

3. Install dependencies:

    ```bash
    flutter pub get
    ```

4. Setup Firebase:

    - Create a new Firebase project in the Firebase Console.
    - Add your Firebase configuration to `firebase_options.dart` located in the `lib` directory.

5. Run the App

    To run the app:

    ```bash
    flutter run
    ```

## Firebase Firestore Structure

**Collection:** `meals`

**Document ID:** `2024-07-17`

**Fields:**
- `breakfast`
  - `ratings`: [4, 5, 3, ...]
- `lunch`
  - `ratings`: [4, 5, 3, ...]
- `dinner`
  - `ratings`: [4, 5, 3, ...]

## Contributing
Contributions are welcome! Please open an issue or pull request for any changes.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
