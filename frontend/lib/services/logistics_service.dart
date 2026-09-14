import 'api_client.dart';


class LogisticsService {


  // ============================================================
  // GET LOGISTICS TRACKING FOR ORDER
  // ============================================================

  static Future<Map<String, dynamic>> getTracking(
    String orderId,
  ) async {


    final response =
        await ApiClient.get(

          "/api/logistics/tracking/$orderId",

        );



    if(response is Map<String,dynamic>){

      return response;

    }



    throw Exception(
      "Invalid logistics tracking response",
    );


  }







  // ============================================================
  // GET SINGLE LOGISTICS RECORD
  // ============================================================

  static Future<dynamic> getLogistic(
    String id,
  ) async {


    return await ApiClient.get(

      "/api/logistics/$id",

    );


  }







  // ============================================================
  // UPDATE LOGISTICS STATUS
  // ============================================================

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







  // ============================================================
  // CREATE LOGISTICS
  // ============================================================

  static Future<dynamic> createLogistics(

    Map<String,dynamic> data,

  ) async {


    return await ApiClient.post(

      "/api/logistics",

      data,

    );


  }


}