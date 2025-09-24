import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:brother_admin_panel/utils/image/unified_image_picker.dart';

/// مثال على استخدام UnifiedImagePicker
/// Example of using UnifiedImagePicker
class ImagePickerExample extends StatefulWidget {
  const ImagePickerExample({Key? key}) : super(key: key);

  @override
  State<ImagePickerExample> createState() => _ImagePickerExampleState();
}

class _ImagePickerExampleState extends State<ImagePickerExample> {
  XFile? _selectedImage;
  List<XFile> _selectedImages = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Picker Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Single image picker
            ElevatedButton(
              onPressed: _isLoading ? null : _pickSingleImage,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Pick Single Image'),
            ),
            const SizedBox(height: 16),

            // Multiple images picker
            ElevatedButton(
              onPressed: _isLoading ? null : _pickMultipleImages,
              child: const Text('Pick Multiple Images'),
            ),
            const SizedBox(height: 16),

            // Camera picker
            ElevatedButton(
              onPressed: _isLoading ? null : _takePhoto,
              child: const Text('Take Photo'),
            ),
            const SizedBox(height: 16),

            // Display selected single image
            if (_selectedImage != null) ...[
              const Text('Selected Image:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Name: ${_selectedImage!.name}'),
              FutureBuilder<int>(
                future: _selectedImage!.length(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text('Size: ${snapshot.data} bytes');
                  }
                  return const Text('Size: calculating...');
                },
              ),
              const SizedBox(height: 16),
            ],

            // Display selected multiple images
            if (_selectedImages.isNotEmpty) ...[
              const Text('Selected Images:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ..._selectedImages.map((image) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: FutureBuilder<int>(
                      future: image.length(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                              '• ${image.name} (${snapshot.data} bytes)');
                        }
                        return Text('• ${image.name} (calculating size...)');
                      },
                    ),
                  )),
              const SizedBox(height: 16),
            ],

            // Platform info
            const Text('Platform Info:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...UnifiedImagePicker.getPlatformInfo()
                .entries
                .map((entry) => Text('${entry.key}: ${entry.value}')),
          ],
        ),
      ),
    );
  }

  Future<void> _pickSingleImage() async {
    setState(() => _isLoading = true);

    try {
      final XFile? image = await UnifiedImagePicker.pickSingleImage(
        maxWidth: 800.0,
        maxHeight: 600.0,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
          _selectedImages
              .clear(); // Clear multiple images when single is selected
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Image selected: ${image.name}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickMultipleImages() async {
    setState(() => _isLoading = true);

    try {
      final List<XFile> images = await UnifiedImagePicker.pickMultipleImages(
        maxWidth: 800.0,
        maxHeight: 600.0,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        setState(() {
          _selectedImages = images;
          _selectedImage =
              null; // Clear single image when multiple are selected
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${images.length} images selected')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking images: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _takePhoto() async {
    setState(() => _isLoading = true);

    try {
      final XFile? image = await UnifiedImagePicker.takePhoto(
        maxWidth: 800.0,
        maxHeight: 600.0,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
          _selectedImages
              .clear(); // Clear multiple images when single is selected
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Photo taken: ${image.name}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error taking photo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
