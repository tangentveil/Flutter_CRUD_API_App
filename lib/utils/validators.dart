import 'dart:convert';

String? validateJson(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'JSON is required';
  }
  try {
    final decoded = jsonDecode(value);
    if (decoded is! Map<String, dynamic>) {
      return 'JSON must be an object {}';
    }
  } catch (_) {
    return 'Invalid JSON';
  }
  return null;
}
