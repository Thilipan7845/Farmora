import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';


class ApiClient {


  // ============================================================
  // BACKEND URL
  // ============================================================

  static const String baseUrl =
      "http://127.0.0.1:8000";



  // ============================================================
  // SUPABASE ACCESS TOKEN
  // ============================================================

  static String? accessToken;



  // ============================================================
  // HEADERS
  // ============================================================

  static Map<String, String> get headers {


    final session =
        Supabase.instance.client.auth.currentSession;


    final token =
        session?.accessToken ?? accessToken;



    return {


      "Content-Type":
      "application/json",



      if(token != null && token.isNotEmpty)

        "Authorization":
        "Bearer $token",


    };


  }





  // ============================================================
  // GET
  // ============================================================


  static Future<dynamic> get(
      String endpoint
      ) async {


    try {


      final response =
      await http.get(

        Uri.parse(
          "$baseUrl$endpoint",
        ),

        headers: headers,

      ).timeout(

        const Duration(seconds:20),

      );



      return _handleResponse(response);


    }

    catch(e){

      throw Exception(
        "GET request failed: $e",
      );

    }


  }






  // ============================================================
  // POST
  // ============================================================


  static Future<dynamic> post(

      String endpoint,

      Map<String,dynamic> body,

      ) async {


    try{


      final response =
      await http.post(


        Uri.parse(
          "$baseUrl$endpoint",
        ),


        headers: headers,


        body:

        jsonEncode(body),


      ).timeout(

        const Duration(seconds:20),

      );



      return _handleResponse(response);



    }

    catch(e){


      throw Exception(
        "POST request failed: $e",
      );


    }


  }






  // ============================================================
  // PUT
  // ============================================================


  static Future<dynamic> put(

      String endpoint,

      Map<String,dynamic> body,

      ) async {


    try{


      final response =
      await http.put(


        Uri.parse(
          "$baseUrl$endpoint",
        ),


        headers: headers,


        body:

        jsonEncode(body),


      ).timeout(

        const Duration(seconds:20),

      );



      return _handleResponse(response);



    }

    catch(e){


      throw Exception(
        "PUT request failed: $e",
      );


    }


  }







  // ============================================================
  // DELETE
  // ============================================================


  static Future<dynamic> delete(

      String endpoint

      ) async {


    try{


      final response =
      await http.delete(


        Uri.parse(
          "$baseUrl$endpoint",
        ),


        headers: headers,


      ).timeout(

        const Duration(seconds:20),

      );



      return _handleResponse(response);



    }

    catch(e){


      throw Exception(
        "DELETE request failed: $e",
      );


    }


  }








  // ============================================================
  // RESPONSE HANDLER
  // ============================================================


  static dynamic _handleResponse(

      http.Response response,

      ){


    final status =
        response.statusCode;



    dynamic data;



    if(response.body.isNotEmpty){


      try{


        data =
            jsonDecode(response.body);


      }

      catch(_){


        data =
            response.body;


      }


    }





    if(status >= 200 && status < 300){


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