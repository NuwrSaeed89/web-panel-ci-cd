import 'package:brother_admin_panel/common/widgets/brand_dropdown.dart';
import 'package:flutter/material.dart';

/// مثال على كيفية استخدام BrandDropdown في الصفحات المختلفة
class BrandDropdownExample extends StatefulWidget {
  const BrandDropdownExample({super.key});

  @override
  State<BrandDropdownExample> createState() => _BrandDropdownExampleState();
}

class _BrandDropdownExampleState extends State<BrandDropdownExample> {
  String? _selectedBrandId;
  String? _selectedBrandId2;
  String? _selectedBrandId3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مثال على استخدام BrandDropdown'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // مثال 1: استخدام بسيط
            const Text(
              'مثال 1: استخدام بسيط',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            BrandDropdown(
              selectedBrandId: _selectedBrandId,
              onBrandChanged: (String? brandId) {
                setState(() {
                  _selectedBrandId = brandId;
                });
              },
              labelText: 'اختر الماركة',
              hintText: 'اختر ماركة المنتج',
              isRequired: true,
            ),
            const SizedBox(height: 24),

            // مثال 2: بدون بحث
            const Text(
              'مثال 2: بدون حقل البحث',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            BrandDropdown(
              selectedBrandId: _selectedBrandId2,
              onBrandChanged: (String? brandId) {
                setState(() {
                  _selectedBrandId2 = brandId;
                });
              },
              labelText: 'اختر الماركة (بدون بحث)',
              showSearch: false,
            ),
            const SizedBox(height: 24),

            // مثال 3: مع تخصيص إضافي
            const Text(
              'مثال 3: مع تخصيص إضافي',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            BrandDropdown(
              selectedBrandId: _selectedBrandId3,
              onBrandChanged: (String? brandId) {
                setState(() {
                  _selectedBrandId3 = brandId;
                });
              },
              labelText: 'اختر الماركة (مخصص)',
              hintText: 'اختر ماركة من القائمة',
              isRequired: false,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              menuMaxHeight: 400,
              prefixIcon: const Icon(Icons.store),
              suffixIcon: const Icon(Icons.arrow_drop_down_circle),
            ),
            const SizedBox(height: 32),

            // عرض القيم المحددة
            const Text(
              'القيم المحددة:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('الماركة 1: ${_selectedBrandId ?? 'لم يتم الاختيار'}'),
                  const SizedBox(height: 8),
                  Text('الماركة 2: ${_selectedBrandId2 ?? 'لم يتم الاختيار'}'),
                  const SizedBox(height: 8),
                  Text('الماركة 3: ${_selectedBrandId3 ?? 'لم يتم الاختيار'}'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // أزرار التحكم
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedBrandId = null;
                        _selectedBrandId2 = null;
                        _selectedBrandId3 = null;
                      });
                    },
                    child: const Text('مسح جميع الاختيارات'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // تعيين قيم افتراضية للاختبار
                        _selectedBrandId = 'brand1';
                        _selectedBrandId2 = 'brand2';
                        _selectedBrandId3 = 'brand3';
                      });
                    },
                    child: const Text('تعيين قيم افتراضية'),
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

/// مثال على استخدام BrandDropdown في نموذج إضافة منتج
class ProductFormExample extends StatefulWidget {
  const ProductFormExample({super.key});

  @override
  State<ProductFormExample> createState() => _ProductFormExampleState();
}

class _ProductFormExampleState extends State<ProductFormExample> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  String? _selectedBrandId;
  String? _selectedCategoryId;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نموذج إضافة منتج'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // اسم المنتج
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم المنتج',
                  hintText: 'أدخل اسم المنتج',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'اسم المنتج مطلوب';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // السعر
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'السعر',
                  hintText: 'أدخل سعر المنتج',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'السعر مطلوب';
                  }
                  if (double.tryParse(value) == null) {
                    return 'يرجى إدخال رقم صحيح';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // اختيار الماركة
              BrandDropdown(
                selectedBrandId: _selectedBrandId,
                onBrandChanged: (String? brandId) {
                  setState(() {
                    _selectedBrandId = brandId;
                  });
                },
                labelText: 'الماركة',
                hintText: 'اختر ماركة المنتج',
                isRequired: true,
                errorText:
                    _selectedBrandId == null ? 'يرجى اختيار الماركة' : null,
              ),
              const SizedBox(height: 16),

              // اختيار الفئة (مثال)
              DropdownButtonFormField<String>(
                value: _selectedCategoryId,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategoryId = newValue;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'الفئة',
                  hintText: 'اختر فئة المنتج',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: const [
                  DropdownMenuItem(value: 'cat1', child: Text('الإلكترونيات')),
                  DropdownMenuItem(value: 'cat2', child: Text('الملابس')),
                  DropdownMenuItem(value: 'cat3', child: Text('الأثاث')),
                ],
                validator: (value) {
                  if (value == null) {
                    return 'يرجى اختيار الفئة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // زر الحفظ
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('حفظ المنتج'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // التحقق من اختيار الماركة
      if (_selectedBrandId == null) {
        setState(() {});
        return;
      }

      // إظهار رسالة نجاح
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ المنتج بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
