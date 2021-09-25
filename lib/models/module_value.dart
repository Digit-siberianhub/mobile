class ModuleValue {
  final String module;
  final int sum;
  final String type;
  final String descriptions;

  ModuleValue.fromJson(Map<String, dynamic> json)
      : module = json['name'],
        sum = json['sum'],
        type = json['type'],
        descriptions = json['description'];
}
