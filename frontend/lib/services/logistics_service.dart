import 'api_client.dart';


class LogisticsService {


  static Future<List<dynamic>> getLogistics() async {

    final response =
        await ApiClient.get(
          "/api/logistics",
        );


    return response;

  }



  static Future<dynamic> getLogistic(
      String id
      ) async {


    return await ApiClient.get(

      "/api/logistics/$id",

    );


  }



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



  static Future<dynamic> createLogistics(
      Map<String,dynamic> data
      ) async {


    return await ApiClient.post(

      "/api/logistics",

      data,

    );


  }


}