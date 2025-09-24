# BrandDropdown Widget

## نظرة عامة
`BrandDropdown` هو widget مستقل وقابل لإعادة الاستخدام لاختيار الماركات من قائمة منسدلة. يمكن استخدامه في أي صفحة تحتاج إلى اختيار ماركة، مثل صفحات إضافة وتعديل المنتجات.

## المميزات
- ✅ قائمة منسدلة تفاعلية مع بحث
- ✅ دعم الوضع الداكن والفاتح
- ✅ عرض صور الماركات
- ✅ مؤشر للماركات المميزة
- ✅ تخصيص كامل للشكل والوظائف
- ✅ دعم التحقق من صحة البيانات
- ✅ تحديث تلقائي للبيانات
- ✅ معالجة الأخطاء

## الاستخدام الأساسي

```dart
import 'package:brother_admin_panel/common/widgets/brand_dropdown.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String? _selectedBrandId;

  @override
  Widget build(BuildContext context) {
    return BrandDropdown(
      selectedBrandId: _selectedBrandId,
      onBrandChanged: (String? brandId) {
        setState(() {
          _selectedBrandId = brandId;
        });
      },
      labelText: 'اختر الماركة',
      isRequired: true,
    );
  }
}
```

## الخصائص المتاحة

### الخصائص المطلوبة
- `selectedBrandId`: معرف الماركة المحددة حالياً
- `onBrandChanged`: دالة callback تُستدعى عند تغيير الاختيار

### الخصائص الاختيارية
- `labelText`: نص التسمية (اختياري)
- `hintText`: نص التلميح (افتراضي: 'اختر الماركة')
- `isRequired`: هل الحقل مطلوب (افتراضي: false)
- `showSearch`: إظهار حقل البحث (افتراضي: true)
- `enabled`: هل الحقل مفعل (افتراضي: true)
- `errorText`: نص الخطأ (اختياري)
- `contentPadding`: المساحة الداخلية
- `border`: حدود الحقل
- `dropdownColor`: لون القائمة المنسدلة
- `menuMaxHeight`: الارتفاع الأقصى للقائمة
- `prefixIcon`: أيقونة البادئة
- `suffixIcon`: أيقونة اللاحقة

## أمثلة الاستخدام

### 1. استخدام بسيط
```dart
BrandDropdown(
  selectedBrandId: _brandId,
  onBrandChanged: (id) => setState(() => _brandId = id),
  labelText: 'الماركة',
)
```

### 2. مع تخصيص إضافي
```dart
BrandDropdown(
  selectedBrandId: _brandId,
  onBrandChanged: (id) => setState(() => _brandId = id),
  labelText: 'اختر ماركة المنتج',
  hintText: 'اختر من القائمة',
  isRequired: true,
  showSearch: true,
  contentPadding: EdgeInsets.all(16),
  prefixIcon: Icon(Icons.store),
  menuMaxHeight: 400,
)
```

### 3. بدون حقل البحث
```dart
BrandDropdown(
  selectedBrandId: _brandId,
  onBrandChanged: (id) => setState(() => _brandId = id),
  showSearch: false,
  labelText: 'الماركة',
)
```

### 4. مع رسالة خطأ
```dart
BrandDropdown(
  selectedBrandId: _brandId,
  onBrandChanged: (id) => setState(() => _brandId = id),
  labelText: 'الماركة',
  isRequired: true,
  errorText: _brandId == null ? 'يرجى اختيار الماركة' : null,
)
```

## في نموذج إضافة منتج

