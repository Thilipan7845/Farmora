import 'api_client.dart';


class LogisticsService {


  final ApiClient apiClient = ApiClient();



  Future<dynamic> getLogistics() async {


    try {


      final response =
          await apiClient.get(

            "/api/logistics",

          );


      return response;


    } catch (e) {


      throw Exception(
          "Failed to load logistics data: $e"
      );


    }

  }




  Future<dynamic> updateLogisticsStatus(
      String logisticsId,
      String status
      ) async {


    try {


      final response =
          await apiClient.post(

            "/api/logistics/$logisticsId/status",

            {
              "status": status
            },

          );


      return response;


    } catch(e){


      throw Exception(
          "Failed to update logistics status: $e"
      );


    }

  }


}