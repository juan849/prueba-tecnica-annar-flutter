# Annar Products App

A Flutter mobile application for product management, developed as part of a technical assessment.

The application consumes a REST API built with ASP.NET Core and PostgreSQL to retrieve, create, and manage products and update product stock.

## Technologies

* Flutter
* Dart
* Provider
* REST API
* HTTP / JSON
* Clean Architecture
* Android
* iOS

## Features

* View the list of products.
* View product details.
* Create new products.
* Validate unique product codes.
* Update product stock.
* Consume REST API endpoints.
* Handle loading and error states.

## Requirements

Before running the application, make sure you have installed:

* Flutter SDK
* Dart SDK
* Android Studio or another Flutter-compatible development environment
* A physical Android device or Android emulator

You also need the backend API running locally.

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/juan849/prueba-tecnica-annar-flutter.git
cd prueba-tecnica-annar-flutter
```

### 2. Install Flutter dependencies

```bash
flutter pub get
```

### 3. Configure the API URL

Open:

```text
lib/core/constant/api_constant.dart
```

You will find:

```dart
class ApiConstant {
  static String baseUrl = 'http://YOUR_LOCAL_IP:5065';
  static String endPoint = '$baseUrl/api/products';
}
```

Replace `YOUR_LOCAL_IP` with the local IP address of the computer running the backend.

For example:

```dart
static String baseUrl = 'http://192.168.1.100:5065';
```

The mobile device and the computer running the API must be connected to the same local network.

### 4. Start the backend

Clone and configure the backend API:

https://github.com/juan849/prueba-tecnica-annar

Follow the backend README instructions and run:

```bash
dotnet run --urls "http://0.0.0.0:5065"
```

The API will then be available through port `5065`.

### 5. Run the Flutter application

Connect an Android device or start an emulator and run:

```bash
flutter run
```

You can check the available devices with:

```bash
flutter devices
```

## API Integration

The application consumes the following backend endpoints:

```text
GET    /api/products
POST   /api/products
GET    /api/products/{id}
PATCH  /api/products/{id}/stock?cantidad={cantidad}
```

The API is responsible for product persistence and business rules, while the Flutter application handles the mobile user interface and interaction with the API.

## Project Structure

The project follows a feature-based structure with separation between presentation, domain, and data layers.

```text
lib/
├── core/
│   └── constant/
│
├── features/
│   └── productos/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       │
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       │
│       └── presentation/
│           ├── pages/
│           ├── provider/
│           └── widgets/
│
└── main.dart
```

### Architecture

The application separates responsibilities into three main layers:

* **Presentation:** Screens, widgets, and state management with Provider.
* **Domain:** Entities, repositories, and use cases.
* **Data:** API communication, models, and repository implementations.

This structure helps keep the code organized, maintainable, and easier to evolve.

## Backend

The backend repository is available here:

https://github.com/juan849/prueba-tecnica-annar

It was developed using:

* ASP.NET Core Web API
* Entity Framework Core
* PostgreSQL
* C#

## Notes

This project was developed as a technical assessment and demonstrates practical experience with Flutter, REST API integration, state management with Provider, application architecture, and mobile development.