```dart
class ProductForm extends StatefulWidget {
  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedBrandId;
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // اسم المنتج
          TextFormField(
            decoration: InputDecoration(labelText: 'اسم المنتج'),
            validator: (value) {
              if (value?.isEmpty ?? true) return 'مطلوب';
              return null;
            },
          ),
          
          SizedBox(height: 16),
          
          // اختيار الماركة
          BrandDropdown(
            selectedBrandId: _selectedBrandId,
            onBrandChanged: (brandId) {
              setState(() {
                _selectedBrandId = brandId;
              });
            },
            labelText: 'الماركة',
            isRequired: true,
            errorText: _selectedBrandId == null ? 'يرجى اختيار الماركة' : null,
          ),
          
          SizedBox(height: 16),
          
          // اختيار الفئة
          DropdownButtonFormField<String>(
            value: _selectedCategoryId,
            onChanged: (categoryId) {
              setState(() {
                _selectedCategoryId = categoryId;
              });
            },
            decoration: InputDecoration(labelText: 'الفئة'),
            items: [
              DropdownMenuItem(value: 'cat1', child: Text('الإلكترونيات')),
              DropdownMenuItem(value: 'cat2', child: Text('الملابس')),
            ],
          ),
          
          SizedBox(height: 32),
          
          ElevatedButton(
            onPressed: _submitForm,
            child: Text('حفظ المنتج'),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // التحقق من اختيار الماركة
      if (_selectedBrandId == null) {
        setState(() {}); // لإعادة بناء الواجهة وعرض رسالة الخطأ
        return;
      }
      
      // حفظ المنتج
      print('الماركة المختارة: $_selectedBrandId');
    }
  }
}
```

## الطرق العامة

### `refreshBrands()`
تحديث قائمة الماركات من قاعدة البيانات:
```dart
final brandDropdown = GlobalKey<_BrandDropdownState>();
// ...
brandDropdown.currentState?.refreshBrands();
```

### `selectedBrand`
الحصول على كائن الماركة المحددة:
```dart
final brandDropdown = GlobalKey<_BrandDropdownState>();
// ...
final brand = brandDropdown.currentState?.selectedBrand;
if (brand != null) {
  print('اسم الماركة: ${brand.name}');
  print('صورة الماركة: ${brand.image}');
}
```

### `clearSelection()`
مسح الاختيار الحالي:
```dart
final brandDropdown = GlobalKey<_BrandDropdownState>();
// ...
brandDropdown.currentState?.clearSelection();
```

## التخصيص المتقدم

### تخصيص الألوان
```dart
BrandDropdown(
  selectedBrandId: _brandId,
  onBrandChanged: (id) => setState(() => _brandId = id),
  dropdownColor: Colors.blue.shade50,
  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
)
```

### تخصيص الحدود
```dart
BrandDropdown(
  selectedBrandId: _brandId,
  onBrandChanged: (id) => setState(() => _brandId = id),
  border: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
    side: BorderSide(color: Colors.blue, width: 2),
  ),
)
```

### تخصيص الأيقونات
```dart
BrandDropdown(
  selectedBrandId: _brandId,
  onBrandChanged: (id) => setState(() => _brandId = id),
  prefixIcon: Icon(Icons.store, color: Colors.green),
  suffixIcon: Icon(Icons.arrow_drop_down_circle, color: Colors.blue),
)
```

## ملاحظات مهمة

1. **تهيئة المتحكم**: تأكد من أن `BrandController` مُهيأ في `GenerateBinding`
2. **إدارة الحالة**: استخدم `setState()` عند تغيير `selectedBrandId`
3. **التحقق من الصحة**: يمكن استخدام `errorText` لعرض رسائل الخطأ
4. **الأداء**: القائمة تُحدث تلقائياً عند الحاجة
5. **التوافق**: يعمل مع جميع أحجام الشاشات

## استكشاف الأخطاء

### المشكلة: لا تظهر الماركات
**الحل**: تأكد من تهيئة `BrandController` في `GenerateBinding`

### المشكلة: لا يعمل البحث
**الحل**: تأكد من أن `showSearch: true` (افتراضي)

### المشكلة: لا يتم حفظ الاختيار
**الحل**: تأكد من استخدام `setState()` في `onBrandChanged`

### المشكلة: لا تظهر رسائل الخطأ
**الحل**: تأكد من تمرير `errorText` عند الحاجة
