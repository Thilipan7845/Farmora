import 'api_client.dart';

class OfferService {
  // ============================================================
  // GET INCOMING OFFERS FOR LOGGED-IN FARMER
  // ============================================================

  static Future<List<dynamic>> getIncomingOffers() async {
    final response = await ApiClient.get(
      "/api/offers/incoming",
    );

    if (response is List) {
      return response;
    }

    // Some backend responses may wrap the list.
    if (response is Map<String, dynamic>) {
      final offers = response["offers"];

      if (offers is List) {
        return offers;
      }
    }

    throw Exception(
      "Invalid incoming offers response from server",
    );
  }

  // ============================================================
  // GET ALL OFFERS
  // ============================================================

  static Future<List<dynamic>> getOffers() async {
    final response = await ApiClient.get(
      "/api/offers",
    );

    if (response is List) {
      return response;
    }

    if (response is Map<String, dynamic>) {
      final offers = response["offers"];

      if (offers is List) {
        return offers;
      }
    }

    throw Exception(
      "Invalid offers response from server",
    );
  }

  // ============================================================
  // GET SINGLE OFFER
  // ============================================================

  static Future<Map<String, dynamic>> getOffer(
    String offerId,
  ) async {
    final response = await ApiClient.get(
      "/api/offers/$offerId",
    );

    if (response is Map<String, dynamic>) {
      return response;
    }

    throw Exception(
      "Invalid offer response from server",
    );
  }

  // ============================================================
  // CREATE OFFER
  // ============================================================

  static Future<Map<String, dynamic>> createOffer(
    Map<String, dynamic> data,
  ) async {
    final response = await ApiClient.post(
      "/api/offers",
      data,
    );

    if (response is Map<String, dynamic>) {
      return response;
    }

    throw Exception(
      "Invalid create offer response from server",
    );
  }

  // ============================================================
  // UPDATE OFFER
  // ============================================================

  static Future<Map<String, dynamic>> updateOffer(
    String offerId,
    Map<String, dynamic> data,
  ) async {
    final response = await ApiClient.put(
      "/api/offers/$offerId",
      data,
    );

    if (response is Map<String, dynamic>) {
      return response;
    }

    throw Exception(
      "Invalid update offer response from server",
    );
  }

  // ============================================================
  // UPDATE OFFER STATUS
  // ============================================================

  static Future<Map<String, dynamic>> updateOfferStatus(
    String offerId,
    String status,
  ) async {
    final response = await ApiClient.put(
      "/api/offers/$offerId/status",
      {
        "status": status,
      },
    );

    if (response is Map<String, dynamic>) {
      return response;
    }

    throw Exception(
      "Invalid offer status response from server",
    );
  }

  // ============================================================
  // CREATE NEGOTIATION
  // ============================================================

  static Future<Map<String, dynamic>> createNegotiation(
    Map<String, dynamic> data,
  ) async {
    final response = await ApiClient.post(
      "/api/offers/negotiations",
      data,
    );

    if (response is Map<String, dynamic>) {
      return response;
    }

    throw Exception(
      "Invalid negotiation response from server",
    );
  }

  // ============================================================
  // GET NEGOTIATIONS
  // ============================================================

  static Future<List<dynamic>> getNegotiations(
    String offerId,
  ) async {
    final response = await ApiClient.get(
      "/api/offers/$offerId/negotiations",
    );

    if (response is List) {
      return response;
    }

    if (response is Map<String, dynamic>) {
      final negotiations = response["negotiations"];

      if (negotiations is List) {
        return negotiations;
      }
    }

    throw Exception(
      "Invalid negotiations response from server",
    );
  }
}