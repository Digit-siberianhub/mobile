class Module {
  Module(this.name, this.type, this.description);

  final String name;
  final String type;
  final String description;

  Module.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        type = json['type'],
        description = json['description'];
}
