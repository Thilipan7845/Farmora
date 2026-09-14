import 'api_client.dart';


class CropService {


  // ============================================================
  // CREATE CROP LOT
  // ============================================================

  static Future<Map<String, dynamic>> createCropLot(
    Map<String, dynamic> data,
  ) async {


    final response =
        await ApiClient.post(
          "/api/crop-lots",
          data,
        );


    return Map<String, dynamic>.from(response);


  }





  // ============================================================
  // GET ALL CROP LOTS FOR LOGGED-IN FARMER
  // ============================================================

  static Future<List<dynamic>> getCropLots() async {


    final response =
        await ApiClient.get(
          "/api/crop-lots",
        );



    if(response is List){

      return response;

    }



    throw Exception(
      "Invalid crop lots response from server",
    );


  }







  // ============================================================
  // GET SINGLE CROP LOT
  // ============================================================

  static Future<Map<String, dynamic>> getCropLot(
    String id,
  ) async {


    final response =
        await ApiClient.get(
          "/api/crop-lots/$id",
        );



    return Map<String,dynamic>.from(response);


  }







  // ============================================================
  // UPDATE CROP LOT
  // ============================================================

  static Future<Map<String, dynamic>> updateCropLot(
    String id,
    Map<String, dynamic> data,
  ) async {


    final response =
        await ApiClient.put(
          "/api/crop-lots/$id",
          data,
        );



    return Map<String,dynamic>.from(response);


  }







  // ============================================================
  // DELETE CROP LOT
  // ============================================================

  static Future<void> deleteCropLot(
    String id,
  ) async {


    await ApiClient.delete(
      "/api/crop-lots/$id",
    );


  }


}