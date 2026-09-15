import 'package:flutter/material.dart';


class FarmoraLogo extends StatelessWidget {


  final double? size;


  const FarmoraLogo({

    super.key,

    this.size,

  });



  @override
  Widget build(BuildContext context) {


    final width =
        MediaQuery.of(context).size.width;


    double logoSize;


    if(size != null){

      logoSize = size!;

    }

    else if(width < 600){

      logoSize = 90;

    }

    else if(width < 1200){

      logoSize = 130;

    }

    else {

      logoSize = 170;

    }




    return Image.asset(

      "assets/farmora_logo.png",

      width: logoSize,

      height: logoSize,

      fit: BoxFit.contain,

    );


  }

}