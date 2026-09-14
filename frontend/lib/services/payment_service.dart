import 'api_client.dart';


class PaymentService {


  final ApiClient apiClient = ApiClient();



  Future<dynamic> getPayments() async {


    try {


      final response =
          await apiClient.get(

            "/api/payments",

          );


      return response;


    } catch (e) {


      throw Exception(
          "Failed to load payments: $e"
      );


    }

  }




  Future<dynamic> updatePaymentStatus(
      String paymentId,
      String status
      ) async {


    try {


      final response =
          await apiClient.post(

            "/api/payments/$paymentId/status",

            {
              "status": status
            },

          );


      return response;


    } catch(e){


      throw Exception(
          "Failed to update payment status: $e"
      );


    }

  }


}