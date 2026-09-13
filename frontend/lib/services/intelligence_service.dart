import 'api_client.dart';


class IntelligenceService {


  static Future<Map<String,dynamic>> getDecision(
      Map<String,dynamic> data
      ) async {


    final response =
        await ApiClient.post(

      "/api/intelligence/decision",

      data,

    );


    return response;

  }


}