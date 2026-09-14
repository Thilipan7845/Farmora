import 'api_client.dart';

class BuyerMatchingService {
  static Future<Map<String, dynamic>> findBuyers(
    String cropLotId,
  ) async {
    final response = await ApiClient.post(
      "/api/buyer-matching",
      {
        "crop_lot_id": cropLotId,
      },
    );

    if (response is Map<String, dynamic>) {
      return response;
    }

    throw Exception("Invalid buyer matching response");
  }
}