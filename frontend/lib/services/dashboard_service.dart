import 'api_client.dart';


class DashboardService {


  static Future<dynamic> getStats() async {


    return await ApiClient.get(
      "/api/dashboard/stats",
    );


  }


}