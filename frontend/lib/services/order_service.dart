import 'api_client.dart';


class OrderService {


  static Future<List<dynamic>> getOrders() async {

    final response =
        await ApiClient.get(
          "/api/orders",
        );


    return response;

  }



  static Future<dynamic> getOrder(
      String orderId
      ) async {


    return await ApiClient.get(

      "/api/orders/$orderId",

    );


  }




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



  static Future<dynamic> createOrder(

      Map<String,dynamic> data

      ) async {


    return await ApiClient.post(

      "/api/orders",

      data,

    );


  }


}