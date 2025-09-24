class UploadResult {
  final String fileUrl;
  final List<String> tags;
  final bool success;
  final String? errorMessage;

  UploadResult({
    required this.fileUrl,
    this.tags = const [],
    this.success = true,
    this.errorMessage,
  });

  factory UploadResult.fromJson(Map<String, dynamic> json) {
    return UploadResult(
      fileUrl: json['original_file'] ?? json['fileUrl'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      success: json['success'] ?? true,
      errorMessage: json['error'] ?? json['errorMessage'],
    );
  }

  factory UploadResult.error(String message) {
    return UploadResult(
      fileUrl: '',
      tags: [],
      success: false,
      errorMessage: message,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileUrl': fileUrl,
      'tags': tags,
      'success': success,
      'errorMessage': errorMessage,
    };
  }
}
