import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_object_model.dart';

class ApiService {
  static const String baseUrl = 'https://api.restful-api.dev/objects';

  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  // GET list with basic pagination (page, limit via client-side)
  Future<List<ApiObjectModel>> getObjects({int limit = 20, int offset = 0}) async {
    final uri = Uri.parse(baseUrl);
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final List decoded = jsonDecode(response.body);
      final sliced = decoded.skip(offset).take(limit).toList();
      return sliced.map((e) => ApiObjectModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch objects: ${response.statusCode}');
    }
  }

  // GET single
  Future<ApiObjectModel> getObject(String id) async {
    final uri = Uri.parse('$baseUrl/$id');
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return ApiObjectModel.fromJson(decoded);
    } else {
      throw Exception('Failed to fetch detail: ${response.statusCode}');
    }
  }

  // POST create
  Future<ApiObjectModel> createObject(ApiObjectModel obj) async {
    final uri = Uri.parse(baseUrl);
    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(obj.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      return ApiObjectModel.fromJson(decoded);
    } else {
      throw Exception('Failed to create object: ${response.statusCode}');
    }
  }

  // PUT update (full replace)
  Future<ApiObjectModel> updateObject(ApiObjectModel obj) async {
    if (obj.id == null) {
      throw Exception('Object id is required for update');
    }

    final uri = Uri.parse('$baseUrl/${obj.id}');
    final response = await client.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(obj.toJson()),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return ApiObjectModel.fromJson(decoded);
    } else {
      throw Exception('Failed to update object: ${response.statusCode}');
    }
  }

  // DELETE
  Future<bool> deleteObject(String id) async {
    final uri = Uri.parse('$baseUrl/$id');
    final response = await client.delete(uri);

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to delete object: ${response.statusCode}');
    }
  }
}
