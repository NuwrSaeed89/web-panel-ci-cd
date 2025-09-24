import 'package:brother_admin_panel/data/models/project_model.dart';
import 'package:brother_admin_panel/data/repositories/project/project_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectController extends GetxController {
  static ProjectController get instance => Get.find();

  final _projectRepository = ProjectRepository.instance;

  final projects = <ProjectModel>[].obs;
  final filteredProjects = <ProjectModel>[].obs;
  final isLoading = false.obs;
  final selectedProject = Rx<ProjectModel?>(null);

  // متغيرات التصفية والبحث
  final searchController = TextEditingController();
  final selectedStatus = Rx<String>('all');
  final availableStatuses = <String>[
    'all',
    'pending',
    'planing',
    'process',
    'delevering'
  ];

  // الحالات المتاحة للمشروع
  final availableProjectStates = <String>[
    'pending',
    'inProgress',
    'completed',
    'cancelled'
  ];

  // Get translated status for display
  String getTranslatedStatus(String status) {
    switch (status) {
      case 'all':
        return 'all'.tr;
      case 'pending':
        return 'pending'.tr;
      case 'planing':
        return 'planing'.tr;
      case 'process':
        return 'process'.tr;
      case 'delevering':
        return 'delevering'.tr;
      case 'inProgress':
        return 'inProgress'.tr;
      case 'completed':
        return 'completed'.tr;
      case 'cancelled':
        return 'cancelled'.tr;
      default:
        return status;
    }
  }

  // Controllers for editing
  final currentStageController = TextEditingController();
  final costController = TextEditingController();
  final deadLineDateController = TextEditingController();
  final stateController = TextEditingController();

  // Date picker
  final selectedDeadlineDate = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchAllProjects();
    // إضافة مستمع للبحث
    searchController.addListener(_onSearchChanged);
  }

  @override
  void onClose() {
    searchController.dispose();
    currentStageController.dispose();
    costController.dispose();
    deadLineDateController.dispose();
    stateController.dispose();
    super.onClose();
  }

  // جلب جميع المشاريع
  Future<void> fetchAllProjects() async {
    try {
      isLoading.value = true;

      final projectList = await _projectRepository.fetchAllProjects();

      projects.value = projectList;
      await _filterProjects(); // تطبيق التصفية بعد جلب البيانات
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'failedToFetchProjects'.trParams({'error': e.toString()}),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // مستمع تغيير البحث
  void _onSearchChanged() {
    // لا نحتاج await هنا لأنها في مستمع، لكن نحتاج إلى معالجة الخطأ
    _filterProjects().catchError((error) {});
  }

  // تصفية المشاريع حسب البحث والحالة
  Future<void> _filterProjects() async {
    final searchQuery = searchController.text.toLowerCase().trim();
    final statusFilter = selectedStatus.value;

    // إذا كان البحث فارغاً، اعرض جميع المشاريع المصفاة حسب الحالة فقط
    if (searchQuery.isEmpty) {
      filteredProjects.value = projects.where((project) {
        return statusFilter == 'all' || project.state == statusFilter;
      }).toList();
      return;
    }

    // إذا كان هناك بحث، ابحث في البيانات المحلية فقط (بدون انتظار)
    final List<ProjectModel> searchResults = [];

    for (final project in projects) {
      // تصفية حسب الحالة أولاً
      if (statusFilter != 'all' && project.state != statusFilter) {
        continue;
      }

      bool matchesSearch = false;

      // البحث في اسم المشروع
      if (project.name.toLowerCase().contains(searchQuery)) {
        matchesSearch = true;
      }

      // البحث في تفاصيل المشروع
      if (project.description.toLowerCase().contains(searchQuery)) {
        matchesSearch = true;
      }

      if (matchesSearch) {
        searchResults.add(project);
      }
    }

    // إذا لم نجد نتائج في البيانات المحلية، ابحث في أسماء العملاء
    if (searchResults.isEmpty) {
      await _searchInClientNames(searchQuery, statusFilter);
    } else {
      filteredProjects.value = searchResults;
    }
  }

  // تغيير حالة التصفية
  Future<void> changeStatusFilter(String status) async {
    selectedStatus.value = status;
    await _filterProjects();
  }

  // مسح البحث
  Future<void> clearSearch() async {
    searchController.clear();
    await _filterProjects();
  }

  // البحث في أسماء العملاء
  Future<void> _searchInClientNames(String query, String statusFilter) async {
    filteredProjects.clear();

    final List<ProjectModel> searchResults = [];

    // البحث في أسماء العملاء بشكل متسلسل
    for (final project in projects) {
      // تصفية حسب الحالة أولاً
      if (statusFilter != 'all' && project.state != statusFilter) {
        continue;
      }

      // البحث في اسم العميل
      if (project.uId != null && project.uId!.isNotEmpty) {
        try {
          final userDetails =
              await _projectRepository.fetchUserDetailsById(project.uId!);
          final fullName = userDetails['fullName'] ?? '';

          if (fullName.toLowerCase().contains(query.toLowerCase())) {
            searchResults.add(project);
          }
        } catch (e) {
          if (kDebugMode) {
            print('❌ خطأ في البحث عن العميل: $e');
          }
        }
      }
    }

    // تحديث النتائج
    filteredProjects.value = searchResults;
    if (searchResults.isNotEmpty) {
    } else {}
  }

  // البحث المتقدم في اسم العميل (اختياري)
  Future<void> searchInClientNames(String query) async {
    if (query.isEmpty) return;

    final statusFilter = selectedStatus.value;
    final List<ProjectModel> searchResults = [];

    for (final project in projects) {
      // تصفية حسب الحالة أولاً
      if (statusFilter != 'all' && project.state != statusFilter) {
        continue;
      }

      // البحث في اسم العميل
      if (project.uId != null && project.uId!.isNotEmpty) {
        try {
          final userDetails =
              await _projectRepository.fetchUserDetailsById(project.uId!);
          final fullName = userDetails['fullName'] ?? '';
          if (fullName.toLowerCase().contains(query.toLowerCase())) {
            searchResults.add(project);
          }
        } catch (e) {
          // تجاهل الأخطاء في جلب تفاصيل العميل
        }
      }
    }

    if (searchResults.isNotEmpty) {
      filteredProjects.value = searchResults;
    }
  }

  // تحديد مشروع للعرض
  void selectProject(ProjectModel project) {
    selectedProject.value = project;
    // ملء الحقول للتحرير
    currentStageController.text = project.currentStage ?? '';
    costController.text = project.cost?.toString() ?? '0';
    deadLineDateController.text = project.deadLineDate?.toString() ?? '';
    stateController.text = project.state ?? '';
    selectedDeadlineDate.value = project.deadLineDate;
  }

  // تحديث المشروع
  Future<void> updateProject() async {
    try {
      if (selectedProject.value == null) return;

      final project = selectedProject.value!;

      // تحديث الحقول القابلة للتعديل فقط
      project.currentStage = currentStageController.text.trim();
      project.cost = double.tryParse(costController.text) ?? 0.0;
      project.deadLineDate = selectedDeadlineDate.value;
      project.state = stateController.text.trim();

      await _projectRepository.updateProject(project);

      // تحديث القائمة
      final index = projects.indexWhere((p) => p.id == project.id);
      if (index != -1) {
        projects[index] = project;
        projects.refresh();
        await _filterProjects(); // إعادة تطبيق التصفية
      }

      Get.snackbar(
        'success'.tr,
        'projectUpdatedSuccessfully'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // إعادة تعيين المشروع المحدد
      selectedProject.value = null;
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'failedToUpdateProject'.trParams({'error': e.toString()}),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // اختيار تاريخ جديد
  Future<void> selectDeadlineDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDeadlineDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      selectedDeadlineDate.value = picked;
      deadLineDateController.text = picked.toString().split(' ')[0];
    }
  }

  // إعادة تعيين النموذج
  void resetForm() {
    currentStageController.clear();
    costController.clear();
    deadLineDateController.clear();
    stateController.clear();
    selectedDeadlineDate.value = null;
    selectedProject.value = null;
  }
}
