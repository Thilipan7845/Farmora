import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../services/auth_service.dart';

import '../farmer/farmer_dashboard_screen.dart';
import '../fpo/fpo_dashboard_screen.dart';
import '../buyer/buyer_dashboard_screen.dart';

import 'forgot_password_screen.dart';
import 'register_screen.dart';



class LoginScreen extends StatefulWidget {

  const LoginScreen({
    super.key,
  });


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
  void dispose(){

    emailController.dispose();

    passwordController.dispose();

    super.dispose();

  }







  Future<void> _login() async {


    if(!_formKey.currentState!.validate()){

      return;

    }



    setState(() {

      isLoading = true;

    });





    try {



      await AuthService.login(

        emailController.text.trim(),

        passwordController.text.trim(),

      );





      final session =
          Supabase.instance.client.auth.currentSession;




      if(session == null ||
          session.accessToken.isEmpty){


        throw Exception(
          "Authentication session not created",
        );


      }





      final user =
          await AuthService.getCurrentUser();





      final role =
          user["role"];





      if(!mounted) return;





      switch(role){


        case "farmer":


          Navigator.pushReplacement(

            context,

            MaterialPageRoute(

              builder: (_) =>
              const FarmerDashboardScreen(),

            ),

          );


          break;




        case "fpo":


          Navigator.pushReplacement(

            context,

            MaterialPageRoute(

              builder: (_) =>
              const FpoDashboardScreen(),

            ),

          );


          break;




        case "buyer":


          Navigator.pushReplacement(

            context,

            MaterialPageRoute(

              builder: (_) =>
              const BuyerDashboardScreen(),

            ),

          );


          break;




        default:

          throw Exception(
            "Invalid user role",
          );


      }



    }


    catch(e){


      if(!mounted) return;



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



    finally{


      if(mounted){

        setState(() {

          isLoading = false;

        });


      }


    }


  }








  @override
  Widget build(BuildContext context){



    final local =
    AppLocalizations.of(context);



    return Scaffold(



      backgroundColor:
      AppColors.background,



      body:

      SafeArea(



        child:

        LayoutBuilder(



          builder:(context,constraints){



            final desktop =
                constraints.maxWidth > 700;





            return Center(



              child:

              SingleChildScrollView(



                padding:

                EdgeInsets.symmetric(

                  horizontal:

                  desktop ? 0 : 24,

                  vertical:40,

                ),




                child:

                Container(



                  width:

                  desktop ? 450 : double.infinity,




                  padding:

                  const EdgeInsets.all(32),





                  decoration:

                  BoxDecoration(



                    color:
                    Colors.white,



                    borderRadius:
                    BorderRadius.circular(28),



                    boxShadow:[


                      BoxShadow(

                        color:
                        Colors.black
                            .withValues(
                          alpha:0.06,
                        ),


                        blurRadius:25,


                        offset:
                        const Offset(
                          0,
                          10,
                        ),


                      )

                    ],


                  ),





                  child:

                  Form(



                    key:
                    _formKey,



                    child:

                    Column(



                      mainAxisSize:
                      MainAxisSize.min,



                      children:[




                        Image.asset(

                          "assets/farmora_logo.png",

                          height:110,

                        ),




                        const SizedBox(
                          height:24,
                        ),




                        Text(


                          local.welcome,


                          textAlign:
                          TextAlign.center,


                          style:

                          const TextStyle(

                            fontSize:30,

                            fontWeight:
                            FontWeight.bold,

                            color:
                            AppColors.textPrimary,

                          ),


                        ),





                        const SizedBox(
                          height:8,
                        ),





                        Text(


                          local.loginSubtitle,


                          textAlign:
                          TextAlign.center,


                          style:

                          const TextStyle(

                            color:
                            AppColors.textSecondary,

                          ),


                        ),





                        const SizedBox(
                          height:35,
                        ),





                        TextFormField(



                          controller:
                          emailController,



                          keyboardType:
                          TextInputType.emailAddress,



                          decoration:

                          InputDecoration(



                            hintText:
                            local.emailHint,



                            prefixIcon:
                            const Icon(
                              Icons.email_outlined,
                            ),



                            filled:true,



                            fillColor:
                            AppColors.background,



                            border:

                            OutlineInputBorder(

                              borderRadius:
                              BorderRadius.circular(16),


                              borderSide:
                              BorderSide.none,

                            ),



                          ),




                          validator:(value){


                            if(value == null ||
                                value.isEmpty){

                              return local.enterEmail;

                            }


                            return null;

                          },



                        ),





                        const SizedBox(
                          height:20,
                        ),






                        TextFormField(



                          controller:
                          passwordController,



                          obscureText:
                          obscurePassword,



                          decoration:

                          InputDecoration(



                            hintText:
                            local.passwordHint,



                            prefixIcon:
                            const Icon(
                              Icons.lock_outline,
                            ),



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
                            AppColors.background,



                            border:

                            OutlineInputBorder(

                              borderRadius:
                              BorderRadius.circular(16),

                              borderSide:
                              BorderSide.none,

                            ),



                          ),





                          validator:(value){


                            if(value == null ||
                                value.length < 6){


                              return local.passwordLength;


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
                              local.forgotPassword,
                            ),


                          ),


                        ),





                        const SizedBox(
                          height:10,
                        ),






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
                              local.login,
                            ),



                          ),



                        ),






                        const SizedBox(
                          height:25,
                        ),






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

                            '${local.noAccount} ${local.createAccount}',

                          ),



                        )




                      ],


                    ),



                  ),



                ),


              ),


            );


          },


        ),


      ),


    );


  }



}