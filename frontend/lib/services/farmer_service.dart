import 'api_client.dart';


class FarmerService {


  // Create farmer profile

  static Future<Map<String, dynamic>> createProfile(
      Map<String, dynamic> data) async {


    final response =
        await ApiClient.post(

      "/api/farmers/profile",

      data,

    );


    return response;

  }





  // Get farmer profile

  static Future<Map<String, dynamic>> getProfile() async {


    final response =
        await ApiClient.get(

      "/api/farmers/profile",

    );


    return response;

  }





  // Update farmer profile

  static Future<Map<String, dynamic>> updateProfile(
      Map<String, dynamic> data) async {


    final response =
        await ApiClient.put(

      "/api/farmers/profile",

      data,

    );


    return response;

  }


}