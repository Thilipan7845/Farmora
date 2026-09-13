import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';
import '../role_registration/role_registration_screen.dart';
import 'terms_pdf_screen.dart';


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


  late final TextEditingController
      _emailController;


  final _nameController =
      TextEditingController();


  final _mobileController =
      TextEditingController();


  final _passwordController =
      TextEditingController();


  final _confirmPasswordController =
      TextEditingController();



  bool _obscurePassword = true;

  bool _obscureConfirmPassword = true;


  bool _termsAccepted = false;



  @override
  void initState() {

    super.initState();


    _emailController =
        TextEditingController(
      text: widget.prefilledEmail ?? '',
    );

  }



  @override
  void dispose() {

    _emailController.dispose();

    _nameController.dispose();

    _mobileController.dispose();

    _passwordController.dispose();

    _confirmPasswordController.dispose();

    super.dispose();

  }




  Future<void> _openTerms() async {


    final accepted =
        await Navigator.push<bool>(
      context,

      MaterialPageRoute(

        builder: (_) =>
            const TermsPdfScreen(),

      ),

    );


    if(!mounted) return;



    if(accepted == true){

      setState(() {

        _termsAccepted = true;

      });

    }

  }





  void _createAccount(){


    if(!_formKey.currentState!.validate()){

      return;

    }



    if(!_termsAccepted){


      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            'Please read and accept the Terms & Conditions.',
          ),

        ),

      );


      return;

    }



    // Next step:
    // Role based registration
    //
    // Farmer Registration
    // FPO Registration
    // Buyer Registration


    Navigator.pushReplacement(

      context,

      MaterialPageRoute(

        builder: (_) =>
            const RoleRegistrationScreen(),

      ),

    );


  }






  @override
  Widget build(BuildContext context) {


    final local =
        AppLocalizations.of(context);



    return Scaffold(

      appBar: AppBar(

        title:
            Text(local.registerTitle),

        centerTitle: true,

      ),



      body: SafeArea(

        child: Form(

          key: _formKey,


          child: SingleChildScrollView(

            padding:
                const EdgeInsets.all(24),


            child: Column(


              crossAxisAlignment:
                  CrossAxisAlignment.start,


              children: [


                Text(

                  local.registerTitle,

                  style:
                      const TextStyle(

                    fontSize: 30,

                    fontWeight:
                        FontWeight.bold,

                  ),

                ),



                const SizedBox(height:8),



                Text(

                  local.registerSubtitle,

                  style:

                      TextStyle(

                    fontSize:16,

                    color:
                        Colors.grey.shade600,

                  ),

                ),




                const SizedBox(height:28),



                _field(

                  controller:
                      _nameController,

                  label:
                      local.fullName,

                  hint:
                      local.fullNameHint,

                  icon:
                      Icons.person_outline,

                ),




                _field(

                  controller:
                      _mobileController,

                  label:
                      local.mobileNumber,

                  hint:
                      local.mobileHint,

                  icon:
                      Icons.phone_outlined,

                  keyboardType:
                      TextInputType.phone,

                ),





                _field(

                  controller:
                      _emailController,

                  label:
                      "Email",

                  hint:
                      "Enter your email",

                  icon:
                      Icons.email_outlined,

                  keyboardType:
                      TextInputType.emailAddress,

                ),





                _passwordField(),





                _confirmPasswordField(),




                const SizedBox(height:20),




                Container(

                  padding:
                      const EdgeInsets.all(14),


                  decoration:
                      BoxDecoration(

                    borderRadius:
                        BorderRadius.circular(14),


                    border:
                        Border.all(

                      color:
                      _termsAccepted

                          ? Theme.of(context)
                          .colorScheme
                          .primary

                          :
                      Colors.grey.shade300,

                    ),

                  ),



                  child: Row(

                    children:[



                      Checkbox(

                        value:
                            _termsAccepted,

                        onChanged:
                            null,

                      ),



                      Expanded(

                        child:
                        RichText(

                          text:
                          TextSpan(

                            style:
                            Theme.of(context)
                            .textTheme
                            .bodyMedium,


                            children:[


                              TextSpan(

                                text:
                                '${local.terms} ',

                              ),



                              TextSpan(

                                text:
                                local.agreeTerms,


                                style:
                                TextStyle(

                                  color:
                                  Theme.of(context)
                                  .colorScheme
                                  .primary,


                                  fontWeight:
                                  FontWeight.bold,


                                  decoration:
                                  TextDecoration.underline,

                                ),



                                recognizer:
                                TapGestureRecognizer()

                                  ..onTap =
                                      _openTerms,


                              ),


                            ],


                          ),


                        ),

                      ),


                    ],


                  ),


                ),





                const SizedBox(height:10),




                SizedBox(

                  width:
                      double.infinity,


                  child:
                  TextButton.icon(

                    onPressed:
                        _openTerms,


                    icon:
                    const Icon(
                        Icons.description_outlined),


                    label:
                    const Text(
                      'Read Terms & Conditions',
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
                    _termsAccepted

                        ? _createAccount

                        : null,



                    child:
                    Text(

                      local.createAccountButton,

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






  Widget _field({

    required TextEditingController controller,

    required String label,

    required String hint,

    required IconData icon,

    TextInputType? keyboardType,


  }){


    return Padding(

      padding:
          const EdgeInsets.only(bottom:16),


      child:
      TextFormField(

        controller:
            controller,


        keyboardType:
            keyboardType,


        decoration:
        InputDecoration(

          labelText:
              label,


          hintText:
              hint,


          prefixIcon:
              Icon(icon),


          border:
          OutlineInputBorder(

            borderRadius:
            BorderRadius.circular(14),

          ),

        ),



        validator:(value){

          if(value==null ||
              value.trim().isEmpty){

            return
            "Please enter $label";

          }


          return null;

        },


      ),

    );


  }






  Widget _passwordField(){

    return TextFormField(

      controller:
          _passwordController,


      obscureText:
          _obscurePassword,


      decoration:
      InputDecoration(

        labelText:
            "Password",


        prefixIcon:
            const Icon(
                Icons.lock_outline),


        suffixIcon:
        IconButton(

          icon:
          Icon(

            _obscurePassword

                ?
            Icons.visibility

                :
            Icons.visibility_off,

          ),


          onPressed:(){

            setState((){

              _obscurePassword =
                  !_obscurePassword;

            });

          },


        ),


        border:
        OutlineInputBorder(

          borderRadius:
          BorderRadius.circular(14),

        ),

      ),


      validator:(value){

        if(value==null ||
            value.length<6){

          return
          "Password must contain 6 characters";

        }

        return null;

      },


    );

  }






  Widget _confirmPasswordField(){


    return Padding(

      padding:
      const EdgeInsets.only(top:16),


      child:
      TextFormField(

        controller:
        _confirmPasswordController,


        obscureText:
        _obscureConfirmPassword,


        decoration:
        InputDecoration(

          labelText:
          "Confirm Password",


          prefixIcon:
          const Icon(
              Icons.lock_reset),


          border:
          OutlineInputBorder(

            borderRadius:
            BorderRadius.circular(14),

          ),

        ),


        validator:(value){

          if(value !=
              _passwordController.text){

            return
            "Password mismatch";

          }


          return null;

        },


      ),

    );


  }


}