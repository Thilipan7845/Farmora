import 'api_client.dart';


class CropService {


  static Future<Map<String,dynamic>> createCropLot(
      Map<String,dynamic> data
      ) async {


    return await ApiClient.post(

      "/api/crop-lots",

      data,

    );


  }





  static Future<List<dynamic>> getCropLots() async {


    final response =
        await ApiClient.get(

      "/api/crop-lots",

    );



    return response as List<dynamic>;

  }




  static Future<Map<String,dynamic>> getCropLot(
      String id
      ) async {


    return await ApiClient.get(

      "/api/crop-lots/$id",

    );


  }



}