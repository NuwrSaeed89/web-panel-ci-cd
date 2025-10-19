import 'dart:convert';
import 'package:flutter/material.dart';

/// ويدجت لعرض الصور الدائرية للفئات
class CircularImageDisplay extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final Color? borderColor;
  final double borderWidth;
  final Widget? placeholder;
  final BoxFit fit;

  const CircularImageDisplay({
    super.key,
    this.imageUrl,
    this.size = 100.0,
    this.borderColor,
    this.borderWidth = 2.0,
    this.placeholder,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: borderColor != null
            ? Border.all(color: borderColor!, width: borderWidth)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildPlaceholder();
    }

    if (imageUrl!.startsWith('http')) {
      // Network image
      return Image.network(
        imageUrl!,
        width: size,
        height: size,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildLoadingWidget();
        },
      );
    } else if (imageUrl!.startsWith('data:image')) {
      // Base64 image
      try {
        final base64String = imageUrl!.split(',')[1];
        final bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          width: size,
          height: size,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorWidget();
          },
        );
      } catch (e) {
        return _buildErrorWidget();
      }
    } else {
      // Default placeholder
      return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    return placeholder ??
        Container(
          width: size,
          height: size,
          color: Colors.grey.shade300,
          child: Icon(
            Icons.category,
            size: size * 0.4,
            color: Colors.grey.shade600,
          ),
        );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: size,
      height: size,
      color: Colors.grey.shade300,
      child: Icon(
        Icons.broken_image,
        size: size * 0.4,
        color: Colors.grey.shade600,
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      width: size,
      height: size,
      color: Colors.grey.shade300,
      child: Center(
        child: SizedBox(
          width: size * 0.3,
          height: size * 0.3,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}

/// ويدجت لعرض الصور الدائرية في قائمة الفئات
class CategoryImageListTile extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final String arabicName;
  final bool isFeature;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CategoryImageListTile({
    super.key,
    this.imageUrl,
    required this.name,
    required this.arabicName,
    this.isFeature = false,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircularImageDisplay(
          imageUrl: imageUrl,
          size: 60,
          borderColor: isFeature ? Colors.amber : Colors.blue,
          borderWidth: isFeature ? 3 : 2,
        ),
        title: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Color(0xFF111111),
          ),
        ),
        subtitle: Text(
          arabicName,
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isFeature)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'مميز',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    onEdit?.call();
                    break;
                  case 'delete':
                    onDelete?.call();
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text('تعديل'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text('حذف', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// ويدجت لعرض الصور الدائرية في شبكة
class CategoryImageGrid extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final Function(String)? onCategoryTap;
  final Function(String)? onCategoryEdit;
  final Function(String)? onCategoryDelete;

  const CategoryImageGrid({
    super.key,
    required this.categories,
    this.onCategoryTap,
    this.onCategoryEdit,
    this.onCategoryDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: () => onCategoryTap?.call(category['id'] ?? ''),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // الصورة الدائرية
                  CircularImageDisplay(
                    imageUrl: category['image'],
                    size: 80,
                    borderColor: category['isFeature'] == true
                        ? Colors.amber
                        : Colors.blue,
                    borderWidth: category['isFeature'] == true ? 3 : 2,
                  ),

                  const SizedBox(height: 12),

                  // اسم الفئة بالإنجليزية
                  Text(
                    category['name'] ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : Color(0xFF111111),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // اسم الفئة بالعربية
                  Text(
                    category['arabicName'] ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // شارة مميز
                  if (category['isFeature'] == true)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'مميز',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
