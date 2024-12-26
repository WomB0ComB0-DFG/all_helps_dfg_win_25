# Dart Frog Example Application

A server-side application built with [Dart Frog](https://dartfrog.vgv.dev), a fast, minimalistic backend framework for Dart.

## Prerequisites

Before running this application, make sure you have the following installed:

- [Dart SDK](https://dart.dev/get-dart) (version 2.19.0 or higher)
- [Dart Frog](https://dartfrog.vgv.dev/docs/overview) CLI

To install Dart Frog CLI, run:

```bash
dart pub global activate dart_frog_cli
```

## Getting Started

1. Clone the repository:

```bash
git clone https://github.com/your-username/all_helps_dfg_win_25.git
cd all_helps_dfg_win_25
```
 
2. Install dependencies:

```bash
dart pub get
```

3. Start the development server:

```bash
dart_frog dev
```

The server will start on `http://localhost:8080`

## Production Build

To create a production build:

```bash
dart_frog build
```

The built files will be available in the `build` directory.

To run the production build:

```bash
dart build/bin/server.dart
```

## Project Structure

```txt
├── lib/                    # Application logic
├── routes/                 # API routes
├── test/                   # Test files
├── pubspec.yaml           # Project dependencies
└── README.md             # Project documentation
```

## Code Quality

This project follows [Very Good Analysis](https://pub.dev/packages/very_good_analysis) for Dart, ensuring high-quality code standards.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Badges

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]
[![Powered by Dart Frog](https://img.shields.io/endpoint?url=https://tinyurl.com/dartfrog-badge)](https://dartfrog.vgv.dev)

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
