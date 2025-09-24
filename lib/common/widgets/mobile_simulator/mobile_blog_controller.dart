import 'package:get/get.dart';

class MobileBlogModel {
  final String id;
  final String title;
  final String arabicTitle;
  final String details;
  final String arabicDetails;
  final String author;
  final String arabicAuthor;
  final String? thumbnail;
  final DateTime? createdAt;

  MobileBlogModel({
    required this.id,
    required this.title,
    required this.arabicTitle,
    required this.details,
    required this.arabicDetails,
    required this.author,
    required this.arabicAuthor,
    this.thumbnail,
    this.createdAt,
  });
}

class MobileBlogController extends GetxController {
  static MobileBlogController get instance => Get.find();

  final RxList<MobileBlogModel> blogs = <MobileBlogModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadBlogs();
  }

  Future<void> loadBlogs() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    blogs.value = _getMockBlogs();
    isLoading.value = false;
  }

  List<MobileBlogModel> _getMockBlogs() {
    return [
      MobileBlogModel(
        id: "1",
        title: "The Future of Web Development",
        arabicTitle: "مستقبل تطوير الويب",
        details: "Exploring the latest trends in web development that will shape the future of the internet.",
        arabicDetails: "استكشاف أحدث الاتجاهات والتقنيات في تطوير الويب التي ستشكل مستقبل الإنترنت.",
        author: "John Doe",
        arabicAuthor: "جون دو",
        thumbnail: "https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=400&h=200&fit=crop",
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      MobileBlogModel(
        id: "2",
        title: "Mobile App Design Trends 2024",
        arabicTitle: "اتجاهات تصميم تطبيقات الموبايل 2024",
        details: "Discover the most popular design trends that will dominate mobile app development in 2024.",
        arabicDetails: "اكتشف أكثر اتجاهات التصميم شيوعاً التي ستسيطر على تطوير تطبيقات الموبايل في 2024.",
        author: "Jane Smith",
        arabicAuthor: "جين سميث",
        thumbnail: "https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=400&h=200&fit=crop",
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      MobileBlogModel(
        id: "3",
        title: "AI and Machine Learning in Business",
        arabicTitle: "الذكاء الاصطناعي والتعلم الآلي في الأعمال",
        details: "How artificial intelligence and machine learning are revolutionizing business operations.",
        arabicDetails: "كيف يحدث الذكاء الاصطناعي والتعلم الآلي ثورة في عمليات الأعمال واتخاذ القرارات.",
        author: "Mike Johnson",
        arabicAuthor: "مايك جونسون",
        thumbnail: "https://images.unsplash.com/photo-1677442136019-21780ecad995?w=400&h=200&fit=crop",
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      MobileBlogModel(
        id: "4",
        title: "Sustainable Technology Solutions",
        arabicTitle: "حلول التكنولوجيا المستدامة",
        details: "Exploring eco-friendly technology solutions that help reduce environmental impact.",
        arabicDetails: "استكشاف حلول التكنولوجيا الصديقة للبيئة التي تساعد في تقليل التأثير البيئي.",
        author: "Sarah Wilson",
        arabicAuthor: "سارة ويلسون",
        thumbnail: "https://images.unsplash.com/photo-1497435334941-8c899ee9e8e9?w=400&h=200&fit=crop",
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];
  }
}
