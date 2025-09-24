# Image Picker Utils

This directory contains image picker utilities that work across all platforms (mobile, web, desktop) with proper error handling and namespace issue resolution.

## Files

- `unified_image_picker.dart` - Main unified image picker service
- `robust_image_picker.dart` - Robust image picker for mobile/desktop platforms
- `web_image_picker_fixed.dart` - Web-specific image picker with namespace fixes
- `web_image_picker.dart` - Alternative web image picker
- `image_picker_example.dart` - Example usage of the unified image picker

## Usage

### Basic Usage

```dart
import 'package:brother_admin_panel/utils/image/unified_image_picker.dart';
import 'package:image_picker/image_picker.dart';

// Pick a single image
final XFile? image = await UnifiedImagePicker.pickSingleImage(
  maxWidth: 800.0,
  maxHeight: 600.0,
  imageQuality: 85,
);

// Pick multiple images
final List<XFile> images = await UnifiedImagePicker.pickMultipleImages(
  maxWidth: 800.0,
  maxHeight: 600.0,
  imageQuality: 85,
);

// Take a photo (uses gallery on web)
final XFile? photo = await UnifiedImagePicker.takePhoto(
  maxWidth: 800.0,
  maxHeight: 600.0,
  imageQuality: 85,
);
```

### Error Handling

The unified image picker includes comprehensive error handling:

```dart
try {
  final XFile? image = await UnifiedImagePicker.pickSingleImage();
  if (image != null) {
    // Handle successful image selection
    print('Image selected: ${image.name}');
  }
} catch (e) {
  print('Error picking image: $e');
  // Handle error appropriately
}
```

### Platform Detection

```dart
// Check if image picker is available
final bool isAvailable = await UnifiedImagePicker.isImagePickerAvailable();

// Check if camera is available
final bool cameraAvailable = await UnifiedImagePicker.isCameraAvailable();

// Get platform information
final Map<String, dynamic> platformInfo = UnifiedImagePicker.getPlatformInfo();
```

## Features

- ✅ **Cross-platform support** - Works on mobile, web, and desktop
- ✅ **Namespace issue resolution** - Handles web namespace errors automatically
- ✅ **Fallback mechanisms** - Multiple fallback strategies for reliability
- ✅ **Comprehensive error handling** - Detailed error reporting and logging
- ✅ **Type safety** - Proper type conversions and null safety
- ✅ **Debug logging** - Detailed logging in debug mode
- ✅ **Arabic comments** - Full Arabic documentation

## Platform-Specific Behavior

### Web Platform
- Uses `WebImagePickerFixed` to avoid namespace issues
- Camera functionality redirects to gallery selection
- Automatic fallback to safe image picker methods

### Mobile/Desktop Platforms
- Uses `RobustImagePicker` with full feature support
- Native camera and gallery access
- Comprehensive error handling and fallback mechanisms

## Error Types Handled

- `UnsupportedError` - Namespace issues on web
- `PlatformException` - Platform-specific errors
- `FileSystemException` - File access errors
- Generic `Exception` - Other unexpected errors

## Debug Information

In debug mode, the image picker provides detailed logging:

```
🌐 Using web image picker for single image...
📁 File selected: image.jpg (123456 bytes)
✅ Image picked successfully: image.jpg
```

## Integration

To use in your app, simply import and use the `UnifiedImagePicker`:

```dart
import 'package:brother_admin_panel/utils/image/unified_image_picker.dart';

// Use anywhere in your app
final image = await UnifiedImagePicker.pickSingleImage();
```

The unified image picker automatically handles platform detection and uses the appropriate underlying implementation.
