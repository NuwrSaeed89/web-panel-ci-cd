class ProductAtributeModel {
  String? name;
  final List<String>? values;

  ProductAtributeModel({this.name, this.values});
  toJason() {
    return {'Name': name, 'Values': values};
  }

  static ProductAtributeModel empty() =>
      ProductAtributeModel(name: '', values: []);

  factory ProductAtributeModel.fromJason(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) return ProductAtributeModel.empty();

    return ProductAtributeModel(
        name: data.containsKey('Name') ? data['Name'] : '',
        values: List<String>.from(data['Values']));
  }
}
