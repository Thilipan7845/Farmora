import 'api_client.dart';


class OrderService {


  final ApiClient apiClient = ApiClient();



  Future<dynamic> getOrders() async {


    try {


      final response =
          await apiClient.get(

            "/api/orders",

          );


      return response;


    } catch (e) {


      throw Exception(
          "Failed to load orders: $e"
      );


    }

  }




  Future<dynamic> updateOrderStatus(
      String orderId,
      String status
      ) async {


    try {


      final response =
          await apiClient.post(

            "/api/orders/$orderId/status",

            {
              "status": status
            },

          );


      return response;


    } catch (e) {


      throw Exception(
          "Failed to update order status: $e"
      );


    }

  }


}