import 'api_client.dart';

class LogisticsService {
  /// Get logistics tracking for a specific order.
  static Future<Map<String, dynamic>> getTracking(
    String orderId,
  ) async {
    final response = await ApiClient.get(
      "/api/logistics/tracking/$orderId",
    );

    if (response is Map<String, dynamic>) {
      return response;
    }

    throw Exception("Invalid logistics tracking response");
  }

  /// Get a single logistics record.
  static Future<dynamic> getLogistic(
    String id,
  ) async {
    return await ApiClient.get(
      "/api/logistics/$id",
    );
  }

  /// Update logistics status.
  static Future<dynamic> updateStatus(
    String id,
    String status,
  ) async {
    return await ApiClient.put(
      "/api/logistics/$id/status",
      {
        "status": status,
      },
    );
  }

  /// Create logistics.
  static Future<dynamic> createLogistics(
    Map<String, dynamic> data,
  ) async {
    return await ApiClient.post(
      "/api/logistics",
      data,
    );
  }
}