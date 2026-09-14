import 'api_client.dart';

class OrderService {
  /// Get orders belonging to the currently logged-in farmer.
  static Future<List<dynamic>> getOrders() async {
    final response = await ApiClient.get(
      "/api/orders/farmer",
    );

    if (response is Map<String, dynamic>) {
      final orders = response["orders"];

      if (orders is List) {
        return orders;
      }
    }

    if (response is List) {
      return response;
    }

    throw Exception("Invalid orders response");
  }

  /// Get a single order.
  static Future<dynamic> getOrder(String orderId) async {
    return await ApiClient.get(
      "/api/orders/$orderId",
    );
  }

  /// Update order status.
  static Future<dynamic> updateOrderStatus(
    String orderId,
    String status,
  ) async {
    return await ApiClient.put(
      "/api/orders/$orderId/status",
      {
        "status": status,
      },
    );
  }

  /// Create an order.
  static Future<dynamic> createOrder(
    Map<String, dynamic> data,
  ) async {
    return await ApiClient.post(
      "/api/orders",
      data,
    );
  }
}