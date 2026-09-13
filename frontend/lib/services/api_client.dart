import 'dart:convert';

import 'package:http/http.dart' as http;


class ApiClient {


  // Replace this with your FastAPI backend URL
  // Example:
  // http://10.0.2.2:8000  (Android emulator)
  // http://localhost:8000 (Web/Desktop)

static const String baseUrl =
    "http://YOUR_BACKEND_IP:8000";


  // Supabase JWT access token
  static String? accessToken;



  static Map<String, String> get headers {

    return {

      "Content-Type":
          "application/json",


      if (accessToken != null)
        "Authorization":
            "Bearer $accessToken",

    };

  }




  // GET request

  static Future<dynamic> get(
      String endpoint) async {


    try {

      final response =
          await http.get(

        Uri.parse(
            "$baseUrl$endpoint"),

        headers:
            headers,

      ).timeout(
        const Duration(seconds: 20),
      );


      return _handleResponse(response);


    } catch (e) {

      throw Exception(
        "GET request failed: $e",
      );

    }

  }





  // POST request

  static Future<dynamic> post(
      String endpoint,
      Map<String, dynamic> body) async {


    try {


      final response =
          await http.post(


        Uri.parse(
            "$baseUrl$endpoint"),


        headers:
            headers,


        body:
            jsonEncode(body),


      ).timeout(
        const Duration(seconds:20),
      );



      return _handleResponse(response);



    } catch(e){

      throw Exception(
        "POST request failed: $e",
      );

    }

  }





  // PUT request

  static Future<dynamic> put(
      String endpoint,
      Map<String,dynamic> body) async {



    try {


      final response =
          await http.put(


        Uri.parse(
            "$baseUrl$endpoint"),


        headers:
            headers,


        body:
            jsonEncode(body),


      ).timeout(
        const Duration(seconds:20),
      );



      return _handleResponse(response);



    } catch(e){

      throw Exception(
        "PUT request failed: $e",
      );

    }


  }





  // DELETE request

  static Future<dynamic> delete(
      String endpoint) async {


    try {


      final response =
          await http.delete(


        Uri.parse(
            "$baseUrl$endpoint"),


        headers:
            headers,


      ).timeout(
        const Duration(seconds:20),
      );



      return _handleResponse(response);



    } catch(e){

      throw Exception(
        "DELETE request failed: $e",
      );

    }

  }





  // Response handler

  static dynamic _handleResponse(
      http.Response response) {


    final status =
        response.statusCode;



    dynamic data;



    if(response.body.isNotEmpty){

      data =
          jsonDecode(response.body);

    }





    if(status >= 200 &&
       status < 300){


      return data ?? {};

    }




    if(data is Map &&
        data.containsKey("detail")){


      throw Exception(
        data["detail"],
      );


    }



    throw Exception(
      "Server error: $status",
    );


  }


}