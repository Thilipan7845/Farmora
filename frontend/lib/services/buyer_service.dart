import 'api_client.dart';


class BuyerService {


  static Future<dynamic> findBuyerMatches(
      Map<String, dynamic> cropData,
      ) async {


    try {


      final response =
          await ApiClient.post(

            "/api/buyer-matching",

            cropData,

          );


      return response;


    } catch (e) {


      throw Exception(
        "Failed to load buyer matches: $e",
      );


    }


  }


}