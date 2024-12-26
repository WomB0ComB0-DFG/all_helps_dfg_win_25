## Include .env file
include .env

## Root directory
ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

## Set 'bash' as default shell
SHELL := $(shell which bash)

## Set 'help' target as the default goal
.DEFAULT_GOAL := help

## Check for required tools
DOCKER := DOCKER_BUILDKIT=1 $(shell command -v docker)
DOCKER_COMPOSE := COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 $(shell command -v docker-compose)
DOCKER_COMPOSE_FILE := docker-compose.yaml
DART := $(shell command -v dart)
DART_FROG := $(shell command -v dart_frog)

.PHONY: help
help: ## Show this help message
	@egrep -h '^[a-zA-Z0-9_\/-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort -d | awk 'BEGIN {FS = ":.*?## "; printf "Usage: make \033[0;34mTARGET\033[0m \033[0;35m[ARGUMENTS]\033[0m\n\n"; printf "Targets:\n"}; {printf "  \033[33m%-25s\033[0m \033[0;32m%s\033[0m\n", $$1, $$2}'

.PHONY: requirements
requirements: ## Check if all required tools are installed
ifndef DOCKER
	@echo "🐳 Docker is not available. Please install docker."
	@exit 1
endif
ifndef DOCKER_COMPOSE
	@echo "🐳🧩 docker-compose is not available. Please install docker-compose."
	@exit 1
endif
ifndef DART
	@echo "🎯 Dart is not available. Please install Dart from https://dart.dev/get-dart"
	@exit 1
endif
ifndef DART_FROG
	@echo "🐸 Dart Frog is not available. Installing..."
	@dart pub global activate dart_frog_cli
endif
	@echo "✅ All necessary dependencies are installed!"

TAG ?= latest
APP_NAME ?= dart_frog_app

# Development Commands
.PHONY: install
install: requirements ## Install project dependencies
	@echo "📦 Installing dependencies..."
	@dart pub get
	@dart pub run build_runner build --delete-conflicting-outputs

.PHONY: dev
dev: install ## Start development server
	@echo "🚀 Starting development server..."
	@dart_frog dev

.PHONY: build
build: install ## Build the application
	@echo "🏗️ Building application..."
	@dart_frog build
	@dart compile exe build/bin/server.dart -o build/bin/server

.PHONY: test
test: ## Run tests
	@echo "🧪 Running tests..."
	@dart test

.PHONY: coverage
coverage: ## Run tests with coverage
	@echo "📊 Running tests with coverage..."
	@dart test --coverage=coverage
	@dart pub global activate coverage
	@dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --packages=.packages --report-on=lib

# Docker Commands
.PHONY: docker/build
docker/build: ## Build Docker image
	@echo "🐳 Building Docker image..."
	@docker build -t $(APP_NAME):$(TAG) .

.PHONY: docker/start
docker/start: ## Start application in Docker
	@echo "🚀 Starting application in Docker..."
	@docker-compose up -d

.PHONY: docker/stop
docker/stop: ## Stop Docker containers
	@echo "🛑 Stopping Docker containers..."
	@docker-compose down

.PHONY: docker/logs
docker/logs: ## View Docker logs
	@echo "📋 Showing logs..."
	@docker-compose logs -f

.PHONY: docker/clean
docker/clean: ## Clean Docker resources
	@echo "🧹 Cleaning Docker resources..."
	@docker-compose down -v --rmi all --remove-orphans

# Firebase Commands
.PHONY: firebase/init
firebase/init: ## Initialize Firebase configuration
	@echo "🔥 Initializing Firebase..."
	@test -f firebase-credentials.json || echo "⚠️ Please add firebase-credentials.json to the project root"

# Utility Commands
.PHONY: format
format: ## Format code
	@echo "✨ Formatting code..."
	@dart format .

.PHONY: lint
lint: ## Run linter
	@echo "🔍 Running linter..."
	@dart analyze

.PHONY: clean
clean: ## Clean build artifacts
	@echo "🧹 Cleaning build artifacts..."
	@rm -rf build/
	@rm -rf .dart_tool/
	@rm -rf coverage/

.PHONY: all
all: clean install format lint test build ## Run all main tasks

# Production Commands
.PHONY: prod/build
prod/build: build docker/build ## Build for production
	@echo "🎯 Production build complete"

.PHONY: prod/start
prod/start: ## Start in production mode
	@echo "🚀 Starting in production mode..."
	@docker-compose -f docker-compose.yaml up -d

.PHONY: prod/stop
prod/stop: ## Stop production services
	@echo "🛑 Stopping production services..."
	@docker-compose -f docker-compose.yaml down
