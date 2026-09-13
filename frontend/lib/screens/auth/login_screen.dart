import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';
import '../../services/auth_service.dart';

import '../farmer/farmer_dashboard_screen.dart';
import '../fpo/fpo_dashboard_screen.dart';
import '../buyer/buyer_dashboard_screen.dart';

import 'forgot_password_screen.dart';
import 'register_screen.dart';



class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});


  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();

}




class _LoginScreenState
    extends State<LoginScreen> {


  final _formKey =
      GlobalKey<FormState>();


  final TextEditingController emailController =
      TextEditingController();


  final TextEditingController passwordController =
      TextEditingController();



  bool obscurePassword = true;



  bool isLoading = false;




  @override
  void dispose() {

    emailController.dispose();

    passwordController.dispose();

    super.dispose();

  }





  Future<void> _login() async {


    if(!_formKey.currentState!.validate()) {

      return;

    }



    setState(() {

      isLoading = true;

    });



    try {


      // Supabase Login
      await AuthService.login(

        emailController.text.trim(),

        passwordController.text.trim(),

      );



      // Get role from FastAPI
      final user =
          await AuthService.getCurrentUser();



      final role =
          user["role"];



      if(!mounted) return;



      if(role == "farmer") {


        Navigator.pushReplacement(

          context,

          MaterialPageRoute(

            builder: (_) =>
                const FarmerDashboardScreen(),

          ),

        );


      }


      else if(role == "fpo") {


        Navigator.pushReplacement(

          context,

          MaterialPageRoute(

            builder: (_) =>
                const FpoDashboardScreen(),

          ),

        );


      }


      else if(role == "buyer") {


        Navigator.pushReplacement(

          context,

          MaterialPageRoute(

            builder: (_) =>
                const BuyerDashboardScreen(),

          ),

        );


      }


      else {


        throw Exception(
          "Invalid user role",
        );


      }



    }

    catch(e) {


      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content:
              Text(
                e.toString(),
              ),

        ),

      );


    }


    finally {


      if(mounted){

        setState(() {

          isLoading = false;

        });

      }


    }


  }






  @override
  Widget build(BuildContext context) {


    final localizations =
        AppLocalizations.of(context);



    return Scaffold(

      backgroundColor:
          const Color(0xFFF7FAF7),



      body: SafeArea(

        child:
        SingleChildScrollView(


          padding:
              const EdgeInsets.symmetric(
                horizontal:24,
              ),



          child:
          Form(

            key:
                _formKey,



            child:
            Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,


              children:[


                const SizedBox(height:55),



                Center(

                  child:
                  Container(

                    width:75,

                    height:75,


                    decoration:
                    BoxDecoration(

                      color:
                      const Color(0xFFE8F5E9),

                      borderRadius:
                      BorderRadius.circular(22),

                    ),


                    child:
                    const Icon(

                      Icons.eco_rounded,

                      size:42,

                      color:
                      Color(0xFF2E7D32),

                    ),

                  ),

                ),




                const SizedBox(height:28),




                Center(

                  child:
                  Text(

                    localizations.welcome,

                    style:
                    const TextStyle(

                      fontSize:27,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),

                ),




                const SizedBox(height:45),




                TextFormField(

                  controller:
                      emailController,


                  decoration:
                  InputDecoration(

                    hintText:
                    localizations.emailHint,


                    prefixIcon:
                    const Icon(
                        Icons.email_outlined),


                    filled:true,

                    fillColor:
                    Colors.white,


                    border:
                    OutlineInputBorder(

                      borderRadius:
                      BorderRadius.circular(14),

                      borderSide:
                      BorderSide.none,

                    ),

                  ),



                  validator:(value){

                    if(value==null ||
                        value.isEmpty){

                      return localizations.enterEmail;

                    }


                    return null;

                  },

                ),





                const SizedBox(height:22),





                TextFormField(

                  controller:
                      passwordController,


                  obscureText:
                      obscurePassword,



                  decoration:
                  InputDecoration(

                    hintText:
                    localizations.passwordHint,


                    prefixIcon:
                    const Icon(
                        Icons.lock_outline),



                    suffixIcon:
                    IconButton(

                      icon:
                      Icon(

                        obscurePassword

                            ?
                        Icons.visibility_outlined

                            :
                        Icons.visibility_off_outlined,

                      ),



                      onPressed:(){

                        setState(() {

                          obscurePassword =
                              !obscurePassword;

                        });


                      },


                    ),


                    filled:true,

                    fillColor:
                    Colors.white,


                    border:
                    OutlineInputBorder(

                      borderRadius:
                      BorderRadius.circular(14),

                      borderSide:
                      BorderSide.none,

                    ),

                  ),



                  validator:(value){

                    if(value==null ||
                        value.length < 6){

                      return localizations.passwordLength;

                    }


                    return null;

                  },

                ),





                Align(

                  alignment:
                  Alignment.centerRight,


                  child:
                  TextButton(

                    onPressed:(){

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder:(_)=>
                          const ForgotPasswordScreen(),

                        ),

                      );

                    },


                    child:
                    Text(
                      localizations.forgotPassword,
                    ),

                  ),

                ),





                const SizedBox(height:18),





                SizedBox(

                  width:
                  double.infinity,


                  height:
                  54,


                  child:
                  ElevatedButton(


                    onPressed:
                    isLoading
                        ?
                        null
                        :
                    _login,



                    child:
                    isLoading

                        ?
                    const CircularProgressIndicator(
                      color:Colors.white,
                    )

                        :
                    Text(
                      localizations.login,
                    ),


                  ),

                ),






                const SizedBox(height:28),





                Center(

                  child:
                  TextButton(

                    onPressed:(){

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder:(_)=>
                          const RegisterScreen(),

                        ),

                      );

                    },


                    child:
                    Text(

                      '${localizations.noAccount} ${localizations.createAccount}',

                    ),

                  ),

                ),



              ],

            ),

          ),


        ),

      ),

    );

  }


}