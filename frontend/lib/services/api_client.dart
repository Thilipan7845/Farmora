import 'dart:convert';
import 'package:http/http.dart' as http;


class ApiClient {

  // Change this later with your backend URL
  final String baseUrl = 
      "http://YOUR_BACKEND_URL";


  Future<dynamic> get(String endpoint) async {


    final response = await http.get(

      Uri.parse(baseUrl + endpoint),

      headers: {

        "Authorization":
        "Bearer YOUR_TOKEN",

        "Content-Type":
        "application/json",

      },

    );


    return jsonDecode(response.body);

  }



  Future<dynamic> post(
      String endpoint,
      Map<String,dynamic> body
      ) async {


    final response = await http.post(

      Uri.parse(baseUrl + endpoint),

      headers: {

        "Authorization":
        "Bearer YOUR_TOKEN",

        "Content-Type":
        "application/json",

      },


      body:

      jsonEncode(body),

    );


    return jsonDecode(response.body);

  }

}