# Flutter CI/CD Guide - MusicBud

## 🚀 Overview

This guide covers the continuous integration and continuous deployment (CI/CD) setup for the MusicBud Flutter application. The CI/CD pipeline automatically runs tests, generates coverage reports, performs static analysis, and builds the application on every push and pull request.

## 📋 Table of Contents

- [Pipeline Architecture](#pipeline-architecture)
- [Workflow Jobs](#workflow-jobs)
- [Running Tests Locally](#running-tests-locally)
- [GitHub Actions Setup](#github-actions-setup)
- [Coverage Reports](#coverage-reports)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)

---

## 🏗️ Pipeline Architecture

The Flutter CI/CD pipeline consists of multiple jobs that run in parallel:

```
┌─────────────────────────────────────────────────────────┐
│                   Flutter CI/CD Pipeline                 │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │  Unit Tests  │  │Widget Tests │  │ Integration  │  │
│  │   (Ubuntu)   │  │  (Ubuntu)   │  │    Tests     │  │
│  │              │  │              │  │   (macOS)    │  │
│  │ • BLoC Tests │  │ • UI Tests  │  │ • E2E Tests  │  │
│  │ • Services   │  │ • Widgets   │  │ • Real Flows │  │
│  │ • Data Layer │  │ • Components│  │              │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
│                                                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │   Analyze    │  │Build Check  │  │  Security    │  │
│  │   & Lint     │  │             │  │    Scan      │  │
│  │              │  │ • Debug APK │  │              │  │
│  │ • Format     │  │ • Verify    │  │ • Deps Audit │  │
│  │ • Analyzer   │  │   Build     │  │ • Outdated   │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
│                                                          │
│                  ┌──────────────┐                       │
│                  │    Notify    │                       │
│                  │              │                       │
│                  │ • Summary    │                       │
│                  │ • PR Comment │                       │
│                  └──────────────┘                       │
└─────────────────────────────────────────────────────────┘
```

---

## 🔧 Workflow Jobs

### 1. **Unit Tests** (`unit-tests`)

**Platform:** Ubuntu (latest)  
**Duration:** ~3-5 minutes

**Steps:**
1. Checkout code
2. Setup Flutter 3.24.x (stable)
3. Install dependencies
4. Generate mocks with `build_runner`
5. Run unit tests with coverage
6. Generate HTML coverage report
7. Upload coverage to Codecov
8. Check 60% coverage threshold

**Test Scope:**
- `test/blocs/` - BLoC unit tests
- `test/services/` - Service unit tests
- `test/data/` - Data layer unit tests

**Command:**
```bash
flutter test --coverage --reporter expanded \
  test/blocs/ test/services/ test/data/
```

### 2. **Widget Tests** (`widget-tests`)

**Platform:** Ubuntu (latest)  
**Duration:** ~2-4 minutes

**Steps:**
1. Checkout code
2. Setup Flutter
3. Install dependencies
4. Generate mocks
5. Run widget tests with coverage
6. Upload coverage to Codecov

**Test Scope:**
- `test/widgets/` - Widget and UI component tests

**Command:**
```bash
flutter test --coverage --reporter expanded test/widgets/
```

**Note:** Widget tests are allowed to fail (`continue-on-error: true`) as they're still being developed.

### 3. **Integration Tests** (`integration-tests`)

**Platform:** macOS (latest) - for iOS Simulator  
**Duration:** ~10-30 minutes

**Steps:**
1. Checkout code
2. Setup Flutter
3. Install dependencies
4. Generate mocks
5. Boot iOS Simulator (iPhone 14)
6. Run integration tests
7. Upload test results

**Test Scope:**
- `integration_test/` - End-to-end integration tests

**Command:**
```bash
flutter test integration_test/ --reporter expanded
```

**Note:** Integration tests are allowed to fail as they require a running backend.

### 4. **Analyze & Lint** (`analyze`)

**Platform:** Ubuntu (latest)  
**Duration:** ~1-2 minutes

**Steps:**
1. Checkout code
2. Setup Flutter
3. Install dependencies
4. Verify code formatting
5. Run Flutter analyzer
6. Check for deprecated APIs

**Commands:**
```bash
# Format check
dart format --set-exit-if-changed lib/ test/ integration_test/

# Analyze
flutter analyze --no-fatal-infos --no-fatal-warnings

# Deprecated API check
flutter analyze 2>&1 | grep -i "deprecated"
```

### 5. **Build Check** (`build-check`)

**Platform:** Ubuntu (latest)  
**Duration:** ~5-8 minutes

**Steps:**
1. Checkout code
2. Setup Flutter
3. Install dependencies
4. Build debug APK
5. Upload APK artifact (7-day retention)

**Command:**
```bash
flutter build apk --debug --no-shrink
```

**Artifact:** Debug APK available for download from Actions tab

### 6. **Security Scan** (`security`)

**Platform:** Ubuntu (latest)  
**Duration:** ~1-2 minutes

**Steps:**
1. Checkout code
2. Setup Flutter
3. Install dependencies
4. Check for outdated dependencies
5. Run dependency audit
6. Upload security reports

**Commands:**
```bash
# Check outdated
flutter pub outdated --no-dev-dependencies --json

# Audit dependencies
flutter pub audit
```

### 7. **Notify** (`notify`)

**Platform:** Ubuntu (latest)  
**Duration:** ~30 seconds

**Steps:**
1. Check all job statuses
2. Exit with error if unit tests, analyze, or build failed
3. Comment PR with results table

**PR Comment Example:**
```markdown
## 🧪 Flutter Test Results

| Job | Status |
|-----|--------|
| Unit Tests | ✅ success |
| Widget Tests | ⚠️ skipped |
| Integration Tests | ⚠️ skipped |
| Analyze & Lint | ✅ success |
| Build Check | ✅ success |
| Security Scan | ✅ success |
```

---

## 💻 Running Tests Locally

### Quick Start

Use the provided scripts for easy test execution:

#### 1. Run All Tests
```bash
./scripts/run_tests.sh --all --coverage
```

#### 2. Run Unit Tests Only
```bash
./scripts/run_tests.sh --unit --coverage
```

#### 3. Run Specific Test Types
```bash
# Unit + Widget tests
./scripts/run_tests.sh -u -w -c

# Integration tests only
./scripts/run_tests.sh --integration
```

#### 4. Clean + Test
```bash
./scripts/run_tests.sh --all --clean --coverage
```

### Generate Coverage Report

```bash
# Generate and view coverage
./scripts/generate_coverage.sh --open

# Just generate (no browser)
./scripts/generate_coverage.sh
```

### Clean Test Data

```bash
# Standard clean
./scripts/clean_test_data.sh

# Deep clean (includes build files)
./scripts/clean_test_data.sh --deep
```

### Manual Test Commands

```bash
# Generate mocks first
flutter pub run build_runner build --delete-conflicting-outputs

# Run specific test file
flutter test test/blocs/chat/chat_bloc_comprehensive_test.dart

# Run with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/

# Analyze code
flutter analyze

# Format code
dart format lib/ test/ integration_test/
```

---

## 🔐 GitHub Actions Setup

### Required Secrets

Add these secrets in your GitHub repository settings (`Settings > Secrets and variables > Actions`):

1. **CODECOV_TOKEN** (optional)
   - For uploading coverage to Codecov
   - Get from: https://codecov.io/
   - Not required but recommended for coverage tracking

### Workflow Triggers

The workflow runs on:

1. **Push to main/develop branches**
   ```yaml
   push:
     branches: [ main, develop ]
     paths:
       - 'musicbud_flutter/**'
   ```

2. **Pull requests to main/develop**
   ```yaml
   pull_request:
     branches: [ main, develop ]
     paths:
       - 'musicbud_flutter/**'
   ```

3. **Manual trigger**
   - Go to Actions tab
   - Select "Flutter Tests" workflow
   - Click "Run workflow"

### Path Filtering

The workflow only runs when changes are made to:
- `musicbud_flutter/**` - Any Flutter app files
- `.github/workflows/flutter-tests.yml` - Workflow file itself

This saves CI minutes and speeds up unrelated changes.

---

## 📊 Coverage Reports

### Viewing Coverage Locally

1. **Generate HTML report:**
   ```bash
   ./scripts/generate_coverage.sh --open
   ```

2. **Manual generation:**
   ```bash
   flutter test --coverage
   genhtml coverage/lcov.info -o coverage/html
   open coverage/html/index.html  # macOS
   xdg-open coverage/html/index.html  # Linux
   ```

### Coverage in CI/CD

Coverage is automatically:
1. **Generated** during unit and widget tests
2. **Uploaded** to Codecov (if token provided)
3. **Saved** as GitHub Actions artifacts (30-day retention)
4. **Checked** against 60% threshold

### Downloading Coverage from CI

1. Go to the Actions tab
2. Click on a workflow run
3. Scroll to "Artifacts" section
4. Download `unit-test-coverage` artifact

### Coverage Thresholds

| Type | Threshold | Status |
|------|-----------|--------|
| Overall | 60% | Required |
| Unit Tests | 80% | Goal |
| Widget Tests | 70% | Goal |
| Integration | N/A | Not measured |

---

## 🐛 Troubleshooting

### Common Issues

#### 1. **Mock Generation Fails**

**Error:** `Could not find a file named "*.mocks.dart"`

**Solution:**
```bash
# Delete conflicting outputs and regenerate
flutter pub run build_runner build --delete-conflicting-outputs

# Or clean first
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 2. **Coverage Below Threshold**

**Error:** `Coverage is below 60% threshold`

**Solution:**
- Add more test cases
- Remove untested code
- Check `coverage/html/index.html` to see what's not covered
- Use `./scripts/generate_coverage.sh --open` to view detailed report

#### 3. **Integration Tests Timeout**

**Error:** `TimeoutException after 0:05:00.000000`

**Solution:**
```dart
// Increase timeout in test
testWidgets('my test', (tester) async {
  // ...
}, timeout: Timeout(Duration(minutes: 10)));
```

Or in CI workflow:
```yaml
timeout-minutes: 30
```

#### 4. **Analyzer Errors**

**Error:** `flutter analyze` finds issues

**Solution:**
```bash
# Auto-fix formatting
dart format lib/ test/ integration_test/

# Check specific issues
flutter analyze --no-fatal-infos

# Suppress specific warnings (use sparingly)
// ignore: warning_type
```

#### 5. **Build Failures**

**Error:** Build APK fails

**Solution:**
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter build apk --debug

# Check for dependency conflicts
flutter pub outdated
```

### CI-Specific Issues

#### Workflow Not Triggering

Check:
1. Changes are in `musicbud_flutter/` directory
2. Branch is `main` or `develop`
3. Workflow file is valid YAML
4. Repository has Actions enabled

#### Jobs Stuck

- Cancel and re-run the workflow
- Check GitHub Actions status: https://www.githubstatus.com/

#### Artifacts Not Uploading

- Ensure path is correct in workflow
- Check file exists before upload
- Verify artifact name is unique

---

## ✅ Best Practices

### 1. **Write Tests Before Pushing**

```bash
# Quick pre-push check
./scripts/run_tests.sh --unit --coverage

# Full check (if time permits)
./scripts/run_tests.sh --all --coverage
```

### 2. **Keep Tests Fast**

- Mock external dependencies
- Use `setUp` and `tearDown` properly
- Avoid unnecessary `await` delays
- Use `pumpAndSettle` sparingly in widget tests

### 3. **Maintain Coverage**

```bash
# Check coverage before commit
./scripts/generate_coverage.sh

# Aim for 80%+ on new code
flutter test --coverage test/my_new_feature_test.dart
```

### 4. **Format and Analyze**

```bash
# Before committing
dart format lib/ test/ integration_test/
flutter analyze
```

### 5. **Monitor CI Health**

- Check Actions tab regularly
- Fix failing tests immediately
- Keep dependencies updated
- Review security scan results

### 6. **Use Pre-commit Hooks**

Create `.git/hooks/pre-commit`:
```bash
#!/bin/bash
flutter format lib/ test/ integration_test/
flutter analyze --no-fatal-infos
flutter test --no-sound-null-safety
```

Make it executable:
```bash
chmod +x .git/hooks/pre-commit
```

---

## 📚 Additional Resources

- **GitHub Actions Docs:** https://docs.github.com/en/actions
- **Flutter Testing:** https://flutter.dev/docs/testing
- **Codecov:** https://docs.codecov.com/docs
- **Flutter CI/CD:** https://flutter.dev/docs/deployment/cd

---

## 🎯 Success Metrics

### Pipeline Health Indicators

✅ **Healthy Pipeline:**
- All unit tests pass
- Coverage ≥ 60%
- Analyzer reports no errors
- Build succeeds
- Total duration < 15 minutes

⚠️ **Needs Attention:**
- Coverage 50-59%
- Analyzer warnings
- Build takes > 15 minutes
- Flaky tests

❌ **Critical Issues:**
- Unit tests failing
- Coverage < 50%
- Analyzer errors
- Build fails

---

**Last Updated:** 2025-01-14  
**Pipeline Version:** 1.0  
**Maintained By:** MusicBud Development Team
