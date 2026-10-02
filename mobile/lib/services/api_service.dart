class ApiService {
  Future<Map<String, dynamic>> get(String endpoint) async {
    throw UnimplementedError(
      'API belum dihubungkan. Endpoint: $endpoint',
    );
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    throw UnimplementedError(
      'API belum dihubungkan. Endpoint: $endpoint',
    );
  }

  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    throw UnimplementedError(
      'API belum dihubungkan. Endpoint: $endpoint',
    );
  }

  Future<void> delete(String endpoint) async {
    throw UnimplementedError(
      'API belum dihubungkan. Endpoint: $endpoint',
    );
  }
}