# Testing — GridPulse

## Strategy

### Unit Tests
- **Services**: API response decoding, error handling, cache TTL logic
- **ViewModels**: Loading states, data flow, error propagation
- **Models**: SwiftData CRUD operations

### UI Tests
- Navigation between tabs
- Pull-to-refresh
- Data display (standings, schedule, results)

### Integration Tests
- Offline-first behavior (cache → network → expired cache)
- API error fallback

## Running Tests

```bash
# All tests
xcodebuild test -project GridPulse.xcodeproj -scheme GridPulse-Tests -destination 'platform=iOS Simulator,name=iPhone 17'

# Unit tests only
xcodebuild test -project GridPulse.xcodeproj -scheme GridPulse-Tests -destination 'platform=iOS Simulator,name=iPhone 17' -only-testing:GridPulseTests/UnitTests

# UI tests only
xcodebuild test -project GridPulse.xcodeproj -scheme GridPulse-Tests -destination 'platform=iOS Simulator,name=iPhone 17' -only-testing:GridPulseTests/UITests
```

## CI (Xcode Cloud)

Xcode Cloud runs `ci_scripts/ci_post_clone.sh` which:
1. Installs SwiftLint & SwiftFormat
2. Lints all Swift files
3. Formats check

See `ci_scripts/ci_post_clone.sh` for details.

## Coverage Requirements

- **Services**: 80%+ (network calls mocked)
- **ViewModels**: 70%+ (async testing)
- **Models**: 60%+ (SwiftData operations)
- **Overall**: 70%+ target