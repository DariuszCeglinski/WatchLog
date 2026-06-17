# TV Series Rating & Tracking App - WatchLog

## About the Project

This project was created as part of a university assignment. It is a mobile application developed using **Flutter** and **Dart**, designed for discovering, rating, and tracking TV series.

The application integrates with the **TVMaze API** to provide up-to-date information about TV shows, including popular series, currently airing shows, and episodes released today.

The main purpose of the project is to create a personal TV series management platform where users can discover new content, rate shows, share opinions, and organize their watchlists.

---

## Features

### TV Series Discovery
- Browse popular TV series
- View currently airing shows
- Discover series with episodes released today
- Receive suggestions for interesting and trending shows
- Display detailed information about TV series

### Ratings and Reviews
- Rate TV series
- Add and manage personal opinions
- View previously submitted reviews
- Keep track of personal ratings for watched shows

### Watch Queue
- Add TV series to a personal watch queue
- Manage shows planned for future viewing
- Organize series that the user wants to watch

### Local Data Storage
- Uses **Hive database** for local data persistence
- Stores user preferences, ratings, reviews, and watch queue information locally

### Analytics and Monitoring
The application includes basic integration with:
- **Firebase Analytics** for tracking application usage and user interactions
- **Firebase Crashlytics** for crash reporting and improving application stability

---

## Technologies Used

- **Flutter** – framework for building cross-platform mobile applications
- **Dart** – programming language used for application development
- **TVMaze API** – external API providing TV series data
- **Hive** – lightweight local NoSQL database
- **Firebase Analytics** – application usage analytics
- **Firebase Crashlytics** – crash monitoring and reporting

---

## API Integration

The application uses the **TVMaze API** to retrieve:
- TV series information
- Series metadata
- Current airing shows
- Popular content
- Episode schedules

The application dynamically fetches and displays data provided by the API.

---

## Application Purpose

The project demonstrates the use of modern mobile development technologies, external API communication, local data storage, and application monitoring tools.

The main learning objectives of this project include:
- Building mobile applications with Flutter
- Working with REST APIs
- Managing local application data
- Integrating Firebase services
- Creating a complete mobile application workflow