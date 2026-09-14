import 'api_client.dart';


class BuyerService {


  final ApiClient apiClient = ApiClient();



  Future<dynamic> findBuyerMatches(
      Map<String, dynamic> cropData
      ) async {


    try {


      final response =
          await apiClient.post(

            "/api/buyer-matching",

            cropData,

          );


      return response;


    } catch (e) {


      throw Exception(
          "Failed to load buyer matches: $e"
      );


    }


  }


}