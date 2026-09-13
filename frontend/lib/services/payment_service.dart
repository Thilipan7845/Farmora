import 'api_client.dart';


class PaymentService {


  static Future<List<dynamic>> getPayments() async {


    final response =
        await ApiClient.get(
          "/api/payments",
        );


    return response;


  }



  static Future<dynamic> getPayment(
      String id
      ) async {


    return await ApiClient.get(

      "/api/payments/$id",

    );


  }



  static Future<dynamic> createPayment(

      Map<String,dynamic> data

      ) async {


    return await ApiClient.post(

      "/api/payments",

      data,

    );


  }



  static Future<dynamic> updatePaymentStatus(

      String id,

      String status,

      ) async {


    return await ApiClient.put(

      "/api/payments/$id/status",

      {

        "status": status,

      },

    );


  }


}