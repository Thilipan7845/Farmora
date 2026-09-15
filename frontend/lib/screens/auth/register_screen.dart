import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


import '../../core/theme/app_colors.dart';


import '../../widgets/farmora_register_hero.dart';
import '../../widgets/register_input_field.dart';
import '../../widgets/terms_checkbox.dart';
import '../../widgets/terms_condition_dialog.dart';


import '../role_registration/role_registration_screen.dart';



class RegisterScreen extends StatefulWidget {


  final String? prefilledEmail;



  const RegisterScreen({

    super.key,

    this.prefilledEmail,

  });



  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();


}






class _RegisterScreenState
    extends State<RegisterScreen> {



  final _formKey =
      GlobalKey<FormState>();



  late TextEditingController emailController;


  final nameController =
      TextEditingController();



  final mobileController =
      TextEditingController();



  final passwordController =
      TextEditingController();



  final confirmPasswordController =
      TextEditingController();





  bool obscurePassword = true;

  bool obscureConfirmPassword = true;


  bool termsAccepted = false;


  bool loading = false;







  @override
  void initState(){

    super.initState();


    emailController =
        TextEditingController(

          text:
          widget.prefilledEmail ?? '',

        );


  }





  @override
  void dispose(){


    emailController.dispose();

    nameController.dispose();

    mobileController.dispose();

    passwordController.dispose();

    confirmPasswordController.dispose();


    super.dispose();

  }







  Future<void> openTerms() async {



    final accepted =
    await showTermsConditionDialog(
      context,
    );



    if(accepted == true){


      setState(() {


        termsAccepted = true;


      });


    }



  }







  Future<void> createAccount() async {



    if(!_formKey.currentState!.validate()){

      return;

    }




    if(!termsAccepted){


      ScaffoldMessenger.of(context)
          .showSnackBar(


        const SnackBar(

          content:

          Text(
            "Please accept Terms & Conditions",
          ),

        ),


      );


      return;

    }





    setState(() {


      loading = true;


    });





    try{



      final response =

      await Supabase.instance.client.auth.signUp(



        email:

        emailController.text.trim(),



        password:

        passwordController.text.trim(),



        data:{


          "full_name":

          nameController.text.trim(),



          "phone":

          mobileController.text.trim(),



        },


      );






      if(response.session == null){


        throw Exception(

          "Account created. Please verify email.",

        );


      }







      if(!mounted) return;






      Navigator.pushReplacement(


        context,


        MaterialPageRoute(


          builder:(_)=>

          const RoleRegistrationScreen(),


        ),


      );




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


          loading = false;


        });


      }


    }



  }










  @override
  Widget build(BuildContext context){



    return Scaffold(



      backgroundColor:

      AppColors.background,




      body:


      SafeArea(



        child:


        LayoutBuilder(



          builder:(context,constraints){



            final desktop =

            constraints.maxWidth > 800;





            return Center(



              child:

              SingleChildScrollView(



                padding:

                const EdgeInsets.all(24),




                child:

                Container(



                  width:

                  desktop

                      ?

                  520

                      :

                  double.infinity,





                  padding:

                  const EdgeInsets.all(28),




                  decoration:


                  BoxDecoration(



                    color:

                    Colors.white,




                    borderRadius:

                    BorderRadius.circular(30),




                    boxShadow:[



                      BoxShadow(



                        color:

                        Colors.black

                            .withValues(

                          alpha:0.06,

                        ),




                        blurRadius:30,

                      )


                    ],


                  ),




                  child:


                  Form(



                    key:

                    _formKey,




                    child:


                    Column(



                      children:[





                        const FarmoraRegisterHero(),




                        const SizedBox(

                          height:30,

                        ),






                        RegisterInputField(



                          controller:

                          nameController,



                          label:

                          "Full Name",



                          icon:

                          Icons.person_outline,



                          validator:(v){



                            if(v == null ||

                                v.trim().isEmpty){


                              return "Enter name";


                            }


                            return null;


                          },


                        ),






                        const SizedBox(

                          height:16,

                        ),






                        RegisterInputField(



                          controller:

                          mobileController,



                          label:

                          "Mobile Number",



                          icon:

                          Icons.phone_outlined,



                          keyboardType:

                          TextInputType.phone,


                        ),







                        const SizedBox(

                          height:16,

                        ),







                        RegisterInputField(



                          controller:

                          emailController,



                          label:

                          "Email",



                          icon:

                          Icons.email_outlined,



                          keyboardType:

                          TextInputType.emailAddress,



                          validator:(v){


                            if(v == null ||

                                v.isEmpty){


                              return "Enter email";


                            }


                            return null;


                          },


                        ),








                        const SizedBox(

                          height:16,

                        ),






                        RegisterInputField(



                          controller:

                          passwordController,



                          label:

                          "Password",



                          icon:

                          Icons.lock_outline,



                          obscure:

                          obscurePassword,



                          suffix:

                          IconButton(


                            icon:

                            Icon(

                              obscurePassword

                                  ?

                              Icons.visibility

                                  :

                              Icons.visibility_off,

                            ),



                            onPressed:(){


                              setState((){


                                obscurePassword =

                                !obscurePassword;


                              });


                            },



                          ),




                          validator:(v){



                            if(v == null ||

                                v.length < 6){


                              return

                                  "Minimum 6 characters";


                            }


                            return null;


                          },



                        ),






                        const SizedBox(

                          height:16,

                        ),







                        RegisterInputField(



                          controller:

                          confirmPasswordController,



                          label:

                          "Confirm Password",



                          icon:

                          Icons.lock_reset,



                          obscure:

                          obscureConfirmPassword,




                          suffix:

                          IconButton(


                            icon:

                            Icon(

                              obscureConfirmPassword

                                  ?

                              Icons.visibility

                                  :

                              Icons.visibility_off,

                            ),




                            onPressed:(){



                              setState((){


                                obscureConfirmPassword =

                                !obscureConfirmPassword;


                              });


                            },



                          ),




                          validator:(v){



                            if(v != passwordController.text){


                              return "Password mismatch";


                            }


                            return null;


                          },



                        ),






                        const SizedBox(

                          height:20,

                        ),







                        TermsCheckbox(



                          accepted:

                          termsAccepted,



                          onTap:(){



                            setState((){


                              termsAccepted =

                              !termsAccepted;


                            });



                          },



                          onTermsTap:

                          openTerms,


                        ),







                        const SizedBox(

                          height:25,

                        ),








                        SizedBox(



                          width:

                          double.infinity,



                          height:

                          55,



                          child:


                          ElevatedButton(



                            onPressed:

                            loading

                                ?

                            null

                                :

                            createAccount,



                            child:

                            loading

                                ?

                            const CircularProgressIndicator(

                              color:

                              Colors.white,

                            )


                                :

                            const Text(

                              "Create Account",

                              style:

                              TextStyle(

                                fontSize:16,

                                fontWeight:

                                FontWeight.bold,

                              ),

                            ),



                          ),



                        ),



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