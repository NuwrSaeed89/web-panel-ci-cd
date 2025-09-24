import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/utils/validators/validator.dart';

class CountryCodePicker extends StatefulWidget {
  final String? selectedCountryCode;
  final ValueChanged<String> onCountryChanged;
  final bool isDark;

  const CountryCodePicker({
    super.key,
    this.selectedCountryCode,
    required this.onCountryChanged,
    required this.isDark,
  });

  @override
  State<CountryCodePicker> createState() => _CountryCodePickerState();
}

class _CountryCodePickerState extends State<CountryCodePicker> {
  String? _selectedCountryCode;
  final TextEditingController _searchController = TextEditingController();
  List<MapEntry<String, String>> _filteredCountries = [];

  @override
  void initState() {
    super.initState();
    _selectedCountryCode = widget.selectedCountryCode ?? 'SA';
    _filteredCountries = _getFilteredCountries('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MapEntry<String, String>> _getFilteredCountries(String query) {
    final countryCodes = TValidator.getCountryCodes();
    final countries = countryCodes.entries.toList();

    if (query.isEmpty) {
      return countries;
    }

    return countries.where((entry) {
      final countryName = TValidator.getCountryName(entry.key);
      final countryCode = entry.value;
      final searchQuery = query.toLowerCase();

      return countryName.toLowerCase().contains(searchQuery) ||
          countryCode.contains(query) ||
          entry.key.toLowerCase().contains(searchQuery) ||
          // البحث باللغة الإنجليزية أيضاً
          _getEnglishCountryName(entry.key).toLowerCase().contains(searchQuery);
    }).toList();
  }

  // دالة مساعدة للحصول على اسم الدولة بالإنجليزية
  String _getEnglishCountryName(String countryCode) {
    final englishNames = {
      'SA': 'Saudi Arabia',
      'AE': 'United Arab Emirates',
      'KW': 'Kuwait',
      'BH': 'Bahrain',
      'QA': 'Qatar',
      'OM': 'Oman',
      'YE': 'Yemen',
      'IQ': 'Iraq',
      'JO': 'Jordan',
      'LB': 'Lebanon',
      'SY': 'Syria',
      'PS': 'Palestine',
      'EG': 'Egypt',
      'LY': 'Libya',
      'TN': 'Tunisia',
      'DZ': 'Algeria',
      'MA': 'Morocco',
      'SD': 'Sudan',
      'SS': 'South Sudan',
      'ET': 'Ethiopia',
      'ER': 'Eritrea',
      'DJ': 'Djibouti',
      'SO': 'Somalia',
      'KE': 'Kenya',
      'UG': 'Uganda',
      'TZ': 'Tanzania',
      'RW': 'Rwanda',
      'BI': 'Burundi',
      'TR': 'Turkey',
      'IR': 'Iran',
      'AF': 'Afghanistan',
      'PK': 'Pakistan',
      'BD': 'Bangladesh',
      'LK': 'Sri Lanka',
      'MV': 'Maldives',
      'NP': 'Nepal',
      'BT': 'Bhutan',
      'MY': 'Malaysia',
      'SG': 'Singapore',
      'TH': 'Thailand',
      'VN': 'Vietnam',
      'LA': 'Laos',
      'KH': 'Cambodia',
      'MM': 'Myanmar',
      'PH': 'Philippines',
      'ID': 'Indonesia',
      'BN': 'Brunei',
      'TL': 'East Timor',
      'IN': 'India',
      'CN': 'China',
      'TW': 'Taiwan',
      'HK': 'Hong Kong',
      'MO': 'Macau',
      'MN': 'Mongolia',
      'KP': 'North Korea',
      'KR': 'South Korea',
      'JP': 'Japan',
      'RU': 'Russia',
      'KZ': 'Kazakhstan',
      'UZ': 'Uzbekistan',
      'KG': 'Kyrgyzstan',
      'TJ': 'Tajikistan',
      'TM': 'Turkmenistan',
      'AZ': 'Azerbaijan',
      'GE': 'Georgia',
      'AM': 'Armenia',
      'IL': 'Israel',
      'CY': 'Cyprus',
      'GR': 'Greece',
      'BG': 'Bulgaria',
      'RO': 'Romania',
      'MD': 'Moldova',
      'UA': 'Ukraine',
      'BY': 'Belarus',
      'LT': 'Lithuania',
      'LV': 'Latvia',
      'EE': 'Estonia',
      'FI': 'Finland',
      'SE': 'Sweden',
      'NO': 'Norway',
      'DK': 'Denmark',
      'IS': 'Iceland',
      'IE': 'Ireland',
      'GB': 'United Kingdom',
      'NL': 'Netherlands',
      'BE': 'Belgium',
      'LU': 'Luxembourg',
      'FR': 'France',
      'MC': 'Monaco',
      'AD': 'Andorra',
      'ES': 'Spain',
      'PT': 'Portugal',
      'IT': 'Italy',
      'SM': 'San Marino',
      'VA': 'Vatican',
      'CH': 'Switzerland',
      'AT': 'Austria',
      'LI': 'Liechtenstein',
      'DE': 'Germany',
      'PL': 'Poland',
      'CZ': 'Czech Republic',
      'SK': 'Slovakia',
      'HU': 'Hungary',
      'SI': 'Slovenia',
      'HR': 'Croatia',
      'BA': 'Bosnia and Herzegovina',
      'RS': 'Serbia',
      'ME': 'Montenegro',
      'MK': 'North Macedonia',
      'AL': 'Albania',
      'XK': 'Kosovo',
      'MT': 'Malta',
      'US': 'United States',
      'CA': 'Canada',
      'MX': 'Mexico',
      'GT': 'Guatemala',
      'BZ': 'Belize',
      'SV': 'El Salvador',
      'HN': 'Honduras',
      'NI': 'Nicaragua',
      'CR': 'Costa Rica',
      'PA': 'Panama',
      'CU': 'Cuba',
      'JM': 'Jamaica',
      'HT': 'Haiti',
      'DO': 'Dominican Republic',
      'PR': 'Puerto Rico',
      'TT': 'Trinidad and Tobago',
      'BB': 'Barbados',
      'GD': 'Grenada',
      'LC': 'Saint Lucia',
      'VC': 'Saint Vincent and the Grenadines',
      'AG': 'Antigua and Barbuda',
      'KN': 'Saint Kitts and Nevis',
      'DM': 'Dominica',
      'BS': 'Bahamas',
      'AR': 'Argentina',
      'BR': 'Brazil',
      'CL': 'Chile',
      'CO': 'Colombia',
      'VE': 'Venezuela',
      'GY': 'Guyana',
      'SR': 'Suriname',
      'GF': 'French Guiana',
      'UY': 'Uruguay',
      'PY': 'Paraguay',
      'BO': 'Bolivia',
      'PE': 'Peru',
      'EC': 'Ecuador',
      'AU': 'Australia',
      'NZ': 'New Zealand',
      'FJ': 'Fiji',
      'PG': 'Papua New Guinea',
      'SB': 'Solomon Islands',
      'VU': 'Vanuatu',
      'NC': 'New Caledonia',
      'PF': 'French Polynesia',
      'WS': 'Samoa',
      'TO': 'Tonga',
      'KI': 'Kiribati',
      'TV': 'Tuvalu',
      'NR': 'Nauru',
      'FM': 'Micronesia',
      'MH': 'Marshall Islands',
      'PW': 'Palau',
      'ZA': 'South Africa',
      'NA': 'Namibia',
      'BW': 'Botswana',
      'ZW': 'Zimbabwe',
      'ZM': 'Zambia',
      'MW': 'Malawi',
      'MZ': 'Mozambique',
      'MG': 'Madagascar',
      'MU': 'Mauritius',
      'SC': 'Seychelles',
      'KM': 'Comoros',
      'YT': 'Mayotte',
      'RE': 'Réunion',
      'LS': 'Lesotho',
      'SZ': 'Eswatini',
      'AO': 'Angola',
      'CD': 'Democratic Republic of the Congo',
      'CG': 'Republic of the Congo',
      'CF': 'Central African Republic',
      'TD': 'Chad',
      'NE': 'Niger',
      'NG': 'Nigeria',
      'BF': 'Burkina Faso',
      'ML': 'Mali',
      'SN': 'Senegal',
      'GM': 'Gambia',
      'GN': 'Guinea',
      'GW': 'Guinea-Bissau',
      'CV': 'Cape Verde',
      'ST': 'São Tomé and Príncipe',
      'GQ': 'Equatorial Guinea',
      'GA': 'Gabon',
      'CM': 'Cameroon',
      'CI': 'Ivory Coast',
      'GH': 'Ghana',
      'TG': 'Togo',
      'BJ': 'Benin',
      'LR': 'Liberia',
      'SL': 'Sierra Leone',
    };

    return englishNames[countryCode] ?? countryCode;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.isDark ? Colors.grey[600]! : Colors.grey[300]!,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _filteredCountries = _getFilteredCountries(value);
                });
              },
              decoration: InputDecoration(
                hintText: 'البحث عن الدولة...',
                hintStyle: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  color: widget.isDark ? Colors.grey[400] : Colors.grey[600],
                ),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                filled: true,
                fillColor: widget.isDark ? Colors.grey[800] : Colors.grey[50],
              ),
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                color: widget.isDark ? Colors.white : Colors.black,
              ),
            ),
          ),

          // Countries List
          SizedBox(
            height: 400, // زيادة الارتفاع لعرض المزيد من الدول
            child: ListView.builder(
              itemCount: _filteredCountries.length,
              itemBuilder: (context, index) {
                final entry = _filteredCountries[index];
                final countryCode = entry.key;
                final phoneCode = entry.value;
                final countryName = TValidator.getCountryName(countryCode);
                final isSelected = _selectedCountryCode == countryCode;

                return ListTile(
                  leading: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          widget.isDark ? Colors.grey[700] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '+$phoneCode',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: widget.isDark ? Colors.white : Colors.black,
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontSize: 14,
                      ),
                    ),
                  ),
                  title: Text(
                    countryName,
                    style: TextStyle(
                      color: widget.isDark ? Colors.white : Colors.black,
                      fontFamily: 'IBM Plex Sans Arabic',
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    countryCode,
                    style: TextStyle(
                      color:
                          widget.isDark ? Colors.grey[400] : Colors.grey[600],
                      fontFamily: 'IBM Plex Sans Arabic',
                      fontSize: 12,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check_circle,
                          color: Theme.of(context).primaryColor,
                          size: 24,
                        )
                      : Icon(
                          Icons.radio_button_unchecked,
                          color: widget.isDark
                              ? Colors.grey[600]
                              : Colors.grey[400],
                          size: 24,
                        ),
                  onTap: () {
                    setState(() {
                      _selectedCountryCode = countryCode;
                    });
                    widget.onCountryChanged(countryCode);
                  },
                  selected: isSelected,
                  selectedTileColor:
                      widget.isDark ? Colors.grey[800] : Colors.grey[100],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CountryCodeButton extends StatelessWidget {
  final RxString selectedCountryCode;
  final VoidCallback onTap;
  final bool isDark;
  final bool isVertical; // إضافة معامل للتخطيط العمودي

  const CountryCodeButton({
    super.key,
    required this.selectedCountryCode,
    required this.onTap,
    required this.isDark,
    this.isVertical = false,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final countryCodes = TValidator.getCountryCodes();
      final phoneCode = countryCodes[selectedCountryCode.value] ?? '966';

      return InkWell(
        onTap: onTap,
        child: Container(
          height: 48, // نفس ارتفاع TextFormField
          width: isVertical ? double.infinity : null, // للشاشات الصغيرة
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark ? Colors.grey.shade300 : Colors.grey[300]!,
            ),
            borderRadius: isVertical
                ? BorderRadius.circular(8) // دائري للشاشات الصغيرة
                : const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ), // نصف دائري للتخطيط الأفقي
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '+$phoneCode',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_drop_down,
                color: isDark ? Colors.white : Colors.black,
                size: 20,
              ),
            ],
          ),
        ),
      );
    });
  }
}
