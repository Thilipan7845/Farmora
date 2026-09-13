import 'api_client.dart';


class OfferService {


  static Future<List<dynamic>> getOffers() async {


    final response =
        await ApiClient.get(
          "/api/offers",
        );


    return response;


  }



  static Future<dynamic> updateOfferStatus(
      String offerId,
      String status,
      ) async {


    return await ApiClient.put(

      "/api/offers/$offerId/status",

      {

        "status": status,

      },

    );


  }



  static Future<dynamic> createOffer(
      Map<String,dynamic> data
      ) async {


    return await ApiClient.post(

      "/api/offers",

      data,

    );


  }


}