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
  // FALLBACK TOKEN STORAGE
  // ============================================================


  static String? accessToken;






  // ============================================================
  // GET CURRENT TOKEN
  // ============================================================


  static String? get token {


    final session =
        Supabase.instance.client.auth.currentSession;



    final supabaseToken =
        session?.accessToken;



    if(supabaseToken != null &&
        supabaseToken.isNotEmpty){


      return supabaseToken;


    }



    return accessToken;


  }








  // ============================================================
  // HEADERS
  // ============================================================


  static Map<String,String> get headers {



    final jwt =
        token;



    print("==============================");
    print("API REQUEST");
    print(
      "SESSION EXISTS: ${Supabase.instance.client.auth.currentSession != null}",
    );
    print("TOKEN:");
    print(jwt);
    print("==============================");




    return {


      "Content-Type":
      "application/json",



      if(jwt != null &&
          jwt.isNotEmpty)


        "Authorization":
        "Bearer $jwt",


    };


  }










  // ============================================================
  // GET
  // ============================================================


  static Future<dynamic> get(
      String endpoint,
      ) async {


    try{


      final response =
      await http.get(

        Uri.parse(
          "$baseUrl$endpoint",
        ),

        headers:
        headers,

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


      print("POST:");
      print("$baseUrl$endpoint");



      final response =
      await http.post(

        Uri.parse(
          "$baseUrl$endpoint",
        ),


        headers:
        headers,


        body:
        jsonEncode(body),


      ).timeout(

        const Duration(seconds:20),

      );



      print("STATUS:");
      print(response.statusCode);

      print("BODY:");
      print(response.body);



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


    final response =
    await http.put(

      Uri.parse(
        "$baseUrl$endpoint",
      ),


      headers:
      headers,


      body:
      jsonEncode(body),


    ).timeout(

      const Duration(seconds:20),

    );



    return _handleResponse(response);


  }









  // ============================================================
  // DELETE
  // ============================================================


  static Future<dynamic> delete(

      String endpoint,

      ) async {


    final response =
    await http.delete(

      Uri.parse(
        "$baseUrl$endpoint",
      ),

      headers:
      headers,


    ).timeout(

      const Duration(seconds:20),

    );



    return _handleResponse(response);


  }









  // ============================================================
  // RESPONSE HANDLER
  // ============================================================


  static dynamic _handleResponse(
      http.Response response,
      ){



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





    if(response.statusCode >=200 &&
        response.statusCode <300){


      return data ?? {};


    }





    if(data is Map &&
        data["detail"] != null){


      throw Exception(
        data["detail"],
      );


    }



    throw Exception(
      "Server error: ${response.statusCode}",
    );



  }


}