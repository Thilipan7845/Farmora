import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';


class RegisterInputField extends StatelessWidget {


  final TextEditingController controller;

  final String label;

  final IconData icon;

  final bool obscure;

  final Widget? suffix;

  final TextInputType? keyboardType;

  final String? Function(String?)? validator;



  const RegisterInputField({

    super.key,

    required this.controller,

    required this.label,

    required this.icon,

    this.obscure = false,

    this.suffix,

    this.keyboardType,

    this.validator,

  });




  @override
  Widget build(BuildContext context) {


    return TextFormField(

      controller: controller,


      obscureText: obscure,


      keyboardType: keyboardType,


      validator: validator,



      decoration: InputDecoration(


        labelText: label,


        prefixIcon:

        Icon(

          icon,

          color: AppColors.primary,

        ),



        suffixIcon:

        suffix,



        filled: true,


        fillColor:

        Colors.white,



        contentPadding:

        const EdgeInsets.symmetric(

          horizontal:20,

          vertical:18,

        ),



        border:

        OutlineInputBorder(


          borderRadius:

          BorderRadius.circular(18),



          borderSide:

          const BorderSide(

            color:
            AppColors.border,

          ),


        ),



        enabledBorder:

        OutlineInputBorder(


          borderRadius:

          BorderRadius.circular(18),



          borderSide:

          const BorderSide(

            color:
            AppColors.border,

          ),


        ),




        focusedBorder:

        OutlineInputBorder(


          borderRadius:

          BorderRadius.circular(18),



          borderSide:

          const BorderSide(

            color:
            AppColors.primary,

            width:2,

          ),


        ),


      ),


    );


  }


}