import 'api_client.dart';


class IntelligenceService {


  final ApiClient apiClient = ApiClient();



  Future<dynamic> getDecision(
      Map<String, dynamic> cropData
      ) async {


    try {


      final response =
          await apiClient.post(

            "/api/intelligence/decision",

            cropData,

          );


      return response;


    } catch (e) {


      throw Exception(
          "Failed to get intelligence decision: $e"
      );


    }


  }


}