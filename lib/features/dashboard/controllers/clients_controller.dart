import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/data/models/clients_model.dart';
import 'package:brother_admin_panel/data/repositories/clients/clients_repository.dart';
import 'package:brother_admin_panel/services/client_image_service.dart';
import 'package:image_picker/image_picker.dart';

class ClientsController extends GetxController {
  static ClientsController get instance => Get.find();

  final ClientsRepository _clientsRepository = Get.find();

  // Observable variables
  final RxList<ClientModel> _clients = <ClientModel>[].obs;
  final RxList<ClientModel> _filteredClients = <ClientModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _searchQuery = ''.obs;
  final Rx<ClientModel?> _selectedClient = Rx<ClientModel?>(null);
  final RxBool _isFormMode = false.obs;
  final RxBool _isEditMode = false.obs;
  final RxBool _isUploadingImage = false.obs;

  // Getters
  List<ClientModel> get clients => _clients;
  List<ClientModel> get filteredClients => _filteredClients;
  bool get isLoading => _isLoading.value;
  String get searchQuery => _searchQuery.value;
  ClientModel? get selectedClient => _selectedClient.value;
  bool get isFormMode => _isFormMode.value;
  bool get isEditMode => _isEditMode.value;
  bool get isUploadingImage => _isUploadingImage.value;

  @override
  void onInit() {
    super.onInit();
    loadClients();
  }

  // Load all clients
  Future<void> loadClients() async {
    try {
      _isLoading.value = true;
      final clientsList = await _clientsRepository.getAllClients();
      _clients.value = clientsList;
      _filteredClients.value = clientsList;
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في تحميل الزبائن: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Search clients
  void searchClients(String query) {
    _searchQuery.value = query;
    if (query.isEmpty) {
      _filteredClients.value = _clients;
    } else {
      _filteredClients.value = _clients.where((client) {
        final searchLower = query.toLowerCase();
        return (client.name?.toLowerCase().contains(searchLower) ?? false) ||
            (client.arabicName?.toLowerCase().contains(searchLower) ?? false) ||
            (client.text?.toLowerCase().contains(searchLower) ?? false) ||
            (client.arabicText?.toLowerCase().contains(searchLower) ?? false);
      }).toList();
    }
  }

  // Clear search
  void clearSearch() {
    _searchQuery.value = '';
    _filteredClients.value = _clients;
  }

  // Show add form
  void showAddForm() {
    _selectedClient.value = null;
    _isEditMode.value = false;
    _isFormMode.value = true;
  }

  // Show edit form
  void showEditForm(ClientModel client) {
    _selectedClient.value = client;
    _isEditMode.value = true;
    _isFormMode.value = true;
  }

  // Hide form
  void hideForm() {
    _isFormMode.value = false;
    _isEditMode.value = false;
    _selectedClient.value = null;
  }

  // Refresh data
  Future<void> refreshData() async {
    await loadClients();
  }

  // Save client (create or update)
  Future<bool> saveClient({
    required String name,
    required String arabicName,
    required String text,
    required String arabicText,
    required String thumbnail,
    required bool isFeature,
    required bool showPhoto,
  }) async {
    try {
      _isLoading.value = true;

      final clientData = ClientModel(
        id: _isEditMode.value ? _selectedClient.value?.id : null,
        name: name.trim(),
        arabicName: arabicName.trim(),
        text: text.trim(),
        arabicText: arabicText.trim(),
        thumbnail: thumbnail.trim(),
        isFeature: isFeature,
        showPhoto: showPhoto,
        images: _selectedClient.value?.images ?? [],
      );

      if (_isEditMode.value && _selectedClient.value?.id != null) {
        // Update existing client
        await _clientsRepository.updateClient(
          _selectedClient.value!.id!,
          clientData,
        );

        // Update local data
        final index = _clients.indexWhere(
          (client) => client.id == _selectedClient.value!.id,
        );
        if (index != -1) {
          _clients[index] = clientData;
          _filteredClients.value = _clients;
        }

        Get.snackbar(
          'نجح',
          'تم تحديث الزبون بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        // Create new client
        final newId = await _clientsRepository.createClient(clientData);

        // Add to local data
        final newClient = ClientModel(
          id: newId,
          name: clientData.name,
          arabicName: clientData.arabicName,
          text: clientData.text,
          arabicText: clientData.arabicText,
          thumbnail: clientData.thumbnail,
          isFeature: clientData.isFeature,
          showPhoto: clientData.showPhoto,
          images: clientData.images,
        );

        _clients.add(newClient);
        _filteredClients.value = _clients;

        Get.snackbar(
          'نجح',
          'تم إضافة الزبون بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }

      hideForm();
      return true;
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في حفظ الزبون: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // تحديث صورة الزبون
  Future<bool> updateClientImage(String clientId, String newImageUrl) async {
    try {
      _isUploadingImage.value = true;

      // العثور على الزبون في القائمة المحلية
      final clientIndex =
          _clients.indexWhere((client) => client.id == clientId);
      if (clientIndex == -1) {
        throw Exception('Client not found');
      }

      final client = _clients[clientIndex];

      // إنشاء نسخة محدثة من الزبون مع الصورة الجديدة
      final updatedClient = ClientModel(
        id: client.id,
        name: client.name,
        arabicName: client.arabicName,
        text: client.text,
        arabicText: client.arabicText,
        thumbnail: newImageUrl,
        isFeature: client.isFeature,
        showPhoto: client.showPhoto,
        images: client.images,
      );

      // تحديث الزبون في Firebase
      await _clientsRepository.updateClient(clientId, updatedClient);

      // تحديث القائمة المحلية
      _clients[clientIndex] = updatedClient;
      _filteredClients.value = _clients;

      // تحديث الزبون المختار إذا كان هو نفسه
      if (_selectedClient.value?.id == clientId) {
        _selectedClient.value = updatedClient;
      }

      Get.snackbar(
        'نجح',
        'تم تحديث صورة الزبون بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في تحديث صورة الزبون: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      _isUploadingImage.value = false;
    }
  }

  // اختيار صورة من المعرض أو الكاميرا
  Future<void> pickAndUploadImage(String clientId) async {
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

      // رفع الصورة إلى Firebase Storage
      final imageUrl = await ClientImageService.uploadClientImageFromXFile(
        xFile: image,
      );

      // تحديث صورة الزبون
      await updateClientImage(clientId, imageUrl);
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في اختيار أو رفع الصورة: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // حذف الزبون
  Future<bool> deleteClient(String clientId) async {
    try {
      _isLoading.value = true;

      // حذف الزبون من Firebase
      await _clientsRepository.deleteClient(clientId);

      // حذف الصورة من Firebase Storage إذا كانت موجودة
      final clientIndex =
          _clients.indexWhere((client) => client.id == clientId);
      if (clientIndex != -1) {
        final client = _clients[clientIndex];
        if (client.thumbnail.isNotEmpty &&
            client.thumbnail.startsWith('http')) {
          try {
            await ClientImageService.deleteClientImage(client.thumbnail);
          } catch (e) {
            // تجاهل خطأ حذف الصورة إذا لم تكن موجودة
            if (kDebugMode) {
              print('⚠️ Could not delete image: $e');
            }
          }
        }
      }

      // حذف من القائمة المحلية
      _clients.removeWhere((client) => client.id == clientId);
      _filteredClients.value = _clients;

      // إغلاق النموذج إذا كان الزبون المحذوف هو المختار
      if (_selectedClient.value?.id == clientId) {
        hideForm();
      }

      Get.snackbar(
        'نجح',
        'تم حذف الزبون بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في حذف الزبون: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }
}
