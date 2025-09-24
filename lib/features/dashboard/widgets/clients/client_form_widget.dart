import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/utils/styles/text_styles.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/clients_controller.dart';
import 'package:brother_admin_panel/services/client_image_service.dart';
import 'package:image_picker/image_picker.dart';

class ClientFormWidget extends StatefulWidget {
  final ClientsController controller;
  final bool isDark;

  const ClientFormWidget({
    super.key,
    required this.controller,
    required this.isDark,
  });

  @override
  State<ClientFormWidget> createState() => _ClientFormWidgetState();
}

class _ClientFormWidgetState extends State<ClientFormWidget> {
  late TextEditingController nameController;
  late TextEditingController arabicNameController;
  late TextEditingController textController;
  late TextEditingController arabicTextController;
  late TextEditingController thumbnailController;
  late bool isFeature;
  late bool showPhoto;
  String? _selectedImageUrl;
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers and state
    nameController = TextEditingController(
        text: widget.controller.selectedClient?.name ?? '');
    arabicNameController = TextEditingController(
        text: widget.controller.selectedClient?.arabicName ?? '');
    textController = TextEditingController(
        text: widget.controller.selectedClient?.text ?? '');
    arabicTextController = TextEditingController(
        text: widget.controller.selectedClient?.arabicText ?? '');
    thumbnailController = TextEditingController(
        text: widget.controller.selectedClient?.thumbnail ?? '');
    isFeature = widget.controller.selectedClient?.isFeature ?? false;
    showPhoto = widget.controller.selectedClient?.showPhoto ?? false;
    _selectedImageUrl = widget.controller.selectedClient?.thumbnail;
  }

  @override
  void dispose() {
    nameController.dispose();
    arabicNameController.dispose();
    textController.dispose();
    arabicTextController.dispose();
    thumbnailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),
          const SizedBox(height: 24),

          // Form fields
          _buildFormFields(
            nameController,
            arabicNameController,
            textController,
            arabicTextController,
            thumbnailController,
            isFeature,
            showPhoto,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: widget.controller.hideForm,
          icon: const Icon(Icons.arrow_back),
          tooltip: 'العودة',
        ),
        const SizedBox(width: 16),
        Text(
          widget.controller.isEditMode ? 'تعديل الزبون' : 'إضافة زبون جديد',
          style: TTextStyles.heading2.copyWith(
            color: widget.isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields(
    TextEditingController nameController,
    TextEditingController arabicNameController,
    TextEditingController textController,
    TextEditingController arabicTextController,
    TextEditingController thumbnailController,
    bool isFeature,
    bool showPhoto,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: widget.isDark ? Colors.grey.shade900 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isDark ? Colors.grey.shade600 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Client Name Fields
          _buildNameFields(nameController, arabicNameController),
          const SizedBox(height: 16),

          // Client Description Fields
          _buildDescriptionFields(textController, arabicTextController),
          const SizedBox(height: 16),

          // Image Selection
          _buildImageSelectionField(),
          const SizedBox(height: 16),

          // Toggle switches
          _buildToggleSwitches(),
          const SizedBox(height: 24),

          // Action buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildNameFields(
    TextEditingController nameController,
    TextEditingController arabicNameController,
  ) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'اسم الزبون (إنجليزي)',
              hintText: 'أدخل اسم الزبون بالإنجليزية',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: widget.isDark ? Colors.white10 : Colors.white,
            ),
            style: TextStyle(
              color: widget.isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: arabicNameController,
            decoration: InputDecoration(
              labelText: 'اسم الزبون (عربي)',
              hintText: 'أدخل اسم الزبون بالعربية',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: widget.isDark ? Colors.white10 : Colors.white,
            ),
            style: TextStyle(
              color: widget.isDark ? Colors.white : Colors.black87,
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionFields(
    TextEditingController textController,
    TextEditingController arabicTextController,
  ) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: textController,
            decoration: InputDecoration(
              labelText: 'وصف الزبون (إنجليزي)',
              hintText: 'أدخل وصف الزبون بالإنجليزية',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: widget.isDark ? Colors.white10 : Colors.white,
            ),
            style: TextStyle(
              color: widget.isDark ? Colors.white : Colors.black87,
            ),
            maxLines: 3,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: arabicTextController,
            decoration: InputDecoration(
              labelText: 'وصف الزبون (عربي)',
              hintText: 'أدخل وصف الزبون بالعربية',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: widget.isDark ? Colors.white10 : Colors.white,
            ),
            style: TextStyle(
              color: widget.isDark ? Colors.white : Colors.black87,
            ),
            textDirection: TextDirection.rtl,
            maxLines: 3,
          ),
        ),
      ],
    );
  }

  Widget _buildImageSelectionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'صورة الزبون',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: widget.isDark ? Colors.white : Colors.black87,
            fontFamily: 'IBM Plex Sans Arabic',
          ),
        ),
        const SizedBox(height: 12),

        // Image Preview and Selection
        Container(
          width: double.infinity,
          height: 250, // زيادة الارتفاع قليلاً لعرض أفضل
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  widget.isDark ? Colors.grey.shade600 : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _selectedImageUrl != null && _selectedImageUrl!.isNotEmpty
              ? Stack(
                  children: [
                    // Image Preview with background
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: widget.isDark
                            ? Colors.grey.shade800
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          _selectedImageUrl!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.contain, // عرض الصورة كاملة
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade300,
                              child: const Icon(
                                Icons.error,
                                size: 50,
                                color: Colors.red,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Loading overlay
                    if (_isUploadingImage)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),

                    // Action buttons
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Change image button
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IconButton(
                              onPressed: _isUploadingImage ? null : _pickImage,
                              icon: const Icon(Icons.edit, size: 16),
                              tooltip: 'تغيير الصورة',
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Remove image button
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IconButton(
                              onPressed:
                                  _isUploadingImage ? null : _removeImage,
                              icon: const Icon(Icons.close, size: 16),
                              tooltip: 'إزالة الصورة',
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : _buildImagePlaceholder(),
        ),

        const SizedBox(height: 12),

        // Image selection buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isUploadingImage ? null : _pickImage,
                icon: const Icon(Icons.photo_camera),
                label: const Text(
                  'اختيار صورة',
                  style: TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isUploadingImage ? null : _pickImageFromGallery,
                icon: const Icon(Icons.photo_library),
                label: const Text(
                  'من المعرض',
                  style: TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: widget.isDark ? Colors.grey.shade800 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image,
            size: 50,
            color: widget.isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
          const SizedBox(height: 8),
          Text(
            'لم يتم اختيار صورة',
            style: TextStyle(
              color:
                  widget.isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              fontFamily: 'IBM Plex Sans Arabic',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleSwitches() {
    return Row(
      children: [
        Expanded(
          child: SwitchListTile(
            title: Text(
              'زبون مميز',
              style: TextStyle(
                color: widget.isDark ? Colors.white : Colors.black87,
                fontFamily: 'IBM Plex Sans Arabic',
              ),
            ),
            subtitle: Text(
              'عرض الزبون كزبون مميز',
              style: TextStyle(
                color: widget.isDark ? Colors.white70 : Colors.black54,
                fontFamily: 'IBM Plex Sans Arabic',
              ),
            ),
            value: isFeature,
            onChanged: (value) {
              setState(() {
                isFeature = value;
              });
            },
            activeColor: Colors.orange,
          ),
        ),
        const SizedBox(
          width: 50,
        ),
        Expanded(
          child: SwitchListTile(
            title: Text(
              'عرض الصورة',
              style: TextStyle(
                color: widget.isDark ? Colors.white : Colors.black87,
                fontFamily: 'IBM Plex Sans Arabic',
              ),
            ),
            subtitle: Text(
              'عرض صورة الزبون',
              style: TextStyle(
                color: widget.isDark ? Colors.white70 : Colors.black54,
                fontFamily: 'IBM Plex Sans Arabic',
              ),
            ),
            value: showPhoto,
            onChanged: (value) {
              setState(() {
                showPhoto = value;
              });
            },
            activeColor: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: widget.controller.hideForm,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(
                    color:
                        widget.isDark ? Colors.white54 : Colors.grey.shade400,
                  ),
                ),
                child: Text(
                  'إلغاء',
                  style: TextStyle(
                    color: widget.isDark ? Colors.white : Colors.black87,
                    fontFamily: 'IBM Plex Sans Arabic',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: widget.controller.isLoading ? null : _saveClient,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0055ff),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: widget.controller.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        widget.controller.isEditMode
                            ? 'حفظ التعديلات'
                            : 'إضافة الزبون',
                        style:
                            const TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
                      ),
              ),
            ),
          ],
        ),
        // Delete button (only show in edit mode)
        if (widget.controller.isEditMode &&
            widget.controller.selectedClient?.id != null) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: widget.controller.isLoading ? null : _showDeleteDialog,
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text(
                'حذف الزبون',
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'IBM Plex Sans Arabic',
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.red),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _saveClient() async {
    // Validate required fields
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'خطأ',
        'يرجى إدخال اسم الزبون بالإنجليزية',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (arabicNameController.text.trim().isEmpty) {
      Get.snackbar(
        'خطأ',
        'يرجى إدخال اسم الزبون بالعربية',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_selectedImageUrl == null || _selectedImageUrl!.isEmpty) {
      Get.snackbar(
        'خطأ',
        'يرجى اختيار صورة للزبون',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Save the client
    await widget.controller.saveClient(
      name: nameController.text,
      arabicName: arabicNameController.text,
      text: textController.text,
      arabicText: arabicTextController.text,
      thumbnail: _selectedImageUrl!,
      isFeature: isFeature,
      showPhoto: showPhoto,
    );
  }

  // اختيار صورة من الكاميرا أو المعرض
  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();

      // عرض خيارات اختيار الصورة
      final source = await Get.dialog<ImageSource>(
        AlertDialog(
          title: const Text(
            'اختر مصدر الصورة',
            style: TextStyle(
              fontFamily: 'IBM Plex Sans Arabic',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text(
                  'الكاميرا',
                  style: TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
                ),
                onTap: () => Get.back(result: ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text(
                  'المعرض',
                  style: TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
                ),
                onTap: () => Get.back(result: ImageSource.gallery),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: Get.back,
              child: const Text(
                'إلغاء',
                style: TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
              ),
            ),
          ],
        ),
      );

      if (source == null) return;

      // اختيار الصورة
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null) return;

      // رفع الصورة
      await _uploadImage(image);
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في اختيار الصورة: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // اختيار صورة من المعرض مباشرة
  Future<void> _pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null) return;

      // رفع الصورة
      await _uploadImage(image);
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في اختيار الصورة: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // رفع الصورة إلى Firebase Storage
  Future<void> _uploadImage(XFile image) async {
    try {
      setState(() {
        _isUploadingImage = true;
      });

      // رفع الصورة إلى Firebase Storage
      final imageUrl = await ClientImageService.uploadClientImageFromXFile(
        xFile: image,
      );

      setState(() {
        _selectedImageUrl = imageUrl;
        thumbnailController.text = imageUrl;
        _isUploadingImage = false;
      });

      Get.snackbar(
        'نجح',
        'تم رفع الصورة بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      setState(() {
        _isUploadingImage = false;
      });

      Get.snackbar(
        'خطأ',
        'فشل في رفع الصورة: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // إزالة الصورة المختارة
  void _removeImage() {
    setState(() {
      _selectedImageUrl = null;
      thumbnailController.clear();
    });
  }

  // عرض نافذة تأكيد الحذف
  void _showDeleteDialog() {
    final client = widget.controller.selectedClient!;

    Get.dialog(
      AlertDialog(
        title: const Text(
          'تأكيد الحذف',
          style: TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'هل أنت متأكد من حذف هذا الزبون؟',
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'اسم الزبون: ${client.arabicName?.isNotEmpty == true ? client.arabicName! : client.name ?? 'غير محدد'}',
              style: const TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'تحذير: لا يمكن التراجع عن هذا الإجراء!',
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: 12,
                color: Colors.orange,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'إلغاء',
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                color: Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back(); // إغلاق النافذة أولاً
              await widget.controller.deleteClient(client.id!);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'حذف',
              style: TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
            ),
          ),
        ],
      ),
    );
  }
}
