import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/data/models/brand_model.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/brand_controller.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';
import 'package:brother_admin_panel/utils/styles/text_styles.dart';

class BrandDropdown extends StatefulWidget {
  final String? selectedBrandId;
  final ValueChanged<String?> onBrandChanged;
  final String? labelText;
  final String? hintText;
  final bool isRequired;
  final bool showSearch;
  final bool enabled;
  final String? errorText;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? border;
  final Color? dropdownColor;
  final double? menuMaxHeight;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const BrandDropdown({
    super.key,
    this.selectedBrandId,
    required this.onBrandChanged,
    this.labelText,
    this.hintText,
    this.isRequired = false,
    this.showSearch = true,
    this.enabled = true,
    this.errorText,
    this.contentPadding,
    this.border,
    this.dropdownColor,
    this.menuMaxHeight,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  State<BrandDropdown> createState() => _BrandDropdownState();
}

class _BrandDropdownState extends State<BrandDropdown> {
  BrandController? _brandController;
  List<BrandModel> _brands = [];
  bool _isLoading = false;
  String? _selectedBrandId;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedBrandId = widget.selectedBrandId;
    _initializeController();
  }

  @override
  void didUpdateWidget(BrandDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedBrandId != widget.selectedBrandId) {
      _selectedBrandId = widget.selectedBrandId;
    }
  }

  void _initializeController() {
    try {
      _brandController = Get.find<BrandController>();
      _loadBrands();
    } catch (e) {
      // Controller not found, create a temporary one
      _brandController = BrandController();
      _loadBrands();
    }
  }

  Future<void> _loadBrands() async {
    if (_brandController == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _brandController!.loadBrands();
      setState(() {
        _brands = _brandController!.brands;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<BrandModel> get _filteredBrands {
    if (_searchQuery.isEmpty) {
      return _brands;
    }
    return _brands.where((brand) {
      return brand.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          brand.id.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  // تم إزالة هذه الدالة لأنها غير مستخدمة

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        final isDark = themeController.isDarkMode;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.labelText != null) ...[
              Row(
                children: [
                  Text(
                    widget.labelText!,
                    style: TTextStyles.bodyMedium.copyWith(
                      color: isDark ? Colors.white : Color(0xFF111111),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (widget.isRequired)
                    const Text(
                      ' *',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            DropdownButtonFormField<String>(
              value: _selectedBrandId,
              onChanged: widget.enabled
                  ? (String? newValue) {
                      setState(() {
                        _selectedBrandId = newValue;
                      });
                      widget.onBrandChanged(newValue);
                    }
                  : null,
              decoration: InputDecoration(
                hintText: widget.hintText ?? 'اختر الماركة',
                prefixIcon: widget.prefixIcon ??
                    Icon(
                      Icons.branding_watermark,
                      color: isDark ? TColors.primary : Colors.blue,
                    ),
                suffixIcon: widget.suffixIcon ??
                    (_isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : const Icon(Icons.arrow_drop_down)),
                contentPadding: widget.contentPadding ??
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: widget.border ??
                    OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark ? Colors.white24 : Colors.grey.shade400,
                      ),
                    ),
                enabledBorder: widget.border ??
                    OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark ? Colors.white24 : Colors.grey.shade400,
                      ),
                    ),
                focusedBorder: widget.border ??
                    OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark ? TColors.primary : Colors.blue,
                        width: 2,
                      ),
                    ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: isDark ? Colors.black12 : Colors.white,
                errorText: widget.errorText,
              ),
              dropdownColor: widget.dropdownColor ??
                  (isDark ? const Color(0xFF1a1a2e) : Colors.white),
              menuMaxHeight: widget.menuMaxHeight ?? 300,
              isExpanded: true,
              items: _buildDropdownItems(isDark),
              selectedItemBuilder: (context) {
                return _filteredBrands.map((brand) {
                  return Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      brand.name,
                      style: TTextStyles.bodyMedium.copyWith(
                        color: isDark ? Colors.white : Color(0xFF111111),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  );
                }).toList();
              },
              onTap: () {
                if (_brands.isEmpty && !_isLoading) {
                  _loadBrands();
                }
              },
            ),
          ],
        );
      },
    );
  }

  List<DropdownMenuItem<String>> _buildDropdownItems(bool isDark) {
    if (_isLoading) {
      return [
        DropdownMenuItem<String>(
          value: null,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: isDark ? TColors.primary : Colors.blue.shade700,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'جاري التحميل...',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ];
    }

    if (_filteredBrands.isEmpty) {
      return [
        DropdownMenuItem<String>(
          value: null,
          child: Center(
            child: Text(
              _searchQuery.isEmpty ? 'لا توجد ماركات' : 'لا توجد نتائج',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
        ),
      ];
    }

    final items = <DropdownMenuItem<String>>[];

    // Add search field if enabled
    if (widget.showSearch) {
      items.add(
        DropdownMenuItem<String>(
          value: null,
          enabled: false,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'البحث في الماركات...',
                hintStyle: TextStyle(
                  color: isDark ? Colors.white54 : Colors.grey.shade500,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDark ? Colors.white70 : Colors.grey.shade600,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? Colors.white24 : Colors.grey.shade400,
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                filled: true,
                fillColor: isDark ? Colors.black26 : Colors.grey.shade100,
              ),
              style: TextStyle(
                color: isDark ? Colors.white : Color(0xFF111111),
                fontSize: 14,
              ),
            ),
          ),
        ),
      );
    }

    // Add brand items
    for (final brand in _filteredBrands) {
      items.add(
        DropdownMenuItem<String>(
          value: brand.id,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                // Brand image
                if (brand.image.isNotEmpty)
                  Container(
                    width: 32,
                    height: 32,
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: isDark ? Colors.black26 : Colors.grey.shade200,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        brand.image,
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.branding_watermark,
                            color:
                                isDark ? Colors.white54 : Colors.grey.shade600,
                            size: 20,
                          );
                        },
                      ),
                    ),
                  ),
                // Brand name
                Expanded(
                  child: Text(
                    brand.name,
                    style: TTextStyles.bodyMedium.copyWith(
                      color: isDark ? Colors.white : Color(0xFF111111),
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                // Feature indicator
                if (brand.isFeature == true)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return items;
  }

  // Public method to refresh brands
  Future<void> refreshBrands() async {
    await _loadBrands();
  }

  // Public method to get selected brand
  BrandModel? get selectedBrand {
    if (_selectedBrandId == null) return null;
    return _brands.firstWhereOrNull((b) => b.id == _selectedBrandId);
  }

  // Public method to clear selection
  void clearSelection() {
    setState(() {
      _selectedBrandId = null;
    });
    widget.onBrandChanged(null);
  }
}
