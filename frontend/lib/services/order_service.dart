import 'api_client.dart';


class OrderService {


  // ============================================================
  // GET ORDERS FOR LOGGED-IN FARMER
  // ============================================================

  static Future<List<dynamic>> getOrders() async {


    final response =
        await ApiClient.get(

          "/api/orders/farmer",

        );



    if(response is Map<String,dynamic>){


      final orders =
          response["orders"];



      if(orders is List){

        return orders;

      }


    }




    if(response is List){

      return response;

    }





    throw Exception(
      "Invalid orders response",
    );


  }







  // ============================================================
  // GET SINGLE ORDER
  // ============================================================

  static Future<dynamic> getOrder(

      String orderId

      ) async {


    return await ApiClient.get(

      "/api/orders/$orderId",

    );


  }







  // ============================================================
  // UPDATE ORDER STATUS
  // ============================================================

  static Future<dynamic> updateOrderStatus(

      String orderId,

      String status,

      ) async {


    return await ApiClient.put(

      "/api/orders/$orderId/status",

      {

        "status": status,

      },

    );


  }







  // ============================================================
  // CREATE ORDER
  // ============================================================

  static Future<dynamic> createOrder(

      Map<String,dynamic> data,

      ) async {


    return await ApiClient.post(

      "/api/orders",

      data,

    );


  }


}