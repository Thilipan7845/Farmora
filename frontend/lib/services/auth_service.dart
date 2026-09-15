import 'package:supabase_flutter/supabase_flutter.dart';

import 'api_client.dart';



class AuthService {


  static final SupabaseClient supabase =
      Supabase.instance.client;





  // ============================================================
  // LOGIN
  // ============================================================

  static Future<void> login(
      String email,
      String password,
      ) async {


    try {


      final AuthResponse response =
      await supabase.auth.signInWithPassword(

        email: email,

        password: password,

      );



      final Session? session =
          response.session;




      print("==============================");
      print("SUPABASE LOGIN");
      print("USER:");
      print(response.user?.email);
      print("SESSION:");
      print(session);
      print("==============================");





      if(session == null){

        throw Exception(
          "Login failed: Session is null",
        );

      }





      ApiClient.accessToken =
          session.accessToken;





      print("==============================");
      print("TOKEN AFTER LOGIN");
      print(ApiClient.accessToken);
      print("==============================");



    }


    catch(e){


      throw Exception(
        "Login failed: $e",
      );


    }


  }









  // ============================================================
  // CURRENT USER
  // ============================================================

  static Future<Map<String,dynamic>> getCurrentUser() async {



    print("==============================");
    print("BEFORE /api/auth/me");
    print("TOKEN:");
    print(ApiClient.accessToken);
    print("SESSION:");
    print(supabase.auth.currentSession);
    print("==============================");





    final response =
        await ApiClient.get(

          "/api/auth/me",

        );





    print("==============================");
    print("AFTER /api/auth/me");
    print(response);
    print("==============================");






    if(response is Map<String,dynamic>){

      return response;

    }




    throw Exception(
      "Invalid user response",
    );


  }









  // ============================================================
  // CURRENT SESSION
  // ============================================================

  static Session? currentSession(){


    return supabase.auth.currentSession;


  }









  // ============================================================
  // LOGOUT
  // ============================================================


  static Future<void> logout() async {


    await supabase.auth.signOut();


    ApiClient.accessToken = null;


  }



}