import 'api_client.dart';


class CropService {


  final ApiClient apiClient = ApiClient();



  Future<dynamic> getCropLots() async {


    try {


      final response =
          await apiClient.get(

            "/api/crop-lots",

          );


      return response;


    } catch (e) {


      throw Exception(
          "Failed to load crop lots: $e"
      );


    }


  }



  Future<dynamic> createCropLot(
      Map<String,dynamic> cropData
      ) async {


    try {


      final response =
          await apiClient.post(

            "/api/crop-lots",

            cropData,

          );


      return response;


    } catch(e){


      throw Exception(
          "Failed to create crop lot: $e"
      );


    }


  }


}