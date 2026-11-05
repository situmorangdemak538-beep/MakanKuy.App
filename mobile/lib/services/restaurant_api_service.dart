
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class RestaurantApiService {
  // Header untuk permintaan yang membutuhkan login.
  Map<String, String> _authHeaders(String token) {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Mengambil daftar restoran dari Laravel.
  Future<List<dynamic>> fetchRestaurants() async {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.restaurants}',
    );

    final response = await http.get(
      uri,
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengambil restoran: ${response.statusCode}',
      );
    }

    final body = jsonDecode(response.body);

    if (body is Map<String, dynamic>) {
      final data = body['data'];
      if (data is List) return data;
    }

    if (body is List) return body;

    throw Exception('Format respons restoran tidak sesuai.');
  }

  // Mengirim pendaftaran restoran ke Laravel.
  Future<Map<String, dynamic>> createRestaurant({
    required String token,
    required Map<String, dynamic> data,
  }) async {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.restaurants}',
    );

    final response = await http.post(
      uri,
      headers: _authHeaders(token),
      body: jsonEncode(data),
    );

    final dynamic result = jsonDecode(response.body);

    if (response.statusCode != 201) {
      throw Exception(
        _errorMessage(result, 'Pendaftaran warung gagal.'),
      );
    }

    if (result is! Map || result['data'] is! Map) {
      throw Exception('Respons penyimpanan restoran tidak sesuai.');
    }

    return Map<String, dynamic>.from(result['data'] as Map);
  }

  // Mengambil dashboard Administrator.
  Future<Map<String, dynamic>> fetchAdministratorDashboard({
    required String token,
  }) async {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.administratorDashboard}',
    );

    final response = await http.get(
      uri,
      headers: _authHeaders(token),
    );

    final dynamic result = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(
        _errorMessage(
          result,
          'Gagal mengambil dashboard Administrator.',
        ),
      );
    }

    if (result is! Map || result['data'] is! Map) {
      throw Exception('Format dashboard Administrator tidak sesuai.');
    }

    return Map<String, dynamic>.from(result['data'] as Map);
  }

  // Menyetujui pendaftaran restoran.
  Future<void> approveRestaurant({
    required String token,
    required String id,
  }) async {
    await _updateRestaurantStatus(
      token: token,
      endpoint: ApiConfig.approveRestaurant(id),
    );
  }

  // Menolak pendaftaran restoran.
  Future<void> rejectRestaurant({
    required String token,
    required String id,
  }) async {
    await _updateRestaurantStatus(
      token: token,
      endpoint: ApiConfig.rejectRestaurant(id),
    );
  }

  // Mengirim perubahan status ke Laravel.
  Future<void> _updateRestaurantStatus({
    required String token,
    required String endpoint,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');

    final response = await http.put(
      uri,
      headers: _authHeaders(token),
    );

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      dynamic result;

      try {
        result = jsonDecode(response.body);
      } catch (_) {
        result = null;
      }

      throw Exception(
        _errorMessage(
          result,
          'Gagal mengubah status restoran.',
        ),
      );
    }
  }

  // Membaca pesan error dari Laravel.
  String _errorMessage(dynamic result, String fallback) {
    if (result is Map) {
      if (result['errors'] is Map &&
          (result['errors'] as Map).isNotEmpty) {
        final errors = result['errors'] as Map;
        final firstError = errors.values.first;

        if (firstError is List && firstError.isNotEmpty) {
          return firstError.first.toString();
        }
      }

      return result['message']?.toString() ?? fallback;
    }

    return fallback;
  }
}
