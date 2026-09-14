import 'api_client.dart';


class PaymentService {


  // ============================================================
  // FARMER PAYMENT SUMMARY
  // ============================================================

  static Future<Map<String, dynamic>>
      getFarmerPaymentSummary() async {


    final response =
        await ApiClient.get(
          "/api/payments/farmer",
        );


    if(response is Map<String,dynamic>){

      return response;

    }


    throw Exception(
      "Invalid payment summary response",
    );


  }

}