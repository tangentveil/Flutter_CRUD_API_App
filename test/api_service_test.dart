import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:flutter_crud_api_app/services/api_service.dart';

import 'api_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  test('getObjects returns list of ApiObjectModel on success', () async {
    final client = MockClient();
    final service = ApiService(client: client);

    when(client.get(Uri.parse(ApiService.baseUrl))).thenAnswer(
      (_) async => http.Response(
        jsonEncode([
          {"id": "1", "name": "Test 1", "data": {"color": "red"}},
          {"id": "2", "name": "Test 2", "data": {"color": "blue"}}
        ]),
        200,
      ),
    );

    final result = await service.getObjects(limit: 2, offset: 0);

    expect(result.length, 2);
    expect(result.first.name, 'Test 1');
  });
}
