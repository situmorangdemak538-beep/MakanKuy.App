
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class MenuApiService {
  Future<List<dynamic>> fetchMenus(String restaurantId) async {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.restaurantMenus(restaurantId)}',
    );

    final response = await http.get(
      uri,
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengambil menu: ${response.statusCode}',
      );
    }

    final body = jsonDecode(response.body);

    if (body is Map<String, dynamic> && body['data'] is List) {
      return body['data'] as List<dynamic>;
    }

    if (body is List) {
      return body;
    }

    throw Exception('Format respons menu tidak sesuai.');
  }
}