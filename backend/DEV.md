# Development Commands

This document outlines the various commands that can be used during development of this Dart Frog application.

## Core Commands

### Development Server

```bash
# Start the development server with hot reload
dart_frog dev

# Start on a specific port
dart_frog dev --port 3000
```

### Build Commands

```bash
# Create a production build
dart_frog build

# Run the production build
dart build/bin/server.dart
```

## Testing Commands

```bash
# Run all tests
dart test

# Run tests with coverage
dart test --coverage=coverage

# Generate coverage report
dart pub global activate coverage
dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --packages=.packages --report-on=lib
```

## Code Quality Commands

```bash
# Run the Dart analyzer
dart analyze

# Format code
dart format .

# Fix common issues
dart fix --apply
```

## Dependency Management

```bash
# Get dependencies
dart pub get

# Upgrade dependencies
dart pub upgrade

# Add a dependency
dart pub add package_name

# Remove a dependency
dart pub remove package_name
```

## Docker Commands

```bash
# Build Docker image
docker build -t dart_frog_app .

# Run Docker container
docker run -p 8080:8080 dart_frog_app

# Build and run with Docker Compose
docker-compose up --build
```

## Database Migration Commands (if applicable)

```bash
# Generate migration
dart run db generate

# Run migrations
dart run db migrate

# Rollback migration
dart run db rollback
```

## CI/CD Commands

```bash
# Verify formatting
dart format --output=none --set-exit-if-changed .

# Verify analyzer
dart analyze --fatal-infos --fatal-warnings

# Run all verifications (format, analyze, test)
dart run ci
```

## Performance Commands

```bash
# Run benchmark tests
dart run benchmark

# Profile the application
dart run --profile bin/server.dart
```

## Useful Development Tools

```bash
# Install dart_frog CLI
dart pub global activate dart_frog_cli

# Update dart_frog CLI
dart pub global activate dart_frog_cli --overwrite

# Generate API documentation
dart doc .
```

## Environment Management

```bash
# Set environment to development
export DART_ENV=development

# Set environment to production
export DART_ENV=production

# List all environment variables
printenv | grep DART_
```

## Troubleshooting Commands

```bash
# Clear pub cache
dart pub cache clean

# Verify Dart SDK version
dart --version

# Check dart_frog version
dart_frog --version

# Validate project structure
dart_frog doctor
```

## Git Hooks (if using)

```bash
# Install git hooks
dart run husky install

# Run pre-commit hooks manually
dart run husky run pre-commit
```

Note: Some commands might require additional setup or dependencies. Make sure to check the specific documentation for each tool or package you're using.

## Additional Resources

- [Dart Frog Documentation](https://dartfrog.vgv.dev/docs/overview)
- [Dart Documentation](https://dart.dev/guides)
- [Very Good Analysis Documentation](https://pub.dev/packages/very_good_analysis)
