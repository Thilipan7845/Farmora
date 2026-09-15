import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import 'login_screen.dart';
import 'register_screen.dart';


class AccountAccessScreen extends StatefulWidget {
  const AccountAccessScreen({super.key});

  @override
  State<AccountAccessScreen> createState() =>
      _AccountAccessScreenState();
}


class _AccountAccessScreenState
    extends State<AccountAccessScreen> {

  final _formKey = GlobalKey<FormState>();

  final _emailController =
      TextEditingController();


  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }



  void _continue() {

    if (!_formKey.currentState!.validate()) {
      return;
    }


    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RegisterScreen(
              prefilledEmail:
                  _emailController.text.trim(),
            ),
      ),
    );
  }




  void _openLogin() {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const LoginScreen(),
      ),
    );
  }





  @override
  Widget build(BuildContext context) {

    final local =
        AppLocalizations.of(context);



    return Scaffold(

      backgroundColor:
          AppColors.background,


      body: SafeArea(

        child: LayoutBuilder(

          builder: (context, constraints) {


            final isDesktop =
                constraints.maxWidth > 700;



            return Center(

              child: SingleChildScrollView(

                padding:
                    EdgeInsets.symmetric(

                  horizontal:
                      isDesktop ? 0 : 24,

                  vertical: 40,

                ),


                child: Container(

                  width:
                      isDesktop
                          ? 450
                          : double.infinity,


                  padding:
                      const EdgeInsets.all(32),



                  decoration:
                      BoxDecoration(

                    color:
                        AppColors.surface,


                    borderRadius:
                        BorderRadius.circular(28),


                    boxShadow:[

                      BoxShadow(

                        color:
                            Colors.black
                                .withValues(
                                  alpha:0.06,
                                ),

                        blurRadius:30,

                        offset:
                            const Offset(
                              0,
                              10,
                            ),

                      )

                    ],

                  ),




                  child: Form(

                    key:_formKey,


                    child: Column(

                      mainAxisSize:
                          MainAxisSize.min,


                      children:[



                        Image.asset(

                          'assets/farmora_logo.png',

                          height:
                              isDesktop
                                  ?120
                                  :100,

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
                          height:10,
                        ),





                        Text(

                          local.loginSubtitle,

                          textAlign:
                              TextAlign.center,


                          style:
                              const TextStyle(

                            fontSize:15,

                            color:
                                AppColors.textSecondary,

                          ),

                        ),






                        const SizedBox(
                          height:35,
                        ),





                        TextFormField(

                          controller:
                              _emailController,


                          keyboardType:
                              TextInputType.emailAddress,


                          decoration:
                              InputDecoration(

                            labelText:
                                local.email,


                            hintText:
                                local.emailHint,


                            prefixIcon:
                                const Icon(
                                  Icons
                                  .email_outlined,
                                ),

                            filled:true,

                            fillColor:
                                AppColors.background,


                            border:
                                OutlineInputBorder(

                              borderRadius:
                                  BorderRadius.circular(
                                    16,
                                  ),

                              borderSide:
                                  BorderSide.none,

                            ),

                          ),




                          validator:(value){


                            if(value == null ||
                                value.trim().isEmpty){

                              return local.enterEmail;

                            }


                            if(!RegExp(

                              r'^[^@\s]+@[^@\s]+\.[^@\s]+$',

                            ).hasMatch(
                                value.trim())){


                              return local.invalidEmail;

                            }


                            return null;

                          },


                        ),





                        const SizedBox(
                          height:24,
                        ),






                        SizedBox(

                          width:
                              double.infinity,


                          height:
                              54,


                          child:
                              ElevatedButton(

                            onPressed:
                                _continue,


                            child:
                                Text(

                              local.continueText,


                              style:
                                  const TextStyle(

                                fontSize:16,

                                fontWeight:
                                    FontWeight.w600,

                              ),

                            ),

                          ),

                        ),






                        const SizedBox(
                          height:28,
                        ),






                        Row(

                          children:[

                            Expanded(
                              child:
                                  Divider(
                                color:
                                    AppColors.border,
                              ),
                            ),


                            const Padding(

                              padding:
                                  EdgeInsets.symmetric(
                                    horizontal:12,
                                  ),

                              child:
                                  Text(
                                    "OR",
                                  ),

                            ),


                            Expanded(
                              child:
                                  Divider(
                                color:
                                    AppColors.border,
                              ),
                            ),

                          ],

                        ),





                        const SizedBox(
                          height:28,
                        ),





                        SizedBox(

                          width:
                              double.infinity,


                          height:
                              54,


                          child:
                              OutlinedButton(

                            onPressed:
                                _openLogin,


                            child:
                                Text(

                              local.login,


                              style:
                                  const TextStyle(

                                fontSize:16,

                                fontWeight:
                                    FontWeight.w600,

                                color:
                                    AppColors.primary,

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