import 'api_client.dart';

class DashboardService {
  static Future<Map<String, dynamic>> getStats() async {
    final response = await ApiClient.get(
      "/api/farmer/dashboard",
    );

    if (response is Map<String, dynamic>) {
      return response;
    }

    throw Exception(
      "Invalid dashboard response from server",
    );
  }
}