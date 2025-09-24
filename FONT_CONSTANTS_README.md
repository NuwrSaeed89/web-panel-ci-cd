# Font Constants Guide

## Overview
This project now uses centralized font constants to make it easy to change fonts across the entire application from a single location.

## File Location
```
lib/utils/constants/font_constants.dart
```

## Available Constants

### Font Families
```dart
// Primary Font - Arabic Support
FontConstants.primaryFont        // 'IBM Plex Sans Arabic'

// Secondary Font - English Support  
FontConstants.secondaryFont      // 'Urbanist'

// Fallback Font
FontConstants.fallbackFont       // 'Roboto'
```

### Font Weights
```dart
FontConstants.light         // FontWeight.w300
FontConstants.regular       // FontWeight.w400
FontConstants.medium        // FontWeight.w500
FontConstants.semiBold      // FontWeight.w600
FontConstants.bold          // FontWeight.w700
FontConstants.extraBold     // FontWeight.w800
```

### Font Sizes
```dart
FontConstants.xs            // 12.0
FontConstants.sm            // 14.0
FontConstants.base          // 16.0
FontConstants.lg            // 18.0
FontConstants.xl            // 20.0
FontConstants.xl2           // 24.0
FontConstants.xl3           // 30.0
FontConstants.xl4           // 36.0
FontConstants.xl5           // 48.0
FontConstants.xl6           // 60.0
```

## Usage Examples

### Before (Hardcoded)
```dart
Text(
  'Hello World',
  style: TextStyle(
    fontFamily: 'IBM Plex Sans Arabic',
    fontSize: 16,
    fontWeight: FontWeight.w500,
  ),
)
```

### After (Using Constants)
```dart
import 'package:brother_admin_panel/utils/constants/font_constants.dart';

Text(
  'Hello World',
  style: TextStyle(
    fontFamily: FontConstants.primaryFont,
    fontSize: FontConstants.base,
    fontWeight: FontConstants.medium,
  ),
)
```

## How to Change Fonts Globally

### Step 1: Update the Constant
Edit `lib/utils/constants/font_constants.dart`:

```dart
class FontConstants {
  // Change this line to use a different font
  static const String primaryFont = 'Your New Font Name';
  
  // Or add a new font family
  static const String customFont = 'Custom Font Name';
}
```

### Step 2: The Change Applies Everywhere
All files using `FontConstants.primaryFont` will automatically use the new font without needing to edit each file individually.

## Benefits

✅ **Centralized Control**: Change fonts from one location
✅ **Consistency**: All text uses the same font definitions
✅ **Maintainability**: No need to search and replace across multiple files
✅ **Flexibility**: Easy to add new font families or weights
✅ **Type Safety**: Compile-time checking for font constants

## Files Already Updated

The following files have been updated to use the new font constants:

- ✅ `lib/features/dashboard/screens/projects_screen.dart`
- ✅ `lib/features/dashboard/screens/projects_tracker_screen.dart`
- ✅ `lib/features/dashboard/screens/project_detail_screen.dart`
- ✅ `lib/features/dashboard/widgets/project_state_selector.dart`
- ✅ `lib/features/dashboard/widgets/project_stage_flow.dart`
- ✅ `lib/features/dashboard/screens/prices_request_screen.dart`
- ✅ `lib/features/dashboard/screens/price_request_detail_screen.dart`

## Migration Complete! 🎉

All files have been successfully migrated to use the centralized font constants. The project now has a unified font management system.

## Import Statement

Add this import to any file where you want to use font constants:

```dart
import 'package:brother_admin_panel/utils/constants/font_constants.dart';
```

Or use the global export from:

```dart
import 'package:brother_admin_panel/utils/index.dart';
```
