import 'api_client.dart';


class BuyerMatchingService {


  static Future<List<dynamic>> findBuyers(
      Map<String,dynamic> data
  ) async {


    final response =
        await ApiClient.post(
          "/api/buyer-matching",
          data,
        );


    return response;

  }


}