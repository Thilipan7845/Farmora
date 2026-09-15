class FarmerExplanation {

  final String messageKey;

  final Map<String, dynamic> parameters;


  FarmerExplanation({
    required this.messageKey,
    required this.parameters,
  });


  factory FarmerExplanation.fromJson(
      Map<String, dynamic> json
  ) {

    return FarmerExplanation(

      messageKey:
          json["message_key"] ?? "",


      parameters:
          Map<String, dynamic>.from(
            json["parameters"] ?? {},
          ),

    );

  }

}