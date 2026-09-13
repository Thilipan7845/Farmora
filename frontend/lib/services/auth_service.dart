import 'package:supabase_flutter/supabase_flutter.dart';

import 'api_client.dart';



class AuthService {


  static final SupabaseClient supabase =
      Supabase.instance.client;




  // Login using Supabase email/password

  static Future<void> login(
      String email,
      String password,
      ) async {


    final AuthResponse response =
        await supabase.auth.signInWithPassword(

      email: email,

      password: password,

    );



    final Session? session =
        response.session;



    if(session == null){

      throw Exception(
        "Login failed",
      );

    }



    // Store JWT token
    ApiClient.accessToken =
        session.accessToken;


  }





  // Get logged-in user role from FastAPI

  static Future<Map<String,dynamic>>
  getCurrentUser() async {


    final response =
        await ApiClient.get(

      "/api/auth/me",

    );


    return response;

  }





  // Logout

  static Future<void> logout() async {


    await supabase.auth.signOut();


    ApiClient.accessToken = null;


  }


}