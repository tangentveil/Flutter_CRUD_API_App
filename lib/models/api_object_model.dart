class ApiObjectModel {
  final String? id;
  final String name;
  final Map<String, dynamic>? data;

  ApiObjectModel({
    this.id,
    required this.name,
    this.data,
  });

  factory ApiObjectModel.fromJson(Map<String, dynamic> json) {
    return ApiObjectModel(
      id: json['id']?.toString(),
      name: json['name'] ?? '',
      data: json['data'] != null
          ? Map<String, dynamic>.from(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (data != null) 'data': data,
    };
  }
}
